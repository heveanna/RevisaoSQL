-- Questão 2 — AFTER DELETE

USE PetShop;

-- Criar tabela LogExclusão

-- Verificar se a tabela já existe, se sim dropar ela
IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[LogExclusao]')
						AND OBJECTPROPERTY(Id, N'IsTable') = 1
			)
	BEGIN
		DROP TABLE [dbo].[LogExclusao];
		END
GO

-- Criar tabela
CREATE TABLE [dbo].[LogExclusao](
	Id					INT				IDENTITY,
	IdCliente			INT				NOT NULL,
	NomeCliente			VARCHAR(120)	NOT NULL,
	CPF					CHAR(11)		NOT NULL,
	DataHoraExclusao	DATETIME		NOT NULL

	CONSTRAINT PK_IdLogExclusao PRIMARY KEY (Id)
)
GO

-- Trigger para gerar registro de exclusão do cliente em logExclusao

-- Verificar se a trigger já existe e dropar caso sim
IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[TRG_RegistrarExclusaoClienteEmLogExclusao]')
						AND OBJECTPROPERTY(Id, N'IsTrigger') = 1
			)
	BEGIN
		DROP TABLE [dbo].[TRG_RegistrarExclusaoClienteEmLogExclusao];
		END
GO

-- Criar trigger
CREATE TRIGGER [dbo].[TRG_RegistrarExclusaoClienteEmLogExclusao]
	ON [dbo].[Cliente]
	AFTER DELETE
	AS
		/* DOCUMENTACAO
		
			Arquivo Fonte: Questao02.sql
			Objetivo: Criar um registro de exclusão de clientes na tabela LogExclusao
			Autor: Djefferson dos Santos Lima
			Data Criacao: 29/05/2026
		*/
		
		BEGIN 

			INSERT INTO [dbo].[LogExclusao] (IdCliente, NomeCliente, CPF, DataHoraExclusao)
				SELECT	d.Id,
						d.Nome,
						d.Cpf,
						GETDATE()
					FROM deleted as d

			END
GO

-- Testando trigger

BEGIN TRAN
	DELETE FROM [dbo].[HistoricoVacina]
		WHERE IdAnimal IN	(
								SELECT Id
									FROM [dbo].[Animal] 
									WHERE IdCliente = 1
							);

	DELETE FROM [dbo].[Agendamento]
		WHERE IdAnimal IN	(
								SELECT Id
									FROM [dbo].[Animal] 
									WHERE IdCliente = 1
							);

	DELETE FROM [dbo].[Animal]
		WHERE IdCliente = 1;

	DELETE FROM [dbo].[VendaServico]
		WHERE IdVenda IN	(
								SELECT Id
									FROM [dbo].[Venda]
									WHERE IdCliente = 1
							)

	DELETE FROM [dbo].[Pagamento]
		WHERE IdVenda IN	(
								SELECT Id
									FROM [dbo].[Venda]
									WHERE IdCliente = 1
							)

	DELETE FROM [dbo].[VendaProduto]
		WHERE IdVenda IN	(
								SELECT Id
									FROM [dbo].[Venda]
									WHERE IdCliente = 1
							)

	DELETE FROM [dbo].[Venda]
		WHERE IdCliente = 1

	DELETE FROM [dbo].[Cliente]
		WHERE Id = 1;;

	SELECT *
		FROM [dbo].[LogExclusao];

	ROLLBACK TRAN

