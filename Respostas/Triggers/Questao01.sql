-- Questão 1 — AFTER INSERT

USE PetShop;

-- Criando tabela LogVenda -------------------------------------------------------

-- Verifica se a tabela existe e, se sim, dropa ela.
IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects] 
					WHERE Id = object_Id(N'[dbo].[LogVenda]')
						AND OBJECTPROPERTY(Id, N'IsTable') = 1
			)
	BEGIN
		DROP TABLE [dbo].[LogVenda];
		END
GO

-- Criando tabela LogVenda
CREATE TABLE [dbo].[LogVenda] (
	Id					INT				IDENTITY,
	IdVenda				INT				NOT NULL,
	DataHoraRegistro	DATETIME		NOT NULL DEFAULT(GETDATE()),
	Mensagem			VARCHAR(250),

	CONSTRAINT PK_IdLogVenda PRIMARY KEY (Id),
	CONSTRAINT FK_IdVenda_LogVenda FOREIGN KEY (IdVenda) REFERENCES [dbo].[Venda](Id)
);
GO

-- Trigger para inserir registros em LogVenda ---------------------------------------

-- Verifica se a trigger existe e dropa ela caso sim.
IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[TRG_RegistrarVendaEmLogVenda]')
						AND OBJECTPROPERTY(Id, N'IsTrigger') = 1
			)
	BEGIN
		DROP TRIGGER [dbo].[TRG_RegistrarVendaEmLogVenda];
		END
GO

-- Cria a trigger TRG_RegistrarVendaEmLogVenda
CREATE TRIGGER [dbo].[TRG_RegistrarVendaEmLogVenda]
	ON [dbo].[Venda]
	AFTER INSERT 
	AS
	/* DOCUMENTACAO

		Arquivo Fonte: Questao01.sql
		Objetivo: Adicionar um registro de uma Venda em LogVenda
		Autor: Djefferson dos Santos Lima
		Data Criacao: 29/05/2026

	*/

	BEGIN
		INSERT INTO [dbo].[LogVenda] (IdVenda, DataHoraRegistro, Mensagem)
			SELECT i.Id, i.DataHora, 'Nova venda registrada'
				FROM inserted as i;
		END
GO

-- Testando trigger
BEGIN TRAN

	INSERT INTO [dbo].[Venda] (IdCliente, IdFuncionario, StatusVenda, ValorTotal, DataHora)
		VALUES (1, 1, 'Abrida', 2.0, GETDATE());

	SELECT *
		FROM [dbo].[LogVenda];

	ROLLBACK TRAN