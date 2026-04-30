USE dados;

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

/* @ANO = 2024;
@MES = 02;

SELECT DataHora 
	FROM Venda 
	WHERE */

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