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
			FROM dbo.Cliente as cl
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
			FROM dbo.Animal as an
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
		IF EXISTS (SELECT 1 FROM [dbo].[Produto] WHERE Id = @IdProduto)
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
	FROM [dbo].[Produto]
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

