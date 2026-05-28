USE Petshop;
GO

-- SELECT E FILTROS ---------------------------------------------

-- 1. Liste todos os clientes cadastrados.

SELECT	*
	FROM dbo.Cliente WITH(NOLOCK);

-- 2. Liste apenas o nome, telefone e e-mail dos clientes.

SELECT	Nome,
		Telefone,
		Email
	FROM dbo.Cliente WITH(NOLOCK)
	ORDER BY Nome ASC;

-- 3. Liste todos os animais cadastrados.

SELECT *
	FROM dbo.Animal WITH (NOLOCK);

-- 4. Liste os animais cujo sexo seja masculino.

SELECT *
	FROM dbo.Animal AS a WITH (NOLOCK)
	WHERE a.Sexo = 'M'
	ORDER BY a.Nome ASC;

-- 5. Liste os animais com peso maior que 10 kg.

SELECT *
	FROM dbo.Animal AS a WITH (NOLOCK)
	WHERE a.Peso > 10
	ORDER BY a.Nome ASC;

-- 6. Liste os animais nascidos depois de uma determinada data.

DECLARE @DataNascimentoMinima DATE = '2020-01-01';

SELECT *
	FROM dbo.Animal AS a WITH(NOLOCK)
	WHERE a.DataNascimento > @DataNascimentoMinima
	ORDER BY a.DataNascimento ASC;

-- 7. Liste os produtos com preço maior que R$ 50,00.

DECLARE @PrecoMinimo DECIMAL = 50.00;

SELECT *
	FROM dbo.Produto AS pr WITH(NOLOCK)
	WHERE pr.Preco > @PrecoMinimo
	ORDER BY pr.Preco ASC;

-- 8. Liste os produtos com estoque menor que 10 unidades.

DECLARE @EstoqueMaximo INT = 10;

SELECT *
	FROM dbo.Produto AS pr WITH(NOLOCK)
	WHERE pr.QuantidadeEstoque < @EstoqueMaximo
	ORDER BY pr.QuantidadeEstoque ASC;

-- 9. Liste os produtos ativos.

SELECT *
	FROM dbo.Produto AS pr WITH(NOLOCK)
	WHERE pr.QuantidadeEstoque > 0
	ORDER BY pr.Nome ASC;

-- 10. Liste os produtos inativos.

SELECT *
	FROM dbo.Produto AS pr WITH(NOLOCK)
	WHERE pr.QuantidadeEstoque <= 0
	ORDER BY pr.Nome ASC;