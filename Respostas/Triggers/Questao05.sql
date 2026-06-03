-- Questão 5 — AFTER DELETE com contagem de linhas

-- Criando tabela para armazenar a quantidade de colunas excluídas.

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[LogExclusaoVendaProduto]')
						AND OBJECTPROPERTYEX(Id, N'IsTable') = 1
			)
	BEGIN
		DROP TABLE [dbo].[LogExclusaoVendaProduto];
		END

-- Criar tabela

CREATE TABLE [dbo].[LogExclusaoVendaProduto] (
	Id					INT				IDENTITY,
	DataHoraExclusao	DATETIME		NOT NULL,
	Usuario				VARCHAR(150)	NOT NULL,
	Maquina				VARCHAR(150)	NOT NULL,
	LinhasExcluidas		INT				NOT NULL,

	CONSTRAINT	PK_IdLogExclusaoVendaProduto PRIMARY KEY (Id)
)

GO

-- Criar trigger

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[RegistrarExclusaoVendaProduto]')
						AND OBJECTPROPERTYEX(Id, N'IsTrigger') = 1
			)
	BEGIN
		DROP TRIGGER [dbo].[RegistrarExclusaoVendaProduto];
		END

GO

CREATE TRIGGER [dbo].[RegistrarExclusaoVendaProduto]
	ON [dbo].[VendaProduto]
	AFTER DELETE
	AS
	/* DOCUMENTAÇÃO

		Arquivo fonte: Questao05.sql
		Objetivo: Registrar exclusões da tabela [dbo].[VendaProduto] na tabela [dbo].[LogExclusaoVendaProduto] 
		Autor: Djefferson dos Santos Lima
		Data criação: 03/06/2026
	*/
	BEGIN
		INSERT INTO [dbo].[LogExclusaoVendaProduto] (LinhasExcluidas, Maquina, Usuario, DataHoraExclusao)
			SELECT	@@ROWCOUNT,
					HOST_NAME(),
					SYSTEM_USER,
					GETDATE()
		END
GO

BEGIN TRAN

	DELETE FROM [dbo].[VendaProduto] 
		WHERE IdProduto = 2;

	SELECT *
		FROM [dbo].[LogExclusaoVendaProduto];

	ROLLBACK TRAN
