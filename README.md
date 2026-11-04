<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:CC2927,100:8B0000&height=180&text=SQL%20Server%20DBA&fontSize=48&fontColor=ffffff&animation=fadeIn&fontAlignY=42" width="100%" alt="header"/>

</div>

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-2016%20|%202019%20|%202022-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-Production%20Ready-0078D4?style=flat-square&logo=microsoft&logoColor=white)
![License](https://img.shields.io/github/license/washingtonmlourenco/sql-server-dba?style=flat-square&color=green)
![Last Commit](https://img.shields.io/github/last-commit/washingtonmlourenco/sql-server-dba?style=flat-square&color=informational)
![Stars](https://img.shields.io/github/stars/washingtonmlourenco/sql-server-dba?style=flat-square)

</div>

---

A structured collection of T-SQL scripts for Microsoft SQL Server administration, covering performance analysis, maintenance routines, monitoring, high availability, and security — built from real-world production experience.

All scripts are designed to run safely in production environments. Read the inline comments before executing.

---

## Contents

- [Performance](#performance)
- [Maintenance](#maintenance)
- [Monitoring](#monitoring)
- [High Availability & DR](#high-availability--dr)
- [Security](#security)
- [Data Platform](#data-platform)
- [Usage](#usage)
- [Author](#author)

---

## Performance

Scripts for diagnosing and resolving CPU, memory, I/O, and query plan bottlenecks.

| Script | Description |
|--------|-------------|
| [`cpu/cpu-top-10-consumo.sql`](performance/cpu/cpu-top-10-consumo.sql) | Top 10 queries by CPU consumption from plan cache |
| [`cpu/instance-cpu-info.sql`](performance/cpu/instance-cpu-info.sql) | Instance-level CPU usage and scheduler metrics |
| [`memory/memory-process-overview.sql`](performance/memory/memory-process-overview.sql) | Memory clerks, buffer pool usage and cache breakdown |
| [`memory/memory-non-bufferpool-usage.sql`](performance/memory/memory-non-bufferpool-usage.sql) | Non-buffer pool memory consumers |

---

## Maintenance

Recurring DBA routines for statistics, backups, and database integrity.

| Script | Description |
|--------|-------------|
| [`backup/backup-database-dynamic.sql`](maintenance/backup/backup-database-dynamic.sql) | Dynamic full backup with path generation |
| [`backup/sp_BackupFull.sql`](maintenance/backup/sp_BackupFull.sql) | Stored procedure for automated full backups |
| [`update_stats/update-statistics-analysis.sql`](maintenance/update_stats/update-statistics-analysis.sql) | Statistics age and last update analysis |
| [`update_stats/statistics-sampling-analysis.sql`](maintenance/update_stats/statistics-sampling-analysis.sql) | Sampling rate review per object |

---

## Monitoring

Scripts for real-time and historical monitoring of sessions, waits, blocks, deadlocks, and TempDB.

| Script | Description |
|--------|-------------|
| [`wait-stats/wait-types-top-analysis.sql`](monitoring/wait-stats/wait-types-top-analysis.sql) | Top wait types since last SQL Server restart |
| [`Blocking/blocking-analysis-and-live-progress.sql`](monitoring/Blocking/blocking-analysis-and-live-progress.sql) | Live blocking chain analysis with head blocker identification |
| [`DeadLock/deadlock-history-from-system_health.sql`](monitoring/DeadLock/deadlock-history-from-system_health.sql) | Historical deadlock extraction from system_health XEvent |
| [`temp_history/00_TempDB_History.sql`](monitoring/temp_history/00_TempDB_History.sql) | TempDB usage history table and setup |
| [`temp_history/01_sp_TempDB_History.sql`](monitoring/temp_history/01_sp_TempDB_History.sql) | Stored procedure to capture TempDB snapshots |
| [`temp_history/02_Job_DBA_sp_TempDB_History.sql`](monitoring/temp_history/02_Job_DBA_sp_TempDB_History.sql) | SQL Agent job to schedule TempDB monitoring |

---

## High Availability & DR

AlwaysOn AG monitoring and failover detection scripts for production HA environments.

| Script | Description |
|--------|-------------|
| [`alwayson/hadr-physical-seeding-monitoring.sql`](ha-dr/alwayson/hadr-physical-seeding-monitoring.sql) | Monitor physical seeding progress across replicas |
| [`alwayson/hadr-failover-detection.sql`](ha-dr/alwayson/hadr-failover-detection.sql) | Detect and audit failover events in the AG |

---

## Security

Auditing and user management scripts for SQL Server security reviews.

| Script | Description |
|--------|-------------|
| [`users/database-user-login-mapping-audit.sql`](security/users/database-user-login-mapping-audit.sql) | Full audit of database users, login mappings and roles |

---

## Data Platform

Utility scripts for database management and CDC configuration.

| Script | Description |
|--------|-------------|
| [`sql-server/generate-create-table.sql`](data-platform/sql-server/generate-create-table.sql) | Generate CREATE TABLE scripts dynamically |
| [`sql-server/drop-all-tables.sql`](data-platform/sql-server/drop-all-tables.sql) | Drop all tables with FK dependency resolution |
| [`sql-server/add-filegroup.sql`](data-platform/sql-server/add-filegroup.sql) | Add and configure a new filegroup |
| [`sql-server/rename-database.sql`](data-platform/sql-server/rename-database.sql) | Safe database rename procedure |
| [`cdc/cdc-config.sql`](data-platform/cdc/cdc-config.sql) | Enable and configure Change Data Capture |

---

## Usage

Clone the repository and run scripts directly in SSMS or Azure Data Studio connected to your target instance.

```bash
git clone https://github.com/washingtonmlourenco/sql-server-dba.git
```

> Scripts are organized by operational domain. Each file includes inline comments explaining prerequisites, expected outputs, and any configuration parameters.

No external dependencies or stored procedures required unless noted in the script header.

---

## Author

**Washington M. Lourenço** — SQL Server DBA

[![LinkedIn](https://img.shields.io/badge/LinkedIn-washington--lourenco-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://br.linkedin.com/in/washington-lourenco/)
[![GitHub](https://img.shields.io/badge/GitHub-washingtonmlourenco-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/washingtonmlourenco)

<div align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:CC2927,100:8B0000&height=80&section=footer" width="100%" alt="footer"/>
</div>
