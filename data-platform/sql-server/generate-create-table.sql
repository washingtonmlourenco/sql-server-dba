/*
===============================================================================
 Script:     generate-create-table.sql

 Description:
     Gera dinamicamente o script completo de criação de uma tabela a partir de uma tabela existente,
     incluindo:

         - Estrutura de colunas
         - Tipos de dados (com tamanho, precisão e escala)
         - Identity
         - Default constraints
         - Computed columns (persisted ou não)
         - Primary Key (clustered/nonclustered)
         - Índices (incluindo INCLUDE e filtros)

 Objetivo:
     - Realizar engenharia reversa de tabela
     - Replicar estrutura entre ambientes
     - Documentação técnica
     - Apoio em migrações e troubleshooting

 Observações:
     - Ajustar @SchemaName e @TableName antes da execução
     - O script apenas PRINTA o resultado (não executa automaticamente)
===============================================================================
*/


USE AdventureWorks2022;

SET NOCOUNT ON;
DECLARE @SchemaName SYSNAME = 'dbo';    -- ajuste se necessário
DECLARE @TableName SYSNAME  = 'Department'; -- ajuste para a sua tabela

DECLARE @object_id INT = OBJECT_ID(@SchemaName + '.' + @TableName);
IF @object_id IS NULL
BEGIN
    RAISERROR('Tabela %s.%s não encontrada', 16, 1, @SchemaName, @TableName);
    RETURN;
END;

DECLARE @Columns NVARCHAR(MAX);
SELECT @Columns = STUFF((
    SELECT ',' + CHAR(13) + '    ' +
        QUOTENAME(c.name) + ' ' +
        CASE 
            WHEN c.is_computed = 1 THEN 
                'AS ' + cc.definition + CASE WHEN cc.is_persisted = 1 THEN ' PERSISTED' ELSE '' END
            ELSE
                t.name +
                CASE 
                    WHEN t.name IN ('varchar','char','varbinary') 
                        THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR(10)) END + ')'
                    WHEN t.name IN ('nvarchar','nchar') 
                        THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST((c.max_length/2) AS VARCHAR(10)) END + ')'
                    WHEN t.name IN ('decimal','numeric') 
                        THEN '(' + CAST(c.[precision] AS VARCHAR(10)) + ',' + CAST(c.scale AS VARCHAR(10)) + ')'
                    WHEN t.name IN ('time','datetime2','datetimeoffset') 
                        THEN '(' + CAST(c.scale AS VARCHAR(10)) + ')'
                    ELSE ''
                END
                + CASE WHEN ic.column_id IS NOT NULL THEN ' IDENTITY(' + CAST(ic.seed_value AS VARCHAR(20)) + ',' + CAST(ic.increment_value AS VARCHAR(20)) + ')' ELSE '' END
                + CASE WHEN dc.definition IS NOT NULL THEN ' DEFAULT ' + dc.definition ELSE '' END
                + CASE WHEN c.is_nullable = 0 AND c.is_computed = 0 THEN ' NOT NULL' WHEN c.is_computed = 0 THEN ' NULL' ELSE '' END
        END
    FROM sys.columns c
    LEFT JOIN sys.computed_columns cc ON cc.object_id = c.object_id AND cc.column_id = c.column_id
    LEFT JOIN sys.default_constraints dc ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    LEFT JOIN sys.identity_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = @object_id
    ORDER BY c.column_id
    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1, 1, '');

DECLARE @CreateTable NVARCHAR(MAX) = 'CREATE TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' (' + CHAR(13) + @Columns + CHAR(13) + ');';

DECLARE @PK NVARCHAR(MAX) = '';
SELECT TOP(1)
    @PK = 'ALTER TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) +
          ' ADD CONSTRAINT ' + QUOTENAME(kc.name) + ' PRIMARY KEY ' +
          CASE WHEN i.type_desc LIKE '%CLUSTERED%' THEN 'CLUSTERED' ELSE 'NONCLUSTERED' END + ' (' +
            STUFF((
                SELECT ',' + QUOTENAME(col.name)
                FROM sys.index_columns ic
                JOIN sys.columns col ON col.object_id = ic.object_id AND col.column_id = ic.column_id
                WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
                ORDER BY ic.key_ordinal
                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1,1, '') +
          ');'
FROM sys.key_constraints kc
JOIN sys.indexes i ON kc.parent_object_id = i.object_id AND kc.unique_index_id = i.index_id
WHERE kc.parent_object_id = @object_id AND kc.[type] = 'PK';

DECLARE @Indexes NVARCHAR(MAX) = '';
SELECT @Indexes = ISNULL(@Indexes,'') + CHAR(13) +
    'CREATE ' + CASE WHEN i.is_unique = 1 THEN 'UNIQUE ' ELSE '' END + i.type_desc + ' INDEX ' + QUOTENAME(i.name) +
    ' ON ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' (' +
        STUFF((
            SELECT ',' + QUOTENAME(col.name)
            FROM sys.index_columns ic2
            JOIN sys.columns col ON col.object_id = ic2.object_id AND col.column_id = ic2.column_id
            WHERE ic2.object_id = i.object_id AND ic2.index_id = i.index_id AND ic2.is_included_column = 0
            ORDER BY ic2.key_ordinal
            FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1,1, '') +
    ')' +
    CASE WHEN EXISTS (SELECT 1 FROM sys.index_columns ic3 WHERE ic3.object_id = i.object_id AND ic3.index_id = i.index_id AND ic3.is_included_column = 1)
         THEN ' INCLUDE (' +
            STUFF((
                SELECT ',' + QUOTENAME(col2.name)
                FROM sys.index_columns ic3
                JOIN sys.columns col2 ON col2.object_id = ic3.object_id AND col2.column_id = ic3.column_id
                WHERE ic3.object_id = i.object_id AND ic3.index_id = i.index_id AND ic3.is_included_column = 1
                ORDER BY ic3.index_column_id
                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1,1, '') + ')'
         ELSE ''
    END +
    ISNULL(CASE WHEN i.filter_definition IS NOT NULL THEN ' WHERE ' + i.filter_definition ELSE '' END, '') + ';'
FROM sys.indexes i
WHERE i.object_id = @object_id AND i.is_primary_key = 0 AND i.type > 0
ORDER BY i.name;

PRINT @CreateTable;
IF @PK <> '' PRINT @PK;
IF @Indexes <> '' PRINT @Indexes;


