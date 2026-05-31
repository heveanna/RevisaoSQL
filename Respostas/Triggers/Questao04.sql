-- Questão 4 — AFTER INSERT com auditoria de usuário

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[AuditoriaCliente]')
						AND OBJECTPROPERTY(Id, N'IsTable') = 1
			)
	BEGIN
		DROP TABLE [dbo].[AuditoriaCliente];
		END

CREATE TABLE [dbo].[AuditoriaCliente](
	Id				INT				IDENTITY,
	IdCliente		INT				NOT NULL,
	UsuarioSistema	NVARCHAR(128)	NOT NULL,
	Maquina			NVARCHAR(128)	NOT NULL,
	DataAcao		DATETIME		NOT NULL,

	CONSTRAINT PK_IdAuditoriaCliente PRIMARY KEY (Id),
	CONSTRAINT FK_IdCliente_AuditoriaCliente FOREIGN KEY (IdCliente) REFERENCES Cliente(Id)
);
GO

-- Criando trigger

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[RegistrarAuditoria]')
						AND OBJECTPROPERTY(Id, N'IsTrigger') = 1
			)
	BEGIN
		DROP TABLE [dbo].[RegistrarAuditoria];
		END
Go

CREATE TRIGGER [dbo].[RegistrarAuditoria]
	ON [dbo].[Cliente]
	AFTER INSERT
	AS
	/* DOCUMENTAÇÃO

		Arquivo fonte: Questao04.sql
		Objetivo: Registrar inserts na tabela cliente.
		Autor: Djefferson dos Santos Lima
		Data criação: 31/05/2026

	*/

	BEGIN
		INSERT INTO [dbo].[AuditoriaCliente] (IdCliente, UsuarioSistema, Maquina, DataAcao)
			SELECT	Id, SYSTEM_USER, HOST_NAME(), GETDATE()
				FROM inserted 
		END
GO

-- Testando trigger
BEGIN TRAN

INSERT INTO [dbo].[Cliente] (Nome, Telefone, Email, DataCadastro, Cpf)
	VALUES('Jeff Besos', '1244', 'ixi', GETDATE(), '17347677919');

SELECT TOP 1 * FROM [dbo].[AuditoriaCliente]
	ORDER BY Id ASC;

	ROLLBACK TRAN

	