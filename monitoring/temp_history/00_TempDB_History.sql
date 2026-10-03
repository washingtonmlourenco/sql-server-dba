USE [DBAMonitoramento]
GO

ALTER TABLE [dbo].[TempDB_History] DROP CONSTRAINT [DF__TempDB_Hi__DtLog__1AD3FDA4]
GO

/****** Object:  Table [dbo].[TempDB_History]    Script Date: 03/10/2026 19:39:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempDB_History]') AND type in (N'U'))
DROP TABLE [dbo].[TempDB_History]
GO

/****** Object:  Table [dbo].[TempDB_History]    Script Date: 03/10/2026 19:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TempDB_History](
	[IDHistory] [bigint] IDENTITY(1,1) NOT NULL,
	[DtLog] [datetime] NOT NULL,
	[SessionID] [int] NOT NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[AllocatedKB] [bigint] NOT NULL,
	[AllocatedMB] [decimal](18, 2) NOT NULL,
	[AllocatedGB] [decimal](18, 2) NOT NULL,
	[CurrentCommand] [nvarchar](32) NULL,
	[QueryRunnig] [nvarchar](max) NULL,
	[CpuTime] [int] NULL,
	[Reads] [bigint] NULL,
	[Writes] [bigint] NULL,
	[WaitTime] [int] NULL,
	[WaitType] [nvarchar](60) NULL,
	[GrantedMemoryMB] [decimal](18, 2) NULL,
	[LogicalReads] [bigint] NULL,
	[StartTime] [datetime] NULL,
	[HostName] [nvarchar](128) NULL,
	[ProgramName] [nvarchar](128) NULL,
	[LoginName] [nvarchar](128) NULL,
	[SqlHandle] [varbinary](64) NULL,
	[QueryPlan] [xml] NULL,
	[TransactionIsolationLevel] [char](30) NULL,
	[RowCount] [bigint] NULL,
 CONSTRAINT [PK_TempDB_History] PRIMARY KEY CLUSTERED 
(
	[IDHistory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TempDB_History] ADD  DEFAULT (getdate()) FOR [DtLog]
GO


