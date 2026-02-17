/*
================================================================================
 Script:     blocking-analysis-and-live-progress.sql

 Description:
     Script completo para troubleshooting de sessões bloqueadas e
     acompanhamento de progresso de queries em execução.

     Inclui:

         1) Execução do sp_WhoIsActive filtrado por banco
         2) Construção de árvore hierárquica de bloqueio (Blocking Tree)
         3) Consulta de progresso em tempo real via sys.dm_exec_query_profiles

 Usage:
     - Executar em ambiente com sp_WhoIsActive instalado
     - Ajustar nome do banco (@filter)
     - Ajustar session_id na parte final (Live Query Progress)

 Notes:
     - Requer permissão VIEW SERVER STATE
     - Pode ser executada sem a sp_WhoIsActive
================================================================================
*/


EXEC sp_WhoIsActive @filter_type = 'database'
	,@filter = 'mydb';

IF OBJECT_ID('tempdb..#T', 'U') IS NOT NULL
BEGIN
	DROP TABLE #T
END
GO

SET NOCOUNT ON
GO

SELECT SPID
	,BLOCKED
	,REPLACE(REPLACE(T.TEXT, CHAR(10), ' '), CHAR(13), ' ') AS BATCH
INTO #T
FROM sys.sysprocesses R
CROSS APPLY sys.dm_exec_sql_text(R.SQL_HANDLE) T
GO

WITH BLOCKERS (
	SPID
	,BLOCKED
	,LEVEL
	,BATCH
	)
AS (
	SELECT SPID
		,BLOCKED
		,CAST(REPLICATE('0', 4 - LEN(CAST(SPID AS VARCHAR))) + CAST(SPID AS VARCHAR) AS VARCHAR(1000)) AS LEVEL
		,BATCH
	FROM #T R
	WHERE (
			BLOCKED = 0
			OR BLOCKED = SPID
			)
		AND EXISTS (
			SELECT *
			FROM #T R2
			WHERE R2.BLOCKED = R.SPID
				AND R2.BLOCKED <> R2.SPID
			)
	
	UNION ALL
	
	SELECT R.SPID
		,R.BLOCKED
		,CAST(BLOCKERS.LEVEL + RIGHT(CAST((1000 + R.SPID) AS VARCHAR(100)), 4) AS VARCHAR(1000)) AS LEVEL
		,R.BATCH
	FROM #T AS R
	INNER JOIN BLOCKERS ON R.BLOCKED = BLOCKERS.SPID
	WHERE R.BLOCKED > 0
		AND R.BLOCKED <> R.SPID
	)
SELECT N'    ' + REPLICATE(N'|         ', LEN(LEVEL) / 4 - 1) + CASE 
		WHEN (LEN(LEVEL) / 4 - 1) = 0
			THEN 'HEAD -  '
		ELSE '|------  '
		END + CAST(SPID AS NVARCHAR(10)) + N' ' + BATCH AS BLOCKING_TREE
FROM BLOCKERS
ORDER BY LEVEL ASC
GO

SELECT node_id
	,physical_operator_name
	,SUM(row_count) row_count
	,SUM(estimate_row_count) AS estimate_row_count
	,CAST(SUM(row_count) * 100 AS FLOAT) / SUM(estimate_row_count) percent_completed
FROM sys.dm_exec_query_profiles
WHERE session_id = (686)
GROUP BY node_id
	,physical_operator_name
ORDER BY node_id;
