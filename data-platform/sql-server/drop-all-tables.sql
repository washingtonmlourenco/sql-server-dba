/*
===============================================================================
 Script:     drop-all-tables.sql

 Description:
     Remove todas as Foreign Keys e todas as tabelas
     do banco de dados atual.

     O script:
         - Gera dinamicamente comandos para remover FKs
         - Remove todas as constraints de chave estrangeira
         - Exclui todas as tabelas do banco

 Objetivo:
     - Reset completo de ambiente
     - Limpeza para recriação de estrutura
     - Uso em ambientes de desenvolvimento ou homologação

 ⚠ Atenção:
     - Destrutivo e irreversível
     - Não executar em produção
     - Garantir backup antes da execução
     - Use somente em casos muito específicos
===============================================================================
*/

USE DBA3;
GO

SET NOCOUNT ON;


DECLARE @DropFK NVARCHAR(MAX) = '';

SELECT @DropFK += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
                  ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys;

PRINT 'Dropping all Foreign Keys...';
EXEC sp_executesql @DropFK;

DECLARE @DropTables NVARCHAR(MAX) = '';

SELECT @DropTables += 'DROP TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) + '.' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.tables;

PRINT 'Dropping all Tables...';
EXEC sp_executesql @DropTables;
