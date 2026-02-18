/*
====================================================================
 Script:     cdc-config.sql

 Description:
     Script para gerenciamento completo do Change Data Capture (CDC)
     no SQL Server.

     Inclui:
         - Habilitar CDC no banco de dados
         - Desabilitar CDC no banco
         - Habilitar CDC em tabela específica
         - Desabilitar CDC em tabela
         - Consultar capture_instance
         - Iniciar e parar job de captura
         - Validar tabelas monitoradas
         - Verificar se o CDC está ativo na base

 Objetivo:
     Auditoria de alterações, integração com ETL,
     rastreamento de mudanças e replicação lógica.

 Observações:
     - Requer SQL Server Agent habilitado
     - Necessário permissão sysadmin ou db_owner
     - Pode gerar crescimento de log e tabelas CDC
====================================================================
*/

--Habilita CDC a nível de banco de dados
USE AdventureWorks2022;
EXEC sys.sp_cdc_enable_db;


-- Desativar CDC para o banco de dados
USE AdventureWorks2022;
EXEC sys.sp_cdc_disable_db;

-- Habilitar o CDC em uma tabela específica:
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo', 
    @source_name = N'ErrorLog',
    @role_name= NULL,
    @filegroup_name= N'FLG_CDC',
    @supports_net_changes=1;
   
-- Validar nome da @capture_instance

EXEC sys.sp_cdc_help_change_data_capture


-- Desativar CDC para uma tabela específica
USE AdventureWorks2022;
EXEC sys.sp_cdc_disable_table
    @source_schema = 'dbo',
    @source_name = 'ErrorLog',
    @capture_instance = 'dbo_ErrorLog';


--Iniciar a captura de alterações e parar job capture:
USE AdventureWorks2022;

EXEC sys.sp_cdc_start_job;

EXECUTE sys.sp_cdc_stop_job @job_type = N'capture';
GO

  
--listar todas as tabelas com o CDC
SELECT [name] AS TableName, is_tracked_by_cdc
FROM sys.tables
WHERE is_tracked_by_cdc = 1 
AND [name] in ('ErrorLog')


--verificar se o CDC está habilitado na base de dados.
SELECT is_cdc_enabled
FROM sys.databases
WHERE name = 'AdventureWorks2022';
