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
				ON an.IdCliente = cltemp.Id

-- 2. CTE com Agregação