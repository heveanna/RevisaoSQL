-- 1. Procedure mais básica: listar registros

CREATE PROCEDURE sp_ListarClientes 

	AS 
	BEGIN

		SELECT c.Nome
			FROM Cliente AS c
			ORDER BY c.Nome

	END;

EXEC sp_ListarClientes

-- 2. Procedure com parâmetro

CREATE PROCEDURE sp_BusrcarAnimalPorClente (
												@IdCliente INT
											)

	AS 
	BEGIN 

			SELECT	A.Nome,
					A.Peso,
					A.DataNascimento
				FROM Animal AS A
				WHERE A.IdCliente = @IdCliente

	END;

EXEC sp_BusrcarAnimalPorClente @IdCliente = 2

-- 3. Procedure com insert

CREATE PROCEDURE sp_CadastrarCliente	(
											@Nome			VARCHAR		(120),
											@Cpf			CHAR		(11),
											@Telefone		VARCHAR		(15),
											@Email			VARCHAR		(120),
											@DataCadastro	DATE
										)

	AS 
	BEGIN 
		
			INSERT INTO Cliente (	
							Nome,
							Cpf,
							Telefone,
							Email,
							DataCadastro
						)
			
			VALUES (
						@Nome,
						@Cpf,
						@Telefone,
						@Email,
						@DataCadastro
					)

	END;

EXEC sp_CadastrarCliente 
							@Nome			= 'Gabriel Santos',
							@Cpf			= '10210822418',
							@Telefone		= '83987102387',	
							@Email			= 'gabs@gamil.com',
							@DataCadastro	= '2026-05-20'

-- 4. Procedure com validação



-- 5. Procedure com update

CREATE PROCEDURE sp_AtualizarPrecoProduto (
												@IdDoProduto		INT,
												@PrecoAnterior      DECIMAL (10,2),
												@PrecoNovo			DECIMAL (10,2),
												@DataAlteracao		DATE
											)

	AS 
	BEGIN 
			


			UPDATE Produto
			SET Preco = @PrecoNovo
			WHERE Id = @IdDoProduto


			INSERT HistoricoPreco (
										IdProduto,
										PrecoAnterior,
										PrecoNovo,
										DataAlteracao
									)

			VALUES (
						@IdDoProduto,
						@PrecoAnterior,
						@PrecoNovo,
						@DataAlteracao
					)

	END

BEGIN TRANSACTION 

EXEC sp_AtualizarPrecoProduto 
									@IdDoProduto	= '1',
									@PrecoAnterior  = '22.90',
									@PrecoNovo		= '25.00',
									@DataAlteracao	= '2026-05-20'		

-- 6. Procedure com JOIN

CREATE PROCEDURE sp_ListarAgendaentosDetalhados 

	AS 
	BEGIN 

			SELECT	c.Nome,
					a.Nome,
					fun.Nome,
					ts.Nome,
					ag.DataHoraAgendado
				FROM Agendamento AS ag
					JOIN Animal as a
						ON a.Id = ag.IdAnimal
					JOIN Cliente as c
						ON c.Id = a.IdCliente
					JOIN Funcionario as fun 
						ON fun.Id = ag.IdFuncionario
					JOIN TipoServico as ts
						ON ts.Id = ag.IdTipoServico
 
	END;

EXEC sp_ListarAgendaentosDetalhados 

-- 7. Procedure com totalização

CREATE PROCEDURE sp_TotalVendasClioente (
											@IdCliente INT
										)

	AS 
	BEGIN

			SELECT	COUNT(IdCliente) AS QuantidadeDeVendas,
					SUM(ValorTotal) AS ValorTotalGasto
				FROM Venda as v
					JOIN Cliente as c
						ON c.Id = v.IdCliente
				WHERE c.Id = @IdCliente

	END;


EXEC sp_TotalVendasClioente @IdCliente = 160

-- 8 e 9 . Procedure com transação e tratamento de erro

CREATE PROCEDURE sp_RegistrarVendaCompleta (
												@IdCliente			INT,
												@IdFuncionario		INT,
												@DataHora			DATETIME,
												@ValorTotal			DECIMAL (10,2),
												@StatusVenda		VARCHAR (100),
												@IdProduto			INT,
												@Quantidade			INT,
												@PrecoUnitario		DECIMAL (10,2),
												@IdTipoPagamento	INT,
												@Valor				DECIMAL (10,2)
												
											)

		AS 
		BEGIN
				BEGIN TRANSACTION 

				BEGIN TRY

				DECLARE @IdVenda INT;

				INSERT INTO Venda (
										IdCliente,
										IdFuncionario,
										DataHora,
										ValorTotal,
										StatusVenda
									)
				VALUES (
							@IdCliente,
							@IdFuncionario,
							@DataHora,
							@ValorTotal,
							@StatusVenda
						)		

				SET @IdVenda = SCOPE_IDENTITY()

				INSERT INTO VendaProduto (
												IdVenda,
												IdProduto,
												Quantidade,
												PrecoUnitario
											)
				VALUES (
							@IdVenda,
							@IdProduto,
							@Quantidade,
							@PrecoUnitario
						)

				INSERT INTO Pagamento (
											IdVenda,
											IdTipoPagamento,
											Valor,
											DataHora
										)
				VALUES (
							@IdVenda,
							@IdTipoPagamento,
							@Valor,
							@DataHora
						)

				COMMIT 

				END TRY

				BEGIN CATCH 
					
					ROLLBACK

					PRINT ERROR_MESSAGE()
				
				END CATCH

		END;

EXEC sp_RegistrarVendaCompleta 
								@IdCliente = 1,
								@IdFuncionario = 1,
								@DataHora = '2026-05-20',
								@ValorTotal = 50.00,
								@StatusVenda = 'Pago',
								@IdProduto = 1,
								@Quantidade = 2,
								@PrecoUnitario = 22.00,
								@IdTipoPagamento = 1,
								@Valor = 50.00;


-- 10. Procedure avançada (nível legal mesmo)

CREATE PROCEDURE sp_RelatorioClienteCompleto	(
													@IdCliente INT
												)

	AS 
	BEGIN

		SELECT	c.Nome,
				c.Cpf,
				a.Nome as NomeAnimal,
				r.Nome as Raça,
				es.Nome as Especie,
				hv.NomeVacina,
				hv.DataAplicacao,
				hv.ProximaDose,
				v.DataHora,
				v.ValorTotal,
				tp.Nome,
				ag.DataHoraAgendado,
				ag.DataHoraRealizado

			FROM Animal AS a
				JOIN Raca as r
					ON r.Id = a.IdRaca
				JOIN Especie as es
					ON es.Id = r.IdEspecie
				JOIN Cliente as c
					ON c.Id = a.IdCliente
				JOIN HistoricoVacina as hv
					ON a.Id = hv.IdAnimal
				JOIN Venda as v
					ON c.Id = v.IdCliente
				JOIN Agendamento as ag
					ON a.Id = ag.IdAnimal
				JOIN TipoServico as tp
					ON tp.Id = ag.IdTipoServico
			WHERE c.Id = @IdCliente

	END;

EXEC sp_RelatorioClienteCompleto @IdCliente = 140


