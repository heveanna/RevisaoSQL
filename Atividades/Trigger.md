# Atividade Prática: TRIGGERS em SQL Server - 15 Questões

Baseado no banco de dados da clínica veterinária, aqui estão 15 questões sobre TRIGGERS, do nível básico ao avançado:

## **NÍVEL BÁSICO (1-5)**

### 1. Trigger INSERT Simples
Crie um trigger que atualize um campo `DataUltimaModificacao` sempre que um novo Cliente for inserido:
```sql
-- Sua resposta aqui
```
**Objetivo**: Criar trigger básico de INSERT com UPDATE

---

### 2. Trigger de Validação
Desenvolva um trigger que valide se o preço do Produto é maior que zero antes de inserir:
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar RAISERROR em trigger

---

### 3. Trigger DELETE com Controle
Crie um trigger que registre o ID de um Cliente deletado em uma tabela de auditoria:
```sql
-- Sua resposta aqui
-- (Crie a tabela AuditoriaCliente também)
```
**Objetivo**: Trigger DELETE com inserção em tabela de auditoria

---

### 4. Trigger UPDATE Simples
Desenvolva um trigger que atualize `DataUltimaModificacao` do Animal sempre que seus dados forem alterados:
```sql
-- Sua resposta aqui
```
**Objetivo**: Trigger UPDATE automático

---

### 5. Trigger com GETDATE()
Crie um trigger que registre a data e hora quando um Agendamento é cancelado (UPDATE status):
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar GETDATE() em trigger

---

## **NÍVEL INTERMEDIÁRIO (6-10)**

### 6. Trigger com INSERTED e DELETED
Desenvolva um trigger que compare o preço antigo e novo do Produto e registre a mudança numa tabela de histórico:
```sql
-- Sua resposta aqui
-- (Crie a tabela HistoricoPrecoProduto também)
```
**Objetivo**: Usar tabelas INSERTED e DELETED

---

### 7. Trigger com Múltiplas Ações
Crie um trigger INSTEAD OF que ao inserir Venda, automaticamente crie um Agendamento correspondente:
```sql
-- Sua resposta aqui
```
**Objetivo**: INSTEAD OF trigger com múltiplas operações

---

### 8. Trigger Recursivo com Controle
Desenvolva um trigger que ao inserir uma Venda, atualize a quantidade em estoque do Produto (se existir tabela de estoque):
```sql
-- Sua resposta aqui
-- (Crie a tabela Estoque se necessário)
```
**Objetivo**: Trigger que causa cascata de updates

---

### 9. Trigger com Condição IF
Crie um trigger que só registre a auditoria se o valor da Venda for maior que R$ 100:
```sql
-- Sua resposta aqui
```
**Objetivo**: Trigger com lógica condicional

---

### 10. Trigger para Atualizar Agregados
Desenvolva um trigger que ao inserir uma Venda, atualize um campo de TotalGasto na tabela Cliente:
```sql
-- Sua resposta aqui
-- (Adicione campo TotalGasto em Cliente se necessário)
```
**Objetivo**: Manter agregados atualizados via trigger

---

## **NÍVEL AVANÇADO (11-15)**

### 11. Trigger com FOR EACH ROW (Múltiplas Linhas)
Crie um trigger que para cada linha inserida em VendaProduto, registre em uma tabela de log incluindo usuário:
```sql
-- Sua resposta aqui
-- (Use SYSTEM_USER para obter o usuário)
```
**Objetivo**: Processar múltiplas linhas em um trigger

---

### 12. Trigger com CURSOR
Desenvolva um trigger que ao deletar um Cliente, delete em cascata todos seus Animais, Agendamentos e Vendas:
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar CURSOR em trigger para exclusões em cascata

---

### 13. Trigger com Validação Complexa
Crie um trigger que valide se um Agendamento não se sobrepõe com outro do mesmo funcionário (validação de conflito de horário):
```sql
-- Sua resposta aqui
-- (Assuma que Agendamento tem DataAgendada e HoraInicio)
```
**Objetivo**: Validação complexa com SELECT em trigger

---

### 14. Trigger AFTER e INSTEAD OF Combinados
Desenvolva um trigger INSTEAD OF INSERT em Venda que faça validações complexas e registre quem inseriu com data/hora:
```sql
-- Sua resposta aqui
-- (Crie a tabela AuditoriaVenda para registros)
```
**Objetivo**: Combinar verificações com registro de auditoria completo

---

