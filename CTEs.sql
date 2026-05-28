USE PetShop;

-- 1. CTE Simples

WITH Cliente_TEMP as (
	SELECT	Id,
			Nome
		FROM [dbo].[Cliente] WITH(NOLOCK)
)
	SELECT	cltemp.Nome,
			an.Nome
		FROM Cliente_TEMP as cltemp WITH(NOLOCK)
			JOIN [dbo].[Animal] as an
				ON an.IdCliente = cltemp.Id;
GO

-- 2. CTE com Agregação

WITH QuantidadeAnimaisPorCliente_TEMP as (
	SELECT	cl.Id,
			cl.Nome,
			COUNT(an.Id) as ContagemAnimais
		FROM [dbo].[Animal] as an WITH(NOLOCK)
			RIGHT JOIN [dbo].[Cliente] as cl	WITH(NOLOCK)
				ON an.IdCliente = cl.Id
		GROUP BY cl.Id, cl.Nome
)
	SELECT	Id,
			Nome,
			ContagemAnimais
		FROM QuantidadeAnimaisPorCliente_TEMP;
GO

-- 3. CTE e Filtro

INSERT INTO [dbo].[Animal] (IdCliente, IdRaca, Nome, Observacoes, Peso, Sexo, DataNascimento)
	VALUES (1, 1, 'Joelma', 'Observado', 1.3, 'M', '2005-01-01')

WITH ClientesComMaisDe02Animais_TEMP as (
	SELECT	cl.Id,
			cl.Nome,
			COUNT(an.Id) as ContagemAnimais
		FROM [dbo].[Cliente] as cl WITH(NOLOCK)
			JOIN [dbo].[Animal] as an WITH(NOLOCK)
				ON cl.Id = an.IdCliente
		GROUP BY cl.Id, cl.Nome
		HAVING COUNT(an.Id) > 2 
)
	SELECT	Id,
			Nome,
			ContagemAnimais
	FROM ClientesComMaisDe02Animais_TEMP;

-- 4. CTE Múltipla Simples

WITH	ClienteResumo_TEMP as (
			SELECT	cl.Id,
					cl.Nome,
					cl.Telefone
				FROM [dbo].[Cliente] as cl WITH(NOLOCK)
		),

		AnimalResumo_TEMP as (
			SELECT	an.Id,
					an.IdCliente,
					an.Nome
				FROM [dbo].[Animal] as an WITH(NOLOCK)
		)

		SELECT	cl.Id as IdCliente,
				cl.Nome as NomeCliente,
				an.Id as IdAnimal,
				an.Nome as NomeAnimal
			FROM ClienteResumo_TEMP as cl
				JOIN AnimalResumo_TEMP as an
					ON cl.Id = an.IdCliente;
GO

-- 5. CTE com ORDER BY

WITH	PrecosResumo_TEMP as (
			SELECT	pd.Id,
					pd.Nome,
					pd.Preco
				FROM [dbo].[Produto] as pd WITH(NOLOCK)
		)

		SELECT	Id,
				Nome,
				Preco
			FROM PrecosResumo_TEMP
			ORDER BY Preco DESC
GO

-- 6. CTE com ROW_NUMBER()

WITH	FuncionarioEAgendamento_TEMP as (
			SELECT	fu.Id as IdFuncionario,
					fu.Nome,
					ROW_NUMBER() OVER	(
											PARTITION BY IdFuncionario
											ORDER BY ag.DataHoraAgendado
										) as Numero,
					ag.Id as IdAgendamento,
					ag.DataHoraAgendado,
					ag.DataHoraRealizado
				FROM [dbo].[Funcionario] as fu
					JOIN [dbo].[Agendamento] as ag
						ON fu.Id = ag.IdFuncionario
		)
		SELECT *
			FROM FuncionarioEAgendamento_TEMP
			ORDER BY IdFuncionario;
GO
