USE [DBAMonitoramento]
GO

/****** Object:  StoredProcedure [dbo].[sp_TempDB_History]    Script Date: 03/10/2026 19:41:34 ******/
DROP PROCEDURE [dbo].[sp_TempDB_History]
GO

/****** Object:  StoredProcedure [dbo].[sp_TempDB_History]    Script Date: 03/10/2026 19:41:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sp_TempDB_History] AS
   BEGIN
    SET NOCOUNT ON;

        INSERT INTO TempDB_History (
        [SessionID],
        [DatabaseName],
        [AllocatedKB],
        [AllocatedMB],
        [AllocatedGB],
        [CurrentCommand],
        [QueryRunnig],
        [CpuTime],
        [Reads],
        [Writes],
        [WaitTime],
        [WaitType], 
        [GrantedMemoryMB],
        [LogicalReads],
        [StartTime],
        [HostName],
        [ProgramName],
        [LoginName],
        [SqlHandle],
        [QueryPlan],
        [TransactionIsolationLevel],
        [RowCount]
)  
SELECT 
    s.session_id        [SessionID],
    DB_NAME(COALESCE(r.database_id, s.database_id)) AS [DatabaseName],
    (su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count +
     COALESCE(tu.task_alloc, 0)) * 8 AS [AllocatedKB],
    CAST((su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count +
          COALESCE(tu.task_alloc, 0)) * 8 / 1024.0 AS DECIMAL(18,2)) AS [AllocatedMB],
    CAST((su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count +
          COALESCE(tu.task_alloc, 0)) * 8 / 1024.0 / 1024.0 AS DECIMAL(18,2)) AS [AllocatedGB],
    r.command AS [CurrentCommand],
    COALESCE(
        SUBSTRING(st.text, (r.statement_start_offset/2)+1,   
            ((CASE r.statement_end_offset   
              WHEN -1 THEN DATALENGTH(st.text)  
             ELSE r.statement_end_offset END - r.statement_start_offset)/2) + 1), 
        st.text
    ) AS [QueryRunnig],
    r.cpu_time          [CpuTime],
    r.reads             [Reads],
    r.writes            [Writes],
    r.wait_time         [WaitTime],
    r.wait_type         [WaitType],
    CAST(r.granted_query_memory * 8 / 1024.0 AS DECIMAL(18,2)) AS [GrantedMemoryMB],
    r.logical_reads     [LogicalReads],
    r.start_time        [StartTime],
    s.host_name         [HostName],
    s.program_name      [ProgramName],
    s.login_name        [LoginName],
    r.sql_handle        [SqlHandle],
    qp.query_plan       [QueryPlan],
    CASE 
        WHEN r.transaction_isolation_level = 0 THEN '0 = Unspecified'
        WHEN r.transaction_isolation_level = 1 THEN '1 = ReadUncommitted'
        WHEN r.transaction_isolation_level = 2 THEN '2 = ReadCommitted'
        WHEN r.transaction_isolation_level = 3 THEN '3 = Repeatable'
        WHEN r.transaction_isolation_level = 4 THEN '4 = Serializable'
        WHEN r.transaction_isolation_level = 5 THEN '5 = Snapshot'
    END  [TransactionIsolationLevel],
    r.row_count         [RowCount]
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_db_session_space_usage su ON s.session_id = su.session_id
LEFT JOIN (
    SELECT 
        session_id, 
        SUM(user_objects_alloc_page_count + internal_objects_alloc_page_count) AS task_alloc
    FROM sys.dm_db_task_space_usage
    GROUP BY session_id
) tu ON s.session_id = tu.session_id
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(COALESCE(r.sql_handle, (SELECT TOP 1 sql_handle FROM sys.dm_exec_connections WHERE session_id = s.session_id))) st
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) qp
WHERE s.session_id > 50
  AND (su.user_objects_alloc_page_count + su.internal_objects_alloc_page_count + COALESCE(tu.task_alloc, 0)) > 0
ORDER BY [AllocatedKB] DESC
END


--EXEC sp_TempDB_History

--SELECT  * FROM TempDB_History
GO


