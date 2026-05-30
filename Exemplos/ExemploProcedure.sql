-- Criando uma Procedure

CREATE OR ALTER PROCEDURE sp_CadastrarAnimal
    @IdCliente INT,
    @IdRaca INT,
    @Nome VARCHAR(80),
    @DataNascimento DATE = NULL,
    @Peso DECIMAL(6,2),
    @Sexo CHAR(1),
    @Observacoes VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 
        FROM Cliente 
        WHERE Id = @IdCliente
    )
    BEGIN
        RAISERROR('Cliente não encontrado.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1 
        FROM Raca 
        WHERE Id = @IdRaca
    )
    BEGIN
        RAISERROR('Raça não encontrada.', 16, 1);
        RETURN;
    END;

    IF @Peso <= 0
    BEGIN
        RAISERROR('O peso do animal deve ser maior que zero.', 16, 1);
        RETURN;
    END;

    IF @Sexo NOT IN ('M', 'F')
    BEGIN
        RAISERROR('O sexo deve ser M ou F.', 16, 1);
        RETURN;
    END;

    INSERT INTO Animal (
        IdCliente,
        IdRaca,
        Nome,
        DataNascimento,
        Peso,
        Sexo,
        Observacoes
    )
    VALUES (
        @IdCliente,
        @IdRaca,
        @Nome,
        @DataNascimento,
        @Peso,
        @Sexo,
        @Observacoes
    );

    SELECT 
        Id,
        IdCliente,
        IdRaca,
        Nome,
        DataNascimento,
        Peso,
        Sexo,
        Observacoes
    FROM Animal
    WHERE Id = SCOPE_IDENTITY();
END;
GO

-- Exmplo de execução de uma procedure

EXEC sp_CadastrarAnimal
    @IdCliente = 1,
    @IdRaca = 2,
    @Nome = 'Mel',
    @DataNascimento = '2022-08-15',
    @Peso = 8.50,
    @Sexo = 'F',
    @Observacoes = 'Animal dócil, sem observações graves.';