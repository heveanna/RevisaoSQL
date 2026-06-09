USE PetShop;

-- ## 5. Subselects simples
-- 81. Liste os clientes que possuem pelo menos um animal cadastrado.

SELECT  cl.Id,
        cl.Nome AS Cliente,
         (
            SELECT COUNT(an.Id)
                FROM [dbo].[Animal] AS an
                WHERE an.IdCliente = cl.Id
            ) AS Animal
    FROM [dbo].[Cliente] AS cl
    WHERE (
            SELECT COUNT(an.Id)
                FROM [dbo].[Animal] AS an
                WHERE an.IdCliente = cl.Id
            ) > 0;
		
-- 82. Liste os clientes que não possuem animais cadastrados.

SELECT  cl.Id,
        cl.Nome AS Cliente
    FROM [dbo].[Cliente] as cl
    WHERE NOT EXISTS (SELECT 1
                    FROM [dbo].[Animal] as an
                    WHERE an.IdCliente = cl.Id
           );

-- 83. Liste os animais que possuem alergia cadastrada.

SELECT  an.Id,
        an.Nome AS Animal,
         (SELECT STRING_AGG(anl.Descricao, ', ') -- Mostra o animal apenas uma vez e colocar as alergia na mesma coluna
            FROM [dbo].[AnimalAlergia] AS anl
                WHERE anl.IdAnimal = an.Id
            ) AS Alergia
    FROM [dbo].[Animal] as an
        WHERE EXISTS (
            SELECT 1
                FROM [dbo].[AnimalAlergia] as anl
                WHERE anl.IdAnimal = an.Id
                    );

-- 84. Liste os animais que nunca foram vacinados.

SELECT  an.Id,
        an.Nome AS Animal,
        (SELECT hrv.NomeVacina
            FROM [dbo].[HistoricoVacina] as hrv
               WHERE hrv.IdAnimal = an.Id
         ) AS 'Não Vacinados'
    FROM [dbo].[Animal] as an
        WHERE NOT EXISTS (
            SELECT 1 
                FROM [dbo].[HistoricoVacina] as hrv
                WHERE hrv.IdAnimal = an.Id
               );
    
-- 85. Liste os produtos que já foram vendidos.

-- 86. Liste os produtos que nunca foram vendidos.

-- 87. Liste os serviços que já foram vendidos.

-- 88. Liste os serviços que nunca foram vendidos.

-- 89. Liste os clientes que já fizeram alguma venda.

-- 90. Liste os clientes que nunca fizeram venda.

-- ## 6. Subselects com comparação
-- 91. Liste os produtos com preço maior que a média dos produtos.

SELECT  pr.Nome AS Produto,
        FORMAT(pr.Preco, 'C', 'Pt-Br') AS 'Média Preço'
    FROM [dbo].[Produto] as pr
    WHERE pr.Preco > (
        SELECT AVG(Preco)
        FROM Produto 
    );

-- 92. Liste os produtos com preço menor que a média dos produtos.

SELECT  pr.Nome AS Produto,
        FORMAT(pr.Preco, 'C', 'Pt-Br') AS 'Média Preço'
    FROM [dbo].[Produto] as pr
    WHERE pr.Preco < (
        SELECT AVG(Preco)
        FROM Produto 
    );

-- 93. Liste os clientes que gastaram mais que a média geral de gasto dos clientes.

SELECT  cl.Nome AS Cliente,
        pr.Preco AS Preco
    FROM [dbo].[VendaProduto] as vpr
        JOIN [dbo].[Produto] as pr
            ON pr.Id = vpr.IdProduto
        JOIN [dbo].[Cliente] as cl
               ON cl.Id = vpr.Id
    WHERE pr.Preco > (
        SELECT AVG(Preco)
        FROM Produto
    );

-- 94. Liste as vendas com valor maior que a média das vendas.

SELECT  FORMAT(ve.ValorTotal, 'C', 'Pt-Br') AS Venda
    FROM [dbo].[VendaProduto] as vpr
        JOIN [dbo].[Venda] as ve
            ON ve.Id = vpr.IdVenda
    WHERE ve.ValorTotal > (
        SELECT AVG(ValorTotal)
        FROM Venda);

-- 95. Liste os produtos com estoque acima da média.

SELECT  vpr.Quantidade AS Estoque
    FROM [VendaProduto] as vpr 
    WHERE vpr.Quantidade > (
        SELECT AVG(vpr.Quantidade)
        FROM VendaProduto);

-- 96. Liste os produtos com estoque abaixo da média.

-- 97. Liste os funcionários que têm mais agendamentos que a média de agendamentos por funcionário.

-- 98. Liste os clientes que possuem mais animais que a média de animais por cliente.

-- 99. Liste os serviços cujo preço atual é maior que a média dos serviços.

-- 100. Liste os produtos cujo preço está acima do maior preço histórico anterior registrado.
