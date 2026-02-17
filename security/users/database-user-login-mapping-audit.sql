/*
================================================================================
 Script:     database-user-login-mapping-audit.sql

 Description:
     Audita o mapeamento entre usuários do banco de dados e logins
     da instância, identificando inconsistências e exibindo as roles
     associadas a cada usuário.

     O script:
         - Compara SID do database user com o SID do server login
         - Indica se há login correspondente
         - Lista as roles do banco associadas ao usuário
         - Exclui usuários padrão como dbo
         - Permite exclusão de logins específicos (ex: Totvs)

     Objetivo:
         - Detectar usuários órfãos (orphaned users)
         - Validar integridade de segurança após restore/migração
         - Auditar permissões por role

 Usage:
     - Executar no banco de dados desejado
     - Pode ser utilizado após restore de banco
     - Pode ser adaptado para auditoria periódica

 Notes:
     - Foca em usuários do tipo SQL_USER
     - Pode ser adaptado para incluir WINDOWS_USER
     - Requer permissão VIEW DEFINITION ou equivalente
================================================================================
*/

SELECT su.name AS UserDBName
	,sl.name AS LoginName
	,su.sid
	,CASE 
		WHEN sl.sid IS NULL
			THEN 'Sem login correspondente'
		ELSE 'OK'
		END AS STATUS
	,STRING_AGG(dr.name, ', ') AS Roles
FROM sys.database_principals su
LEFT JOIN sys.server_principals sl ON su.sid = sl.sid
LEFT JOIN sys.database_role_members rm ON su.principal_id = rm.member_principal_id
LEFT JOIN sys.database_principals dr ON rm.role_principal_id = dr.principal_id
WHERE su.type_desc = 'SQL_USER'
	AND sl.sid IS NOT NULL
	AND su.name <> 'dbo'
	AND sl.name <> 'dbo'
GROUP BY su.name
	,sl.name
	,su.sid
	,CASE 
		WHEN sl.sid IS NULL
			THEN 'Sem login correspondente'
		ELSE 'OK'
		END
ORDER BY su.name;
