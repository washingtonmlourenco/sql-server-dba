# Monitoramento de Histórico da TempDB

Este repositório contém uma solução para automatizar a coleta, auditoria e armazenamento do histórico de utilização do banco de dados `TempDB`.

A solução tem como objetivo identificar sessões e consultas que apresentam maior consumo de espaço na `TempDB`, permitindo acompanhar o comportamento do ambiente ao longo do tempo e auxiliar na identificação de possíveis gargalos relacionados à utilização da `TempDB`, como contenção de páginas e excesso de alocações.

## Arquitetura e organização dos scripts

Os scripts foram separados por responsabilidade, facilitando a implantação e a manutenção da solução.

A execução deve seguir a ordem abaixo:

| Ordem  | Arquivo                            | Escopo    | Descrição                                                                                                                                                     |
| :----- | :--------------------------------- | :-------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **1º** | `00_TempDB_History.sql`            | Estrutura | Criação das tabelas utilizadas para armazenar os snapshots e o histórico coletado da `TempDB`.                                                                |
| **2º** | `01_sp_TempDB_History.sql`         | Coleta    | Criação da Stored Procedure responsável pela consulta das DMVs, identificação das sessões com maior utilização e gravação dos dados nas tabelas de histórico. |
| **3º** | `02_Job_DBA_sp_TempDB_History.sql` | Automação | Criação e configuração do Job do SQL Server Agent responsável pela execução periódica da Stored Procedure.                                                    |

## Detalhes da implementação

A coleta é realizada por meio das Dynamic Management Views (DMVs) do SQL Server, utilizando informações relacionadas à utilização da `TempDB` pelas sessões e consultas em execução.

A Stored Procedure concentra a lógica de coleta e persistência dos dados, permitindo que as informações sejam armazenadas para consultas posteriores, mesmo depois que a sessão ou consulta responsável pelo consumo já tenha sido encerrada.

Os scripts também possuem tratamento transacional para as operações de criação e configuração, incluindo validações de erro e utilização de `GOTO QuitWithRollback` para retorno ao estado anterior em caso de falha durante a execução.

## Job do SQL Server Agent

O arquivo `02_Job_DBA_sp_TempDB_History.sql` é responsável pela criação do Job `DBA - sp_TempDB_History` no SQL Server Agent.

O script realiza as validações e configurações necessárias no banco `msdb`, incluindo:

* validação da categoria do Job em `msdb.dbo.syscategories`;
* criação do Job;
* definição do proprietário por meio de `@owner_name=N''`;
* criação do Step responsável pela execução da Stored Procedure;
* configuração do comportamento do Job em caso de falha;
* definição dos parâmetros necessários para o registro e execução do Job.

O Step principal é configurado com `@on_fail_action=2`, fazendo com que a execução seja encerrada com indicação de falha caso ocorra algum erro.

## Como realizar o deploy

A implantação deve ser realizada na seguinte ordem:

1. Conecte-se à instância SQL Server utilizando o SSMS ou outra ferramenta compatível.
2. Execute o arquivo `00_TempDB_History.sql` para criar as tabelas utilizadas pela solução.
3. Execute o arquivo `01_sp_TempDB_History.sql` para criar a Stored Procedure responsável pela coleta.
4. Execute o arquivo `02_Job_DBA_sp_TempDB_History.sql` para criar o Job no SQL Server Agent.
5. Após a implantação, valide a criação do Job no SQL Server Agent e execute a Stored Procedure manualmente para confirmar a coleta dos dados.

## Requisitos de acesso

Como o terceiro script realiza operações no banco `msdb` utilizando as Stored Procedures do SQL Server Agent, a conta utilizada para o deployment precisa possuir as permissões necessárias para criação e configuração de Jobs.

Neste projeto, a execução do script de implantação é realizada com uma conta que possui `sysadmin`.

O nível de permissão necessário para a execução da Stored Procedure de coleta pode ser diferente do necessário para a criação do Job e deve ser avaliado de acordo com a configuração do ambiente.

## Objetivo do histórico

A principal finalidade da solução é transformar informações momentâneas das DMVs em um histórico que possa ser consultado posteriormente.

Isso permite analisar, por exemplo:

* quais sessões apresentaram maior consumo de `TempDB`;
* quais consultas estavam associadas a esse consumo;
* comportamento da utilização ao longo do tempo;
* possíveis períodos de maior utilização;
* consultas ou rotinas que podem estar contribuindo para problemas relacionados à `TempDB`.

Com esse histórico, a análise deixa de depender exclusivamente de uma coleta realizada durante o incidente, facilitando a investigação de problemas que ocorrem de forma intermitente.

# Referências

* **[Microsoft Learn — tempdb database (SQL Server)](https://microsoft.com)** — Documentação oficial sobre a arquitetura do banco de dados `TempDB`, alocação de objetos e propriedades físicas.
* **[Redgate Simple Talk — Mastering TempDB: Managing TempDB Growth](https://red-gate.com)** — Guia prático detalhando como diagnosticar o crescimento descontrolado e como reduzir arquivos com segurança.
* **[SQLShack — Monitoring SQL Server tempdb with Dynamic Management Views](https://sqlshack.com)** — Tutorial focado no uso de DMVs de sistema para monitorar o consumo de espaço por sessão e objeto.
* **[SQLShack — How to detect and prevent unexpected growth of the tempdb database](https://sqlshack.com)** — Análise de causas raiz e boas práticas para evitar que a `TempDB` lote o disco rigidamente.

A documentação oficial da Microsoft permanece como referência técnica para entender o funcionamente da TempDB e o comportamento dos recursos, os outros artigos são excelentes e, complementam a documentação da Microsoft com insights sobre monitoramento, troubleshooting e análise de performance.
