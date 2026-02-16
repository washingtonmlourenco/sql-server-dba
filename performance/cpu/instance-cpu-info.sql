/*
================================================================================
 Script:     instance-cpu-info.sql
 Source:
     Baseado em exemplos de diagnóstico de CPU e informações de instância
     da documentação Microsoft e AWS Prescriptive Guidance.

 References:
     - Microsoft Docs: Configure the MAXDOP server configuration option
       https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/configure-the-max-degree-of-parallelism-server-configuration-option?view=sql-server-ver16
     - AWS Prescriptive Guidance: MAXDOP best practices in SQL Server EC2
       https://docs.aws.amazon.com/prescriptive-guidance/latest/sql-server-ec2-best-practices/maxdop.html

 Description:
     Retorna informações da instância SQL Server relacionadas a CPU,
     topologia NUMA, número de sockets e dados que podem ser usados
     como referência para configurar MAXDOP e outras opções.
 
 Notes:
     - Útil para entender como a instância está distribuída em termos
       de CPUs, NUMA e topologia do hardware.
     - Esses dados podem ajudar a definir valores recomendados de MAXDOP
       (especialmente quando comparados com guidelines oficiais).
================================================================================
*/


SELECT @@SERVERNAME InstanceName
	,SERVERPROPERTY('ComputerNamePhysicalNetBIOS') Hostname
	,SERVERPROPERTY('ProductVersion') AS ProductVersion
	,cpu_count
	,hyperthread_ratio
	,softnuma_configuration
	,softnuma_configuration_desc
	,socket_count
	,numa_node_count
	,(cpu_count / numa_node_count) ReferenceNumberForMaxDop
FROM sys.dm_os_sys_info
