-- Atividade CTE

-- 1 CTE Simples Crie uma CTE que liste todos os clientes com seus respectivos animais:

WITH Cliente_Animal AS (

	SELECT	C.Nome as Cliente,
			a.Nome As Animal
		FROM Animal as a
			INNER JOIN Cliente as c
				ON c.Id = a.IdCliente
		
)

SELECT *
	FROM Cliente_Animal

-- 2. CTE com Agregação Desenvolva uma CTE que mostre a quantidade de animais por cliente:

WITH Animal_Quantidade AS (

	SELECT	c.Id,
			c.Nome as Cliente,
			a.Nome as Animal,
			COUNT(a.Id) as Quantidade 
		FROM Animal as a
			INNER JOIN Cliente as c
				ON c.Id = a.IdCliente
		GROUP BY c.Id, c.Nome, a.Nome
)

SELECT *
	FROM Animal_Quantidade

-- 3. CTE e Filtro Crie uma CTE que liste apenas clientes que têm mais de 2 animais:


WITH ClientesComMaisDEDoisAnimais AS (

	SELECT	c.Id,
			c.Nome as Cliente,
			COUNT(a.Id) as QuantidadeAnimal
		FROM Animal as a
			INNER JOIN Cliente as c
				ON c.Id = a.IdCliente
	GROUP BY c.Id, c.Nome
	HAVING COUNT(a.Id) >= 2
)

SELECT *
	FROM ClientesComMaisDEDoisAnimais

-- 4. CTE Múltipla Simples Desenvolva 2 CTEs: uma com clientes e outra com animais, depois as combine:

WITH CTR_Cliente AS (

	SELECT	c.Id,
			c.Nome as Cliente 
		FROM Cliente as c
)
CTR_Animal AS  (

	SELECT	a.IdCliente,
			a.Nome as Animal
		From Animal as a
)

SELECT *
	FROM CTR_Cliente as cl
		INNER JOIN CTR_Animal as an
		ON cl.Id = an.IdCliente
			

-- 5. CTE com ORDER BY Crie uma CTE que mostre os produtos ordenados por preço descendente:

WITH CTR_ProdutoOrdenados AS (

	SELECT	p.Id,
			p.Nome,
			p.Preco
		FROM Produto as p
		GROUP BY p.Preco
)

