/*
====================================================================
 Script:     add-filegroup.sql

 Description:
     Adiciona novos FILEGROUPS (DATA e INDEX) ao banco
     AdventureWorks2022 e cria arquivos secundários (.ndf)
     para separação física de dados e índices.

     O script:
         - Cria FILEGROUP [DATA]
         - Adiciona arquivo .ndf para dados
         - Cria FILEGROUP [INDEX]
         - Adiciona arquivo .ndf para índices

 Objetivo:
     - Separar dados e índices fisicamente
     - Melhorar estratégia de I/O
     - Organizar crescimento e alocação de arquivos
     - Preparar ambiente para melhor performance

 Observações:
     - Ajustar caminhos conforme padrão do servidor
     - Validar espaço em disco antes da execução
     - Executar no contexto do master
====================================================================
*/

USE [master]
GO
ALTER DATABASE [AdventureWorks2022] ADD FILEGROUP [DATA]
GO
ALTER DATABASE [AdventureWorks2022] ADD FILE ( NAME = N'AdventureWorks2022_DATA', FILENAME = N'D:\DATA\AdventureWorks2022_Data2.ndf' , SIZE = 102400KB , FILEGROWTH = 262144KB ) TO FILEGROUP [DATA]
GO
ALTER DATABASE [AdventureWorks2022] ADD FILEGROUP [INDEX]
GO
ALTER DATABASE [AdventureWorks2022] ADD FILE ( NAME = N'AdventureWorks2022_INDEX', FILENAME = N'D:\INDEX\AdventureWorks2022_Index.ndf' , SIZE = 102400KB , FILEGROWTH = 262144KB ) TO FILEGROUP [INDEX]
GO

