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
