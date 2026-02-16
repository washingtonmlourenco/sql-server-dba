/*
================================================================================
 Script:     backup-database-dynamic.sql

 Description:
     Realiza backup do banco de dados atual dinamicamente, criando o arquivo
     com data e hora no nome. Inclui compressão e exibe progresso a cada 5%.

 Usage:
     - Pode ser agendado em SQL Server Agent Jobs
     - Backup será salvo no caminho definido em @CAMINHO
     - Gera arquivo: <DatabaseName>_YYYY-MM-DD_HH-MM-SS.BAK

 Notes:
     - Ajuste o caminho @CAMINHO conforme sua política de backup
     - Requer permissão de escrita no diretório informado
================================================================================
*/

DECLARE @DATABASENAME VARCHAR(MAX)
DECLARE @CAMINHO VARCHAR(MAX)
DECLARE @DATA VARCHAR(100)

SET @DATABASENAME = DB_NAME()
SET @CAMINHO = N'D:\temp\'
SET @DATA = REPLACE(CONVERT(VARCHAR(100), GETDATE(), 120), ' ', '_')
SET @DATA = REPLACE(@DATA, ':', '_')

DECLARE @SQLCOMMAND NVARCHAR(MAX) = ''

SET @SQLCOMMAND = 'BACKUP DATABASE ' + QUOTENAME(@DATABASENAME) + ' TO DISK = ''' + @CAMINHO + @DATABASENAME + '_' + @DATA + '.BAK'' WITH COMPRESSION, STATS = 5'

--PRINT @SQLCOMMAND

EXEC sp_executesql @SQLCOMMAND

