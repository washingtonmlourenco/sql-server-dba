/*
================================================================================
 Script:     memory-non-bufferpool-usage.sql

 Source:
     Exemplo apresentado no curso de SQL Server Internals
     por Fabiano Amorim.

 Description:
     Retorna o total de memória (em MB) utilizada por componentes do SQL Server
     que NÃO pertencem ao Buffer Pool.

        Isso inclui:
         - Plan Cache
         - CLR
         - Query Store
         - Locks
         - Memory Grants
         - Outras estruturas internas

     Útil para análise de consumo de memória fora do MEMORYCLERK_SQLBUFFERPOOL
     em cenários de troubleshooting e memory pressure.

 Notes:
     - Utiliza a DMV sys.dm_os_memory_clerks.
     - Valores representam o momento atual da instância.
     - Pode variar conforme workload e versão do SQL Server.

================================================================================
*/

SELECT SUM(pages_kb + virtual_memory_committed_kb + shared_memory_committed_kb) / 1024. AS [NonBPData_MB]
FROM sys.dm_os_memory_clerks
WHERE type <> 'MEMORYCLERK_SQLBUFFERPOOL';
GO


