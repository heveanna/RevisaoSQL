USE PetShop;

-- ## 1. SELECT e filtros
-- 1. Liste todos os clientes cadastrados.

SELECT	cl.Nome as Nome
	FROM Cliente cl;

-- 2. Liste apenas o nome, telefone e e-mail dos clientes.

SELECT	Nome,
		Telefone,
		Email
	FROM Cliente;

-- 3. Liste todos os animais cadastrados.

SELECT	Nome,
		DataNascimento as 'Data Nascimento',
		Peso,
		Sexo
	FROM Animal;

-- 4. Liste os animais cujo sexo seja masculino.

SELECT	Nome, 
		Sexo
	FROM Animal
	WHERE Sexo LIKE 'M';
		
-- 5. Liste os animais com peso maior que 10 kg.

SELECT	Nome,
		Peso
	FROM Animal
	WHERE Peso > 10;

-- 6. Liste os animais nascidos depois de uma determinada data.

SELECT	an.Nome,
		an.DataNascimento
	FROM Animal as an 
	WHERE an.DataNascimento > '2026-04-09';

-- 7. Liste os produtos com preço maior que R$ 50,00.

SELECT  Nome as Produto,
		FORMAT(Preco, 'C', 'Pt-Br') as Preco
	FROM Produto
	WHERE Preco > 50;

-- 8. Liste os produtos com estoque menor que 10 unidades.

SELECT	Nome as Produtos,
		QuantidadeEstoque as 'Quantidade no Estoque'
	FROM Produto
	WHERE QuantidadeEstoque < 10;

-- 9. Liste os produtos ativos.

-- 10. Liste os produtos inativos.

-- 11. Liste os funcionários ordenados pelo nome em ordem alfabética.

SELECT	Nome
	FROM Funcionario
	ORDER BY Nome ASC;

-- 12. Liste os clientes ordenados pela data de cadastro, do mais recente para o mais antigo.

SELECT	Nome,
		DataCadastro as 'Data Cadastro'
	FROM Cliente
	ORDER BY DataCadastro DESC;

-- 13. Liste os agendamentos marcados para uma data específica.
 
SELECT	DataHoraAgendado,
		StatusAgendamento
	FROM Agendamento 
	WHERE DataHoraAgendado LIKE '%2026-03-30 14:00:00.000%';

SELECT * FROM Venda;

-- 14. Liste os agendamentos que ainda estão pendentes.

SELECT	DataHoraAgendado,
		StatusAgendamento as 'Status dos Agendamentos'
	FROM Agendamento
	WHERE StatusAgendamento = 'EmAndamento'; 

-- 15. Liste as vendas feitas em um determinado mês.

DECLARE @MES INT = 02;

SELECT DataHora AS 'MÊS'
	FROM Venda WITH(NOLOCK)
	WHERE MONTH(DataHora) = @MES

-- 16. Liste os pagamentos com valor maior que R$ 100,00.

SELECT Valor
	FROM Pagamento
	WHERE Valor > 100;

-- 17. Liste os produtos cujo nome contenha a palavra `"ração"`.

SELECT	Nome as Produto
	FROM Produto 
	WHERE Nome LIKE 'Racao%';

-- 18. Liste os clientes cujo nome comece com a letra `"A"`.

SELECT Nome as Cliente
	FROM Cliente 
	WHERE Nome LIKE 'A%';

-- 19. Liste os animais que não possuem data de nascimento cadastrada.

SELECT	Nome,
		DataNascimento as 'Data Nacimento'
	FROM Animal 
	WHERE DataNascimento IS NULL;

-- 20. Liste os produtos que têm preço entre R$ 20,00 e R$ 100,00.

SELECT	Nome as Produto,
		FORMAT(Preco, 'C', 'Pt-Br')
	FROM Produto
	WHERE Preco BETWEEN 20 AND 100;

-- ## 2. JOINs básicos
-- 21. Liste o nome de cada animal junto com o nome do seu cliente/dono.

SELECT	an.Nome AS 'Animal',
		cl.Nome AS 'Cliente'
	FROM Cliente as cl WITH(NOLOCK)
		JOIN Animal as an
			ON an.Id = cl.Id;

-- 22. Liste o nome do animal, a espécie e a raça.

SELECT	ra.Nome AS 'Raça',
		an.Nome AS 'Animal',
		es.Nome AS 'Espécie'
	FROM Animal as an WITH(NOLOCK)
		JOIN Especie as es
			ON es.Id = an.Id
		JOIN Raca as ra
			ON ra.IdEspecie = es.Id;

-- 23. Liste todos os animais com seus respectivos donos, mesmo que algum dado relacionado esteja incompleto.

SELECT	an.Nome AS 'Animal', 
		cl.Nome AS 'Cliente'
	FROM Animal as an 
		LEFT JOIN Cliente as cl
			ON an.IdCliente = cl.Id

-- 24. Liste todos os clientes e seus animais, incluindo clientes que ainda não têm animal cadastrado.

SELECT	cl.Nome AS 'Cliente',
		an.Nome AS 'Animal'
	FROM Cliente as cl
		JOIN Animal as an 
			ON an.Id = cl.Id

