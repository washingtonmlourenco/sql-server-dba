<h1 align="center">
🚀 SQL Server DBA | Performance & Troubleshooting
</h1>

<p align="center">
Scripts profissionais para administração e tuning de performance em Microsoft SQL Server
</p>


## 📊 GitHub Stats

<p align="center">
  <a href="https://git.io/awesome-stats-card">
    <img 
      width="600"
      alt="Washington Lourenço GitHub Stats"
      src="https://awesome-github-stats.azurewebsites.net/user-stats/washingtonmlourenco?cardType=level-alternate&theme=vue-dark&preferLogin=false&v=1"
    />
  </a>
</p>

## 🛠️ Tecnologias & Foco

<div align="center">

<img src="https://img.shields.io/badge/SQL%20Server-Performance-red?style=for-the-badge&logo=microsoftsqlserver" />
&nbsp;
<img src="https://img.shields.io/badge/T--SQL-Optimization-blue?style=for-the-badge" />
&nbsp;
<img src="https://img.shields.io/badge/DBA-Troubleshooting-green?style=for-the-badge" />

</div>

---

# 📂 Estrutura do Repositório
```
sql-server-dba/
│
├── performance/
│   ├── cpu/
│   ├── memory/
│   ├── indexes/
│   ├── execution-plans/
│   └── compression/
│
├── maintenance/
│   ├── index-maintenance/
│   ├── statistics/
│   ├── backups/
│   └── integrity-checks/
│
├── monitoring/
│   ├── wait-stats/
│   ├── blocking/
│   ├── deadlocks/
│   └── io-analysis/
│
├── security/
│   ├── users/
│   ├── roles/
│   ├── permissions/
│   └── auditing/
│
├── ha-dr/
│   ├── alwayson/
│   ├── log-shipping/
│   ├── replication/
│   └── restore-scenarios/
│
└── data-platform/
    ├── cdc/
    ├── etl/
    ├── azure/
    └── aws/
```    
---

## 🔥 Performance Tuning
- Configuração de MAXDOP
- Cost Threshold for Parallelism
- Análise de Wait Stats
- Identificação de gargalos de CPU
- Otimização de planos de execução

## 💾 Memory & I/O
- Configuração de Max Server Memory
- Buffer Pool analysis
- Page Life Expectancy
- Diagnóstico de I/O

## 📈 Índices
- Missing Index detection
- Fragmentação
- Rebuild / Reorganize strategy
- Estatísticas

## 🛡️ Troubleshooting
- Blocking
- Deadlocks
- Queries lentas
- Análise de sessões ativas

---

# 🧠 Arquitetura de Organização

```mermaid
flowchart TD
    A[SQL Server Instance] --> B[Performance]
    A --> C[Maintenance]
    A --> D[Monitoring]
    A --> E[Security]
    A --> F[HA/DR]

    B --> B1[CPU]
    B --> B2[Memory]
    B --> B3[Indexes]

    C --> C1[Rebuild Index]
    C --> C2[Statistics]
    C --> C3[Backups]

    D --> D1[Wait Stats]
    D --> D2[Blocking]
    D --> D3[IO Analysis]

    E --> E1[Users & Roles]
    E --> E2[Permissions]

    F --> F1[AlwaysOn]
    F --> F2[Restore Strategy]
