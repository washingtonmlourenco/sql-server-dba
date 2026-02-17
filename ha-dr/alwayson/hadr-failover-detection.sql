/*
================================================================================
 Script:     hadr-failover-detection.sql

 Description:
     Verifica se ocorreram eventos de failover em ambientes Always On
     Availability Groups através da análise do erro 1480 nos arquivos
     Extended Events (AlwaysOn*.xel).

     O erro 1480 é registrado quando:
         - Um banco muda de papel (Primary/Secondary)
         - Ocorre failover manual ou automático
         - Há transição de sincronização relevante no AG

     O script:
         - Lê os arquivos AlwaysOn*.xel
         - Extrai timestamp UTC e horário local
         - Retorna número do erro e mensagem detalhada

 Usage:
     - Executar na instância participante do Availability Group
     - Utilizado para confirmar se houve failover
     - Pode ser usado para auditoria de alta disponibilidade

 Notes:
     - Requer permissão VIEW SERVER STATE
     - Depende da retenção dos arquivos Extended Events
     - Pode ser adaptado para monitoramento automatizado
================================================================================
*/

;

WITH cte_HADR
AS (
	SELECT object_name
		,CONVERT(XML, event_data) AS data
	FROM sys.fn_xe_file_target_read_file('AlwaysOn*.xel', NULL, NULL, NULL)
	WHERE object_name = 'error_reported'
	)
SELECT DATEADD(HOUR, DATEDIFF(HOUR, GETUTCDATE(), GETDATE()), data.value('(/event/@timestamp)[1]', 'datetime')) AS [timestamp_local]
	,data.value('(/event/@timestamp)[1]', 'datetime') AS [timestamp]
	,data.value('(/event/data[@name=''error_number''])[1]', 'int') AS [error_number]
	,data.value('(/event/data[@name=''message''])[1]', 'varchar(max)') AS [message]
FROM cte_HADR
WHERE data.value('(/event/data[@name=''error_number''])[1]', 'int') = 1480
ORDER BY 1 DESC
