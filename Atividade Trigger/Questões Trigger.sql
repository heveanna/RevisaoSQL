-- 1 INSERET Venda

CREATE TABLE LogVenda	(
							Id				INT IDENTITY(1,1),
							IdVenda			INT					NOT NULL,
							DataRegistro	DATETIME			NOT NULL,
							Mensagem		VARCHAR	(200)

							CONSTRAINT Id PRIMARY KEY (Id),
							CONSTRAINT FK_IdVenda FOREIGN KEY (IdVenda) REFERENCES Venda (Id) 
						)

INSERT INTO Venda (IdCliente, IdFuncionario, DataHora, ValorTotal, StatusVenda)
VALUES ( 49, 23, GETDATE(), 500, 'Paga')


SELECT *
	FROM Venda


-- Questão 1 - AFTER INSERT 

IF EXISTS	(
				SELECT 1
					FROM sysobjects
					WHERE Id = object_Id (N'[dbo].[tre_RegistrarVenda]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_RegistrarVenda]
END


CREATE TRIGGER [dbo].[tre_RegistrarVenda]
ON Venda
FOR INSERT

AS
/*
Arquivo fonte:
Objetivo: inserir registros na tabela LogVenda 
Autor: Mayk Gabriel
Data Creiação: 03-06-2026
Exemplo: 
*/
BEGIN

	INSERT INTO LogVenda (IdVenda, DataRegistro, Mensagem)
	SELECT	i.Id,
			GETDATE(),
			'Nova venda registrada'
		FROM inserted as i

	SELECT * 
		FROM LogVenda

END



-- QUESTÂO 2 - AFTER DELETE

CREATE  TABLE LogExclusao (
								Id				INT IDENTITY(1,1),
								IdCliente		INT					NOT NULL,
								NomeCliente		VARCHAR(150)		NOT NULL,
								DataExclusao	DATETIME

								CONSTRAINT IdLogExclusao PRIMARY KEY (Id)
								CONSTRAINT FK_IdCliente FOREIGN KEY (IdCliente) REFERENCES Cliente (Id) 
							)

SELECT * FROM Cliente

DELETE Cliente
WHERE Id = 900

SELECT * 
	FROM LogExclusao



IF EXISTS	(
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_AferDelete]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_AferDelete]
END



CREATE TRIGGER [dbo].[tre_AferDelete]
ON Cliente 

FOR DELETE 

AS 
BEGIN

	INSERT INTO LogExclusao (IdCliente, NomeCliente, DataExclusao)
	SELECT	d.Id,
			d.Nome,
			GETDATE()
		FROM deleted as d

	SELECT *
		FROM logExclusao

END

-- QUESTÂO 3 

IF EXISTS	(
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_AfterUpdate]')
					AND xtype = 'TR'
			)
BEGIN 
	DROP TRIGGER [dbo].[tre_AfterUpdate]
END

CREATE TRIGGER [dbo].[tre_AfterUpdate]
ON Produto

For UPDATE

AS
BEGIN

END 

-- TRIGGER.MD

/*
1 . TRIGGER INSERT SIMPLES 
	Crie uma trigger que atualize um campo DataUltimaModificação sempre que um novo Cliente for inserido
*/

IF EXISTS	(
				SELECT 1
					FROM sysobjects
					WHERE Id = object_Id(N'[dbo].[]')
					AND xtype = 'TR'
			)
BEGIN
		DROP TRIGGER [dbo].[tre_InsertSimples]
END 


CREATE TRIGGER [dbo].[tre_InsertSimples]
ON Cliente

FOR INSERT, UPDATE 

AS 
BEGIN 

	INSERT INTO DataUltimaModificacao (IdCliente, Datacadastro, Mensagem)
	SELECT	i.Id,
			GETDATE(),
			'Atualização'	
		FROM inserted as i

END

/*
	2. Trigger de Validação
	Desenvolva um trigger que valide se o preço do Produto é maior que zero antes de inserir:
*/

