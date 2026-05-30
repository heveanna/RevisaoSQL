-- Questão 3 — AFTER UPDATE

USE Petshop;

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[RegistrarAtualizacaoPrecoProduto]')
						AND OBJECTPROPERTY(Id, N'IsTrigger') = 1
			)
	BEGIN
		DROP TRIGGER [dbo].[RegistrarAtualizacaoPrecoProduto];
		END
GO

CREATE TRIGGER [dbo].[RegistrarAtualizacaoPrecoProduto]
	ON [dbo].[Produto]
	AFTER UPDATE
	AS
	/* DOCUMENTACAO

		Arquivo Fonte: Questao03.sql
		Objetivo: Fazer um insert documentando alteracoes no preco dos produtos
		Autor: Djefferson dos Santos Lima
		Data Criacao: 29/05/2026
		
	*/
	BEGIN

		INSERT INTO [dbo].[HistoricoPreco] (IdProduto, PrecoAnterior, PrecoNovo, DataAlteracao)
			SELECT	i.id,
					d.Preco,
					i.Preco,
					GETDATE()
				FROM inserted as i
						JOIN deleted as d
							ON i.Id = d.Id
				WHERE i.Preco <> d.Preco;

		END
GO

-- Testando trigger

BEGIN TRAN

	UPDATE  [dbo].[Produto]
		SET Preco = 50
		WHERE Id = 1;

	SELECT	TOP 1
			*
		FROM [dbo].[HistoricoPreco]
		ORDER BY Id DESC;

	ROLLBACK TRAN
GO