/*
================================================================================
 Script:     statistics-sampling-analysis.sql

 Description:
     Analisa o nível de amostragem das estatísticas no banco atual utilizando
     sys.dm_db_stats_properties.

     Identifica estatísticas que:
         - Possuem menos de 50% das linhas amostradas
         - Podem estar imprecisas para o otimizador
     
     Gera comando dinâmico de:
         UPDATE STATISTICS <table> (<stats_name>) WITH FULLSCAN, MAXDOP = 2

 Usage:
     - Executar no banco desejado
     - Revisar comandos gerados antes da execução
     - Pode ser adaptado para execução automatizada

 Notes:
     - FULLSCAN aumenta precisão do Cardinality Estimator
     - MAXDOP = 2 reduz impacto em ambientes OLTP
     - Ajustar percentual (50%) conforme política de manutenção
================================================================================
*/

WITH stat
AS (
	SELECT OBJECT_SCHEMA_NAME(obj.object_id) SchemaName
		,obj.name TableName
		,stat.name
		,modification_counter
		,[rows]
		,rows_sampled
		,rows_sampled * 100 / [rows] AS [% Rows Sampled]
		,last_updated
	FROM sys.objects AS obj
	INNER JOIN sys.stats AS stat ON stat.object_id = obj.object_id
	CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
	WHERE obj.is_ms_shipped = 0
	)
SELECT TableName
	,'update statistics ' + TableName + ' (' + name + ') WITH FULLSCAN, MAXDOP = 2;' AS command
	,[% Rows Sampled]
	,rows
	,last_updated
FROM stat
WHERE rows_sampled * 100 / [rows] < 50
--AND TableName in ('')
ORDER BY rows

