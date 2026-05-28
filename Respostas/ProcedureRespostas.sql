USE Petshop;
GO

-- 1. Procedure mais básica: listar registros

CREATE PROCEDURE ListarClientes
	AS
		SELECT	cl.Id,
				cl.Nome,
				cl.Cpf,
				cl.DataCadastro,
				cl.Telefone,
				cl.Email
			FROM dbo.Cliente as cl WITH(NOLOCK)
			ORDER BY cl.Nome;
GO


EXEC ListarClientes;
GO

-- 2. Procedure com parâmetro

CREATE PROCEDURE BuscarAnimalPorCliente
	@IdCliente int 
	AS
		SELECT	an.IdCliente,
				an.Id,
				an.Nome,
				ra.Nome as Raca,
				an.Peso,
				an.Sexo
			FROM dbo.Animal as an WITH(NOLOCK)
				JOIN [dbo].[Raca] as ra
					ON an.IdRaca = ra.Id
			WHERE an.IdCliente = @IdCliente
			ORDER BY an.Nome;
GO

EXEC BuscarAnimalPorCliente 6;
GO

-- 3. Procedure com insert

CREATE PROCEDURE CadastrarCliente 
	@Nome VARCHAR(120),
	@Cpf CHAR(11),
	@Telefone VARCHAR(15),
	@Email VARCHAR(120)
	AS
		INSERT INTO [dbo].[Cliente] (Nome, Cpf, Telefone, Email, DataCadastro)
			VALUES	(@Nome, @Cpf, @Telefone, @Email, GETDATE());

		PRINT 'Cliente cadastrado com sucesso';
GO

EXEC CadastrarCliente 'Teste', '12655658910', '1111111', 'safadao@gmail.com';
GO

-- 4. Procedure com validação

CREATE PROC CadastrarClienteValidandoCpf
	@Nome VARCHAR(120),
	@Cpf CHAR(11),
	@Telefone VARCHAR(15),
	@Email VARCHAR(120)
	AS
		IF EXISTS (SELECT 1 FROM [dbo].[Cliente] WHERE Cpf = @Cpf)
			PRINT 'Cpf já cadastrado no sistema';
		ELSE 
			EXEC CadastrarCliente @Nome, @Cpf, @Telefone, @Email;
GO

EXEC CadastrarClienteValidandoCpf 'Teste', '12655658910', '1111111', 'safadao@gmail.com';
GO

-- 5. Procedure com update

CREATE PROC AtualizarPrecoProduto
	@IdProduto INT,
	@Preco DECIMAL(10, 2)
	AS
		IF EXISTS	(	
						SELECT 1 
							FROM [dbo].[Produto] WITH(NOLOCK)
							WHERE Id = @IdProduto
					)
			BEGIN
				UPDATE [dbo].[Produto]
					SET Preco = @Preco
					WHERE Id = @IdProduto;

				PRINT 'Preço do produto atualizado com sucesso';
			END

		ELSE 
			BEGIN
				PRINT 'Id do produto inválido';
			END
GO

EXEC AtualizarPrecoProduto 1, 20;
GO

SELECT *
	FROM [dbo].[Produto] WITH(NOLOCK)
	WHERE Id = 1;
GO

-- 6. Procedure com JOIN

CREATE PROC ListarAgendamentosDetalhados
	AS
		BEGIN

			SELECT	cl.Nome as Cliente,
					an.Nome as Animal,
					fu.Nome as Funcionario,
					ti.Nome as Tipo,
					ag.DataHoraAgendado,
					ag.DataHoraRealizado
				FROM [dbo].[Agendamento] as ag WITH(NOLOCK)
					JOIN [dbo].[Animal] as an WITH(NOLOCK)
						ON ag.IdAnimal = an.Id
						JOIN [dbo].[Cliente] as cl WITH(NOLOCK)
							ON an.IdCliente = cl.Id
					JOIN [dbo].[Funcionario] as fu WITH(NOLOCK)
						ON ag.IdFuncionario = fu.Id
					JOIN [dbo].[TipoServico] as ti WITH(NOLOCK)
						On ag.IdTipoServico = ti.Id
				ORDER BY cl.Nome;

		END
GO