-- 25. Liste os produtos junto com suas categorias.

SELECT	pr.Nome AS 'Produto',
		cp.Nome AS 'Categoria'
	FROM Produto as pr
		JOIN CategoriaProduto as cp
		ON cp.Id = pr.IdCategoriaProduto;

-- 26. Liste as vendas junto com o nome do cliente que realizou a compra.

SELECT	FORMAT(ve.ValorTotal, 'C', 'Pt-Br') AS 'Valor',
		cl.Nome AS 'Cliente',
		ve.DataHora AS 'Data'
	FROM Venda as ve
		JOIN Cliente as cl
			ON cl.Id = ve.IdCliente;
		
-- 27. Liste os pagamentos junto com a venda correspondente e o tipo de pagamento usado.

SELECT  ve.Id,
		tp.Nome AS 'Tipo Pagamento',
        FORMAT(ve.ValorTotal, 'C', 'Pt-Br') AS Valor,
        ve.StatusVenda AS Pagamento
    FROM [dbo].[Pagamento] as pa
        JOIN [dbo].[TipoPagamento] as tp
            ON pa.IdTipoPagamento = tp.Id
        JOIN [dbo].[Venda] as ve
            ON pa.IdVenda = ve.Id
	WHERE ve.StatusVenda LIKE 'Paga';

-- 28. Liste os produtos vendidos em cada venda.

SELECT	pr.Nome AS Produto,
		ve.StatusVenda AS 'Produtos Vendidos'
	FROM [dbo].[Produto] as pr
		JOIN [dbo].[Venda] as ve
			ON ve.Id = pr.Id
	WHERE ve.StatusVenda LIKE 'Paga';
		
-- 29. Liste o nome do produto, quantidade vendida e valor unitário em cada item de venda.

SELECT	pr.Nome AS Produto,
		COUNT(ve.StatusVenda) AS 'Qtd. Vendida',
		pr.Preco AS 'Valor Unitário'
	FROM [dbo].[Produto] as pr 
		JOIN [dbo].[Venda] as ve
			ON  ve.Id = pr.Id
	GROUP BY ve.StatusVenda, pr.Nome, pr.Preco;

-- 30. Liste os serviços vendidos em cada venda.

SELECT	ve.Id,
		ti.Nome AS 'Serviço Vendidos',
		ve.ValorTotal AS Venda,
		ve.StatusVenda AS Status 
	FROM [dbo].[Venda] as ve
		JOIN [dbo].[TipoServico] as ti
			ON ti.Id = ve.Id;
		
-- 31. Liste o nome do serviço, nome do cliente e data da venda.

SELECT	ts.Nome AS Servico,
		cl.Nome AS Cliente, 
		ve.DataHora AS 'Data da Venda'
	FROM [dbo].[Cliente] as cl
		JOIN [dbo].[TipoServico] as ts
			ON ts.Id = cl.Id
		JOIN [dbo].[Venda] as ve
			ON ve.IdCliente = cl.Id;
	
-- 32. Liste os agendamentos com o nome do cliente, nome do animal e nome do funcionário responsável.

SELECT	cl.Nome AS Cliente,
		an.Nome AS Animal,
		fu.Nome AS Funcionario,
		ag.StatusAgendamento AS Agendamentos
	FROM [dbo].[Agendamento] as ag WITH(NOLOCK)
		JOIN [dbo].[Animal] as an
			ON an.Id = ag.IdAnimal
		JOIN [dbo].[Cliente] as cl
			ON cl.Id = ag.Id
		JOIN [dbo].[Funcionario] as fu
			ON fu.Id = ag.IdFuncionario
	WHERE ag.StatusAgendamento LIKE 'Concluido';

-- 33. Liste os funcionários e suas especialidades. 

SELECT	fu.Nome AS Funcionario,
		fu.Cargo AS Cargo 
	FROM [dbo].[Funcionario] as fu


-- 34. Liste todos os funcionários, mesmo os que ainda não possuem especialidade cadastrada.

SELECT  fu.Nome AS Funcionario,
		ts.Nome AS Especialidade
	FROM [dbo].[Funcionario] as fu
		LEFT JOIN [dbo].[FuncionarioEspecialidade] as fe
			ON fe.IdFuncionario = fu.Id
		LEFT JOIN [dbo].[TipoServico] as ts
			ON ts.Id = fe.IdTipoServico	

-- cadastrando mais um funcioanrio para teste
INSERT INTO	Funcionario (Nome, Cpf, Cargo, Salario, Ativo )
VALUES	('Joana Ricarda', '10000000031', 'Tosador',  2700, 1)

-- 35. Liste todos os tipos de serviço e os funcionários especializados neles.

SELECT  fu.Nome AS Funcinario,
		ts.Nome AS Especialidade
	FROM [dbo].[FuncionarioEspecialidade] as fe
		JOIN [dbo].[Funcionario] as fu
			ON fu.Id = fe.IdFuncionario
		JOIN [dbo].[TipoServico] as ts
			ON ts.Id = fe.IdTipoServico;


-- 36. Liste os produtos e seus fornecedores.

