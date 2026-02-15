<h1 align="center">
🚀 SQL Server DBA | Performance & Troubleshooting
</h1>

<p align="center">
Scripts profissionais para administração e tuning de performance em Microsoft SQL Server
</p>

---

## 📊 GitHub Stats

<p align="center">
  <img height="160em" src="https://github-readme-stats.vercel.app/api?username=washingtonmlourenco&show_icons=true&theme=radical"/>
  <img height="160em" src="https://github-readme-stats.vercel.app/api/top-langs/?username=washingtonmlourenco&layout=compact&theme=radical"/>
</p>

---

## 🛠️ Tecnologias & Foco

<p align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-Performance-red?style=for-the-badge&logo=microsoftsqlserver)
![T-SQL](https://img.shields.io/badge/T--SQL-Optimization-blue?style=for-the-badge)
![DBA](https://img.shields.io/badge/DBA-Troubleshooting-green?style=for-the-badge)
![Azure](https://img.shields.io/badge/Azure-Cloud-blue?style=for-the-badge&logo=microsoftazure)

</p>

---

# 📂 Estrutura do Repositório

sql-server-dba/
│
├── performance/
│   ├── cpu/
│   ├── memory/
│   ├── indexes/
│   └── execution-plans/
│
├── maintenance/
│   ├── index-maintenance/
│   ├── statistics/
│   └── backups/
│
└── monitoring/
    ├── wait-stats/
    ├── blocking/
    └── io-analysis/
    
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

    B --> B1[CPU]
    B --> B2[Memory]
    B --> B3[Indexes]

    C --> C1[Rebuild Index]
    C --> C2[Update Stats]

    D --> D1[Wait Stats]
    D --> D2[Blocking]
    D --> D3[IO Analysis]