EXEC ListarAgendamentosDetalhados;
GO

-- 7. Procedure com totalização

CREATE PROC TotalVendasCliente
	@IdCliente int
	AS
		BEGIN

			IF EXISTS	(	
						SELECT	1
							FROM [dbo].[Cliente] WITH(NOLOCK)
							WHERE Id = @IdCliente
						)
				BEGIN

					SELECT	cl.Nome as Cliente,
							COUNT(ve.Id) as QuantidadeDeVendas,
							SUM(ve.ValorTotal) as ValorTotalGasto
						FROM [dbo].[Cliente] AS cl WITH(NOLOCK)
							JOIN [dbo].[Venda] as ve WITH(NOLOCK)
								ON cl.Id = ve.IdCliente
						WHERE cl.Id = @IdCliente
						GROUP BY cl.Nome;

				END

			ELSE
				BEGIN

					PRINT 'Cliente não encontrado'

				END

		END
GO

EXEC TotalVendasCliente 1;
GO

INSERT INTO [dbo].[Venda] (IdCliente, IdFuncionario, StatusVenda, ValorTotal, DataHora)
	VALUES (1, 3, 'Banana', 100000, GETDATE());
GO


-- 8. Procedure com transação && 9. Procedure com tratamento de erro

CREATE PROC RegistrarVendaCompleta
	@IdCliente INT,
	@IdFuncionario INT,
	@IdProduto INT,
	@Quantidade INT
	AS
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION
					DECLARE @IdVendaGerada INT;
					DECLARE @PrecoUnitarioProduto DECIMAL(10, 2) = (
																			SELECT	Preco
																				FROM [dbo].[Produto]
																				WHERE Id = @IdProduto
																		);
					DECLARE @ValorTotal DECIMAL(10, 2) = @Quantidade * @PrecoUnitarioProduto;
									
					INSERT INTO [dbo].[Venda] (IdCliente, IdFuncionario, StatusVenda, ValorTotal, DataHora)
						VALUES (@IdCliente, @IdFuncionario, 'Pendente', @ValorTotal, GETDATE());

					SET @IdVendaGerada = SCOPE_IDENTITY();

					INSERT INTO [dbo].[VendaProduto] (IdProduto, IdVenda, PrecoUnitario, Quantidade)
						VALUES (@IdProduto, @IdVendaGerada, @PrecoUnitarioProduto, @Quantidade);

					COMMIT
				END TRY

				BEGIN CATCH
					PRINT 'Falha no cadastro';
					ROLLBACK
				END CATCH
		END

EXEC RegistrarVendaCompleta 982462831, 1, 1, 6;

SELECT TOP 1 * FROM Venda ORDER BY Id DESC
GO

-- 10. Procedure avançada (nível legal mesmo)

CREATE PROC RelatorioClienteCompleto
	@IdCliente INT
	AS
		BEGIN
			SELECT	cl.Nome as Cliente,
					cl.Cpf,
					an.Nome as Animal,
					ra.Nome as Raca,
					es.Nome as Especie,
					hv.NomeVacina,
					hv.DataAplicacao,
					hv.ProximaDose,
					ve.DataHora,
					ve.ValorTotal,
					ts.Nome as TipoServico,
					fu.Nome as Funcionario,
					ve.DataHora
				FROM [dbo].[Cliente] as cl
					JOIN [dbo].[Animal] as an
						ON cl.Id = an.IdCliente
						JOIN [dbo].[HistoricoVacina] hv
							ON an.Id = hv.IdAnimal
						JOIN [dbo].[Agendamento] as ag
							ON an.Id = ag.IdAnimal
							JOIN [dbo].[Funcionario] as fu
								ON ag.IdFuncionario = fu.Id
							JOIN [dbo].[TipoServico] as ts
								ON ag.IdTipoServico = ts.Id
						JOIN [dbo].[Raca] as ra
							ON an.IdRaca = ra.Id
							JOIN [dbo].[Especie] as es
								ON ra.IdEspecie = es.Id
					JOIN [dbo].[Venda] as ve
						ON cl.Id = ve.IdCliente
				WHERE cl.Id = @IdCliente;
		END

EXEC RelatorioClienteCompleto 1;