SELECT	pr.Nome AS Produtos,
		fo.Nome AS Fornecedor
	FROM [dbo].[Produto] as pr
		JOIN [dbo].[Fornecedor] as fo
			ON fo.Id = pr.IdFornecedor;

-- 37. Liste todos os fornecedores e os produtos que eles fornecem.

SELECT	fo.Nome AS Fornecedor,
		pr.Nome AS Produto
	FROM [dbo].[ProdutoFornecedor] as pf
		JOIN [dbo].[Produto] as pr
			ON pr.Id = pf.IdProduto
		JOIN [dbo].[Fornecedor] as fo
			ON fo.Id = pf.IdFornecedor;

-- 38. Liste os produtos que possuem mais de um fornecedor.

SELECT	pr.Nome AS Produto,
		fo.Nome AS Fornecedor,
	FROM [dbo].[Pr]
		
SELECT * FROM Fornecedor;
SELECT * FROM Funcionario;

-- 39. Liste os históricos de vacinação com o nome do animal e o nome do cliente.

SELECT  hv.NomeVacina AS Vacina,
		hv.DataAplicacao AS 'Data Aplicação',
		an.Nome AS Animal,
		cl.Nome AS Cliente
	FROM [dbo].[HistoricoVacina] as hv
		JOIN [dbo].[Animal] as an
			ON an.Id = hv.IdAnimal 
		JOIN [dbo].[Cliente] as cl
			ON cl.Id = hv.Id

-- 40. Liste as alergias de cada animal com o nome do animal e do dono.

SELECT	ale.Descricao AS Alergia,
		ani.Nome AS Animal,
		cli.Nome AS Cliente
	FROM [dbo].[AnimalAlergia] as ale
		LEFT JOIN [dbo].[Animal] as ani
			ON ani.Id = ale.IdAnimal
		LEFT JOIN [dbo].[Cliente] as cli
			ON cli.Id = ale.Id;

SELECT * FROM Animal;
SELECT * FROM Cliente;

-- 3. JOINs com filtros
-- 41. Liste os animais da espécie `"Cachorro"`.

SELECT	an.Nome AS Animal,
		ra.Nome AS Raca,
		es.Nome AS Especie 
	FROM [dbo].[Raca] as ra
		JOIN [dbo].[Animal] as an
			ON an.IdRaca = ra.Id
		JOIN [dbo].[Especie] as es
			ON es.Id = ra.IdEspecie
	WHERE es.Nome LIKE 'Cachorro%'

-- 44. Liste os produtos da categoria `"Medicamento"`.

SELECT	pr.Nome AS Produto,
		cp.Nome AS Categoria
	FROM [dbo].[CategoriaProduto] as cp
		JOIN 

-- 45. Liste as vendas feitas por um cliente específico.

-- 46. Liste todos os pagamentos feitos com cartão de crédito.

-- 47. Liste os agendamentos de um funcionário específico.

-- 48. Liste os agendamentos de uma data específica mostrando cliente, animal e serviço.

-- 49. Liste as vacinas aplicadas em animais de um cliente específico.

-- 50. Liste os produtos vendidos em vendas acima de R$ 200,00.

-- 51. Liste os serviços vendidos para animais da espécie `"Cachorro"`.

-- 52. Liste os fornecedores que fornecem produtos da categoria `"Ração"`.

-- 53. Liste os funcionários especializados em `"Banho e Tosa"`.

-- 54. Liste as vendas de produto feitas em determinado mês.

-- 55. Liste os clientes que compraram determinado produto.

-- 56. Liste os animais que possuem alergias cadastradas.

-- 57. Liste os animais que não possuem alergias cadastradas.

-- 58. Liste os produtos que nunca foram vendidos.

-- 59. Liste os serviços que nunca foram vendidos.

-- 60. Liste os clientes que nunca fizeram uma venda.

-- ## 4. Agregações com JOIN
-- 61. Mostre a quantidade de animais por cliente.

-- 62. Mostre a quantidade de animais por espécie.

-- 63. Mostre a quantidade de animais por raça.

-- 64. Mostre a quantidade de produtos por categoria.

-- 65. Mostre o total vendido por venda.

-- 66. Mostre o total gasto por cada cliente.

-- 67. Mostre a quantidade de vendas por cliente.

-- 68. Mostre a quantidade de produtos vendidos por produto.

-- 69. Mostre o faturamento total por produto.

-- 70. Mostre o faturamento total por serviço.

-- 71. Mostre a quantidade de agendamentos por funcionário.

-- 72. Mostre a quantidade de agendamentos por status.

-- 73. Mostre a quantidade de pagamentos por tipo de pagamento.

-- 74. Mostre o valor total recebido por tipo de pagamento.

-- 75. Mostre o total de vacinas aplicadas por animal.

-- 76. Mostre o total de vacinas aplicadas por espécie.

-- 77. Mostre os clientes com mais de 2 animais.

-- 78. Mostre os produtos que venderam mais de 10 unidades.

-- 79. Mostre os funcionários com mais de 5 agendamentos.

-- 80. Mostre as categorias de produto com mais de 3 produtos cadastrados.