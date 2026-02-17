/*
================================================================================
 Script:     update-statistics-analysis.sql

 Description:
     Analisa todas as tabelas do banco atual, verificando:
         - Quantidade de linhas
         - Quantidade de estatísticas
         - Data mínima e máxima de atualização das estatísticas

     Gera dinamicamente o comando UPDATE STATISTICS WITH FULLSCAN
     para tabelas que:

         - Possuem estatísticas
         - Estão há mais de 7 dias sem atualização
         - Possuem menos de 5 milhões de linhas

 Usage:
     - Executar no banco de dados desejado
     - Pode ser adaptado para SQL Server Agent Job
     - Revisar lista antes de executar os comandos gerados

 Notes:
     - Ajustar o limite de dias (DATEADD)
     - Ajustar limite de volume de linhas conforme ambiente
     - FULLSCAN pode impactar performance em horários críticos
================================================================================
*/

IF OBJECT_ID('tempdb..#Tabs') IS NOT NULL
	DROP TABLE #Tabs;

SELECT DBName = DB_NAME()
	,ObjName = QUOTENAME(Q.name) + '.' + QUOTENAME(T.name)
	,R.rows
	,S.TotalStats
	,S.MinUp
	,S.MaxUp
INTO #Tabs
FROM sys.tables T
CROSS APPLY (
	SELECT rows = SUM(P.rows)
	FROM sys.partitions P
	WHERE P.index_id <= 1
		AND P.object_id = T.object_id
	) R
CROSS APPLY (
	SELECT TotalStats = COUNT(*)
		,MinUp = MIN(STATS_DATE(S.object_id, S.stats_id))
		,MaxUp = MAX(STATS_DATE(S.object_id, S.stats_id))
	FROM sys.stats S
	WHERE S.object_id = T.object_id
	) S
INNER JOIN sys.schemas Q ON Q.schema_id = T.schema_id;

SELECT *
FROM #Tabs
ORDER BY MaxUp DESC;

SELECT *
	,'USE ' + QUOTENAME(DBName) + '; UPDATE STATISTICS ' + ObjName + ' WITH FULLSCAN' AS UpdateCommand
FROM #Tabs
WHERE TotalStats >= 1
	AND MaxUp <= DATEADD(dd, - 7, GETDATE())
	AND DBName = DB_NAME()
	AND rows < 5000000
ORDER BY rows DESC;


-- Caso ocorra erro de collation, utilize a versão abaixo:

/*
USE ' + QUOTENAME(DBName) COLLATE Latin1_General_BIN + 
'; UPDATE STATISTICS ' + ObjName + 
' WITH FULLSCAN' AS UpdateCommand
*/
