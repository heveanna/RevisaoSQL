-- Exemplo de uma Trigger

CREATE OR ALTER TRIGGER trg_RegistrarHistoricoPrecoProduto
ON Produto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HistoricoPreco (
        IdProduto,
        PrecoAnterior,
        PrecoNovo,
        DataAlteracao
    )
    SELECT
        i.Id,
        d.Preco,
        i.Preco,
        CAST(GETDATE() AS DATE)
    FROM inserted i
    INNER JOIN deleted d
        ON i.Id = d.Id
    WHERE i.Preco <> d.Preco;
END;
GO

-- Exemplo de ação para disparar a trigger 

UPDATE Produto
SET Preco = 89.90
WHERE Id = 1;

-- Consulta para ver histórico salvo pela trigger 

SELECT
    hp.Id,
    p.Nome AS Produto,
    hp.PrecoAnterior,
    hp.PrecoNovo,
    hp.DataAlteracao
FROM HistoricoPreco hp
INNER JOIN Produto p
    ON p.Id = hp.IdProduto
ORDER BY hp.DataAlteracao DESC;