IF EXISTS	(
				SELECT 1 
					FROM sysobjects
					WHERE Id = object_Id(N'[dbo].[ValidarVenda]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[ValidarVenda]
END



INSERT INTO Produto (IdCategoriaProduto, IdFornecedor, Nome, Descricao, Preco, QuantidadeEstoque, DataValidade)
VALUES (1, 1, 'Leite', 'Leite Integral', 10.00, 50, '2026-12-31')



CREATE TRIGGER [dbo].[ValidarVenda]
ON Produto

FOR INSERT

AS 
/*
Arquivo fonte:
Objetivo: inserir registros na tabela LogVenda 
Autor: Mayk Gabriel
Data Creiação: 03-06-2026
Exemplo: 
*/
BEGIN


	IF EXISTS	(
					SELECT 1
						FROM inserted
						WHERE Preco <= 0
				)

	BEGIN

		RAISERROR(
		'Preço menor que 0',
		16,
		1
		)

		ROLLBACK TRANSACTION
		RETURN 

	END

END 



/*
	3. Trigger DELETE com Controle
	Crie um trigger que registre o ID de um Cliente deletado em uma tabela de auditoria:
*/

IF EXISTS (
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_RegistroDeletado]')
					AND xtype = 'TR'
			)
BEGIN 
		DROP TRIGGER [dbo].[tre_RegistroDeletado]
END 


SELECT *
	FROM Cliente

CREATE TRIGGER [dbo].[tre_RegistroDeletado]
ON Cliente

FOR DELETE

AS 
BEGIN

	INSERT INTO LogExclusao (IdCliente, NomeCliente, DataExclusao)
	SELECT	d.Id,
			d.Nome,
			GETDATE()
		FROM deleted as d

	SELECT *
		FROM LogExclusao

END

/*
	4. Trigger UPDATE Simples
	Desenvolva um trigger que atualize DataUltimaModificacao do Animal sempre que seus dados forem alterados:
*/

CREATE TABLE UltimaModificacaoAnimal(
										Id					INT IDENTITY,
										IdAnimal			INT				NOT NULL,
										DataModificacao		DATETIME,
										Mensagem			VARCHAR(50)

										CONSTRAINT IdModificacao PRIMARY KEY (Id),
										CONSTRAINT FK_IdAnimal FOREIGN KEY (IdAnimal) REFERENCES Animal (Id)
									)

IF EXISTS (
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id (N'[dbo].[tre_ModificacaoAnimal]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_ModificacaoAnimal]
END


CREATE TRIGGER [dbo].[tre_ModificacaoAnimal]
ON Animal 

FOR UPDATE 

AS 

BEGIN

	INSERT INTO UltimaModificacaoAnimal (IdAnimal ,DataModificacao, Mensagem)

	SELECT	i.Id,
			GETDATE(),
			'Ultima Modificação'
		FROM inserted as i

END 

/*
	5. Trigger com GETDATE()
	Crie um trigger que registre a data e hora quando um Agendamento é cancelado (UPDATE status):
*/

CREATE TABLE ##Cancelamento (
								Id					INT IDENTITY,
								IdAgendamento		INT				NOT NULL,
								DataCancelamento	DATETIME		NOT NULL

								CONSTRAINT Idcancelamento PRIMARY KEY (Id)
								CONSTRAINT FK_IdIdAgendamento FOREIGN KEY (IdAgendamento) REFERENCES Agendamento(Id)
							)

IF EXISTS (		
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_AgendamentoCancelado]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_AgendamentoCancelado]
END



CREATE TRIGGER [dbo].[tre_AgendamentoCancelado]
ON Agendamento

FOR UPDATE 

AS 
BEGIN

	INSERT INTO ##Cancelamento (IdAgendamento, DataCancelamento)
	SELECT	d.Id,
			GETDATE()
		FROM deleted as d
		WHERE StatusAgendamento <> 'Cancelado'

		SELECT *
			FROM ##Cancelamento
END

BEGIN TRANSACTION 

	UPDATE Agendamento 
	SET StatusAgendamento = 'Cancelado'
	WHERE Id = 13

ROLLBACK

/*
	6. Trigger com INSERTED e DELETED
	Desenvolva um trigger que compare o preço antigo e novo do Produto e registre a mudança numa tabela de histórico:
*/


IF EXISTS	(
				SELECT 1
					FROM sysobjects
					WHERE Id = object_Id (N'[dbo].[tre_CompararPrecos]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_CompararPrecos]
END


CREATE TRIGGER [dbo].[tre_CompararPrecos]
ON Produto

FOR UPDATE

AS 
BEGIN 

	INSERT INTO HistoricoPreco (IdProduto, PrecoAnterior, PrecoNovo, DataAlteracao)
	SELECT	d.Id,
			d.Preco,
			i.Preco,
			GETDATE()
		FROM inserted as i
			JOIN Produto as p
				ON p.Id = i.Id
			JOIN deleted as d
				ON d.Id = p.Id

		SELECT *
			FROM HistoricoPreco
END

BEGIN TRANSACTION 
	
	UPDATE Produto
	SET Preco = 30
	WHERE Id = 1

ROLLBACK

/*
	7. Trigger com Múltiplas Ações
	Crie um trigger INSTEAD OF que ao inserir Venda, automaticamente crie um Agendamento correspondente:
*/

IF EXISTS	(
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id (N'[dbo].[tre_VendaComAgendamento]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_VendaComAgendamento]
END

CREATE TRIGGER [dbo].[tre_VendaComAgendamento]
ON VendaServico

FOR INSERT

AS 
BEGIN

	INSERT INTO Agendamento (IdAnimal, IdTipoServico, IdFuncionario, DataHoraAgendado, DataHoraRealizado, StatusAgendamento, Observacoes)
	SELECT	i.IdAnimal,
			i.IdTipoServico,
			v.IdFuncionario,
			GETDATE(),
			NULL,
			'Agendado',
			NULL
		FROM inserted as i
			JOIN Venda as v
				ON v.Id = i.IdVenda

END

BEGIN TRANSACTION 
	INSERT INTO VendaServico (IdVenda, IdTipoServico, IdAnimal, PrecoAplicado)
	VALUES (3, 8, 87, 200)

SELECT *
FROM Agendamento

ROLLBACK

/*
	8. Trigger Recursivo com Controle
	Desenvolva um trigger que ao inserir uma Venda, atualize a quantidade em estoque do Produto (se existir tabela de estoque):
*/

IF EXISTS	(
				SELECT 1
					FROM sysobjects
					WHERE Id = object_Id (N'[dbo].[tre_AtualzacaoEstoque]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_AtualzacaoEstoque]
END 



CREATE TRIGGER [dbo].[tre_AtualzacaoEstoque]
ON VendaProduto

FOR INSERT 

AS 
BEGIN

	UPDATE Produto
	SET QuantidadeEstoque = Quantidade - i.Quantidade
	FROM inserted as i
		JOIN Produto as p
			ON p.Id = i.IdProduto

	SELECT *
		FROM VendaProduto
			
END

BEGIN TRANSACTION 

	INSERT INTO VendaProduto (IdVenda, IdProduto, Quantidade, PrecoUnitario)
	VALUES (1, 1, 1, 25.90)

	SELECT *
		FROM Produto

ROLLBACK

/*
	9. Trigger com Condição IF
	Crie um trigger que só registre a auditoria se o valor da Venda for maior que R$ 100:
*/

IF EXISTS	(
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_VendaMairQueCem]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_VendaMairQueCem]
END 


CREATE TRIGGER [dbo].[tre_VendaMairQueCem]
ON Venda

FOR INSERT 

AS
BEGIN 

	IF EXISTS (SELECT 1
					FROM inserted as i
					WHERE i.ValorTotal > 100)

	BEGIN

	INSERT INTO LogVenda (IdVenda, DataRegistro, Mensagem)
	SELECT	i.Id,
			GETDATE(),
			'Venda mair de R$ 100'
		FROM inserted as i

		PRINT 'Venda registrada'
		
	END

END


-- teste

BEGIN TRANSACTION 

INSERT INTO Venda (IdCliente, IdFuncionario, DataHora, ValorTotal, StatusVenda)
VALUES (900, 3, GETDATE(), 50, 'Paga')

SELECT *
			FROM LogVenda

ROLLBACK

/*
	10. Trigger para Atualizar Agregados
	Desenvolva um trigger que ao inserir uma venda, atualize um campo de totalGasto na tabela cliente
*/

IF EXISTS	(
				SELECT 1
					FROM sysobjects 
					WHERE Id = object_Id(N'[dbo].[tre_TotalGastoPorCliente]')
					AND xtype = 'TR'
			)
BEGIN
	DROP TRIGGER [dbo].[tre_TotalGastoPorCliente]
END


CREATE TRIGGER [dbo].[tre_TotalGastoPorCliente]
ON Venda

FOR INSERT 
AS
BEGIN

	UPDATE Cliente 
	SET TotalGasto = i.ValorTotal + c.TotalGasto
		FROM inserted AS i
			INNER JOIN Cliente as c
				ON c.Id = i.IdCliente

END

-- teste

BEGIN TRANSACTION 

INSERT INTO Venda (IdCliente, IdFuncionario, DataHora, ValorTotal, StatusVenda)
VALUES (1, 2, GETDATE(), 100, 'Paga')

SELECT *
	FROM Cliente

ROLLBACK