### 15. Trigger com Tratamento de Erro
Crie um trigger que ao inserir um Agendamento tente atualizar dados relacionados e, em caso de erro, registre o erro em uma tabela de erros sem interromper a operação:
```sql
-- Sua resposta aqui
-- (Crie a tabela LogErrosTrigger)
```
**Objetivo**: Error handling robusto em triggers com TRY/CATCH

---

## **ESTRUTURA BÁSICA DE TRIGGERS**

Para ajudar você a começar:

```sql
-- Sintaxe básica de um trigger em SQL Server
CREATE TRIGGER NomeTrigger
ON NomeTabela
AFTER/INSTEAD OF INSERT/UPDATE/DELETE
AS
BEGIN
    -- Seu código aqui
    -- Acesso a dados inseridos/atualizados via INSERTED
    -- Acesso a dados deletados via DELETED
END
```

---

## **GABARITO BÁSICO** (Exemplos de Soluções)

<details>
<summary>Ver Gabarito - Questão 1</summary>

```sql
CREATE TRIGGER trg_ClienteInserido
ON Cliente
AFTER INSERT
AS
BEGIN
    UPDATE Cliente
    SET DataUltimaModificacao = GETDATE()
    WHERE id IN (SELECT id FROM INSERTED)
END
```

</details>

<details>
<summary>Ver Gabarito - Questão 2</summary>

```sql
CREATE TRIGGER trg_ValidarPrecoProduto
ON Produto
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED WHERE Preco <= 0)
    BEGIN
        RAISERROR('Preço do produto deve ser maior que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
```

</details>

<details>
<summary>Ver Gabarito - Questão 3</summary>

```sql
-- Criar tabela de auditoria
CREATE TABLE AuditoriaCliente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    Acao VARCHAR(50),
    DataAcao DATETIME DEFAULT GETDATE()
)

-- Criar trigger
CREATE TRIGGER trg_ClienteDeletado
ON Cliente
AFTER DELETE
AS
BEGIN
    INSERT INTO AuditoriaCliente (ClienteID, Acao)
    SELECT id, 'DELETADO' FROM DELETED
END
```

</details>

<details>
<summary>Ver Gabarito - Questão 6</summary>

```sql
CREATE TABLE HistoricoPrecoProduto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ProdutoID INT,
    PrecoAntigo DECIMAL(10,2),
    PrecoNovo DECIMAL(10,2),
    DataMudanca DATETIME DEFAULT GETDATE()
)

CREATE TRIGGER trg_HistoricoPrecoProduto
ON Produto
AFTER UPDATE
AS
BEGIN
    INSERT INTO HistoricoPrecoProduto (ProdutoID, PrecoAntigo, PrecoNovo)
    SELECT 
        d.id,
        d.Preco,
        i.Preco
    FROM DELETED d
    INNER JOIN INSERTED i ON d.id = i.id
    WHERE d.Preco != i.Preco
END
```

</details>

<details>
<summary>Ver Gabarito - Questão 10</summary>

```sql
-- Adicionar coluna se não existir
ALTER TABLE Cliente
ADD TotalGasto DECIMAL(12,2) DEFAULT 0

-- Criar trigger
CREATE TRIGGER trg_AtualizarTotalGastoCliente
ON Venda
AFTER INSERT
AS
BEGIN
    UPDATE Cliente
    SET TotalGasto = TotalGasto + i.Valor
    FROM INSERTED i
    WHERE Cliente.id = i.idCliente
END
```

</details>

<details>
<summary>Ver Gabarito - Questão 13</summary>

```sql
CREATE TRIGGER trg_ValidarConflutoAgendamento
ON Agendamento
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Agendamento a
        INNER JOIN INSERTED i ON a.idFuncionario = i.idFuncionario
        WHERE a.DataAgendada = i.DataAgendada
        AND a.id != i.id
    )
    BEGIN
        RAISERROR('Conflito de horário: funcionário já possui agendamento neste horário', 16, 1)
        ROLLBACK TRANSACTION
    END
END
```

</details>

---

## **DICAS IMPORTANTES**

✅ **Boas Práticas:**
- Sempre use `BEGIN...END` para agrupar múltiplas instruções
- Use `RAISERROR` para validações (com ROLLBACK se necessário)
- Lembre-se de `GETDATE()` para timestamps
- Use `INSERTED` para novos dados e `DELETED` para dados antigos
- Crie tabelas de auditoria/log para rastrear mudanças

⚠️ **Cuidados:**
- Triggers recursivos podem causar problemas - use `SET RECURSIVE_TRIGGERS OFF`
- Não use SELECT * em triggers, seja específico
- Sempre teste triggers em ambiente de desenvolvimento
- Triggers muito complexos podem impactar performance

Deseja que eu revele as respostas completas para alguma questão específica? 🎯