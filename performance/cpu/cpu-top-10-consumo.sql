/*
================================================================================
 Script:     cpu-top-10-queries-by-worker-time.sql
 Source:
     Consulta baseada em exemplo público disponível em:
     https://dbasqlserverbr.com.br/consultas-que-estao-consumindo-mais-cpu-no-sql-server/

 Description:
     Retorna as 10 queries com maior consumo acumulado de CPU (worker time)
     desde o último restart da instância do SQL Server.

 Notes:
     - Utiliza DMVs sys.dm_exec_query_stats,
       sys.dm_exec_sql_text e sys.dm_exec_query_plan.
     - Script de diagnóstico para identificar queries que mais impactam a CPU.
================================================================================
*/


SELECT TOP 10
       SUBSTRING(qt.TEXT, (qs.statement_start_offset / 2) + 1,
       ((CASE qs.statement_end_offset
              WHEN -1 THEN DATALENGTH(qt.TEXT)
              ELSE qs.statement_end_offset
       END - qs.statement_start_offset) / 2) + 1),
       qs.execution_count,
       qs.total_logical_reads,
       qs.last_logical_reads,
       qs.total_logical_writes,
       qs.last_logical_writes,
       qs.total_worker_time,
       qs.last_worker_time,
       qs.total_elapsed_time / 1000000 total_elapsed_time_in_S,
       qs.last_elapsed_time / 1000000 last_elapsed_time_in_S,
	   qs.creation_time,
       qs.last_execution_time,
       qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_worker_time DESC
