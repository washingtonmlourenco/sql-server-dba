/*
================================================================================
 Script:     deadlock-history-from-system_health.sql

 Description:
      Extrai histórico de deadlocks a partir do Extended Event padrão
     "system_health", sem necessidade de sessão customizada.

     O script:
         - Localiza automaticamente o caminho do arquivo .xel
         - Lê os eventos xml_deadlock_report
         - Converte o timestamp UTC para horário local
         - Retorna o XML completo do deadlock

 Usage:
     - Executar na instância desejada
     - Pode ser adaptado para criação de tabela histórica permanente
     - Útil para troubleshooting de deadlocks intermitentes

 Notes:
     - Depende do Extended Event system_health
     - O histórico depende do tamanho configurado do arquivo .xel
     - Pode gerar grande volume em ambientes com alta contenção
================================================================================
*/

SET QUOTED_IDENTIFIER ON;

DECLARE @xelfilepath NVARCHAR(260)

SELECT @xelfilepath = dosdlc.path
FROM sys.dm_os_server_diagnostics_log_configurations AS dosdlc;

SELECT @xelfilepath = @xelfilepath + N'system_health_*.xel'

DROP TABLE

IF EXISTS DeadlockHistory
	SELECT CONVERT(XML, event_data) AS EventData
	INTO DeadlockHistory
	FROM sys.fn_xe_file_target_read_file(@xelfilepath, NULL, NULL, NULL)
	WHERE object_name = 'xml_deadlock_report'

SELECT EventData.value('(event/@timestamp)[1]', 'datetime2(7)') AS UtcTime
	,CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET, EventData.value('(event/@timestamp)[1]', 'VARCHAR(50)')), DATENAME(TzOffset, SYSDATETIMEOFFSET()))) AS LocalTime
	,EventData.query('event/data/value/deadlock') AS XmlDeadlockReport
FROM DeadlockHistory
ORDER BY UtcTime DESC;
