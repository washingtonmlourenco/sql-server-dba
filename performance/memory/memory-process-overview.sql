/*
================================================================================
 Script:     memory-process-overview.sql
 Description:
     Retorna métricas detalhadas de memória utilizada pelo processo do SQL Server
     incluindo memória física, memória virtual, páginas grandes e Locked Pages.
     Útil para monitoramento e troubleshooting de pressão de memória.

 Notes:
     - Baseado nas DMVs sys.dm_os_process_memory
     - Valores convertidos para MB e GB para melhor visualização
     - Permite identificar consumo real e espaço restante para alocações
================================================================================
*/

SELECT 
       physical_memory_in_use_kb / 1024. AS Actual_Usage_MB,               
       physical_memory_in_use_kb / (1024. * 1024.) AS Actual_Usage_GB,     
       virtual_address_space_committed_kb / 1024. AS VAS_Committed,        
       virtual_address_space_reserved_kb / 1024. AS VAS_Reserved,          
       total_virtual_address_space_kb / 1024. AS VAS_Total,                
       (large_page_allocations_kb + locked_page_allocations_kb + physical_memory_in_use_kb) / 1024. AS Actual_Physical_Memory_MB, 
       (virtual_address_space_committed_kb - physical_memory_in_use_kb) / 1024. AS MemToLeave_MB
                                                                             
FROM sys.dm_os_process_memory;
GO
SELECT 
       physical_memory_in_use_kb / 1024 AS sql_physical_memory_in_use_MB,      
       large_page_allocations_kb / 1024 AS sql_large_page_allocations_MB,      
       locked_page_allocations_kb / 1024 AS sql_locked_page_allocations_MB,    
       virtual_address_space_reserved_kb / 1024 AS sql_VAS_reserved_MB,        
       virtual_address_space_committed_kb / 1024 AS sql_VAS_committed_MB,      
       virtual_address_space_available_kb / 1024 AS sql_VAS_available_MB,      
       page_fault_count AS sql_page_fault_count,                               
       memory_utilization_percentage AS sql_memory_utilization_percentage,     
       process_physical_memory_low AS sql_process_physical_memory_low,         
       process_virtual_memory_low AS sql_process_virtual_memory_low            
FROM sys.dm_os_process_memory;
GO
