/*
============================================================
 Script:     rename-database.sql

 Description:
     Renomeia o banco de dados DBA2 para DBA3.

     O script:
         - Coloca o banco em SINGLE_USER com ROLLBACK IMMEDIATE
           (forçando desconexão de sessões ativas)
         - Altera o nome do banco
         - Retorna o banco para MULTI_USER

 Observação:
     Executar fora do banco que será renomeado (ex: master).
     Garantir que não haja processos críticos conectados.
============================================================
*/

USE master;  
GO  
ALTER DATABASE DBA2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE DBA2 MODIFY NAME = DBA3;
GO  
ALTER DATABASE DBA3 SET MULTI_USER;
GO
