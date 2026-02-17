/*
================================================================================
 Script:     hadr-physical-seeding-monitoring.sql

 Description:
     Monitora o progresso do Physical Seeding em ambientes Always On 
     Availability Groups.

     Exibe informações como:
         - Banco local e servidor remoto
         - Papel da réplica (Primary / Secondary)
         - Estado interno da sincronização
         - Taxa de transferência (MB/s)
         - Volume transferido (GB)
         - Tamanho total do banco (TB)
         - Percentual de conclusão
         - Status de compressão

 Usage:
     - Executar na instância participante do Availability Group
     - Utilizado para acompanhar sincronização inicial automática
     - Útil durante criação ou re-seeding de réplicas

 Notes:
     - Requer permissão VIEW SERVER STATE
     - Aplica-se somente a ambientes com Always On habilitado
     - Informações são válidas apenas enquanto o seeding estiver ativo
================================================================================
*/

SELECT local_database_name
	,remote_machine_name
	,role_desc
	,internal_state_desc
	,transfer_rate_bytes_per_second / 1024 / 1024 AS transfer_rate_MB_per_second
	,transferred_size_bytes / 1024 / 1024 / 1024 AS transferred_size_GB
	,database_size_bytes / 1024 / 1024 / 1024 / 1024 AS Database_Size_TB
	,is_compression_enabled
	,CONVERT(DECIMAL(5, 2), (transferred_size_bytes * 100.0 / NULLIF(database_size_bytes, 0))) AS Percent_Complete
FROM sys.dm_hadr_physical_seeding_stats;
