-- Exemplo de CTE 

WITH TotalAnimaisPorCliente AS (
    SELECT
        c.Id AS IdCliente,
        c.Nome AS Cliente,
        COUNT(a.Id) AS TotalAnimais
    FROM Cliente c
    LEFT JOIN Animal a
        ON a.IdCliente = c.Id
    GROUP BY
        c.Id,
        c.Nome
),
TotalVendasPorCliente AS (
    SELECT
        v.IdCliente,
        COUNT(v.Id) AS TotalVendas,
        SUM(v.ValorTotal) AS ValorTotalGasto
    FROM Venda v
    GROUP BY
        v.IdCliente
)
SELECT
    tac.IdCliente,
    tac.Cliente,
    tac.TotalAnimais,
    ISNULL(tvc.TotalVendas, 0) AS TotalVendas,
    ISNULL(tvc.ValorTotalGasto, 0) AS ValorTotalGasto
FROM TotalAnimaisPorCliente tac
LEFT JOIN TotalVendasPorCliente tvc
    ON tvc.IdCliente = tac.IdCliente
ORDER BY
    ValorTotalGasto DESC; 


-- Outro exemplo 

WITH DadosAnimais AS (
    SELECT
        a.Id AS IdAnimal,
        a.Nome AS Animal,
        a.Peso,
        a.Sexo,
        c.Nome AS Cliente,
        r.Nome AS Raca,
        e.Nome AS Especie
    FROM Animal a
    INNER JOIN Cliente c
        ON c.Id = a.IdCliente
    INNER JOIN Raca r
        ON r.Id = a.IdRaca
    INNER JOIN Especie e
        ON e.Id = r.IdEspecie
)
SELECT
    IdAnimal,
    Animal,
    Cliente,
    Especie,
    Raca,
    Peso,
    Sexo
FROM DadosAnimais
WHERE Peso > 10
ORDER BY Peso DESC;