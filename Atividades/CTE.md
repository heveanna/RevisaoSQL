# Atividade Prática: CTEs em SQL Server - 20 Questões

Baseado no banco de dados da clínica veterinária, aqui estão 20 questões sobre CTEs, do nível básico ao avançado:

## **NÍVEL BÁSICO (1-5)**

### 1. CTE Simples
Crie uma CTE que liste todos os clientes com seus respectivos animais:
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar WITH para criar uma CTE básica com JOIN

---

### 2. CTE com Agregação
Desenvolva uma CTE que mostre a quantidade de animais por cliente:
```sql
-- Sua resposta aqui
```
**Objetivo**: Agregação com COUNT() em uma CTE

---

### 3. CTE e Filtro
Crie uma CTE que liste apenas clientes que têm mais de 2 animais:
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar HAVING após agregação em CTE

---

### 4. CTE Múltipla Simples
Desenvolva 2 CTEs: uma com clientes e outra com animais, depois as combine:
```sql
-- Sua resposta aqui
```
**Objetivo**: Usar múltiplas CTEs na mesma consulta

---

### 5. CTE com ORDER BY
Crie uma CTE que mostre os produtos ordenados por preço descendente:
```sql
-- Sua resposta aqui
```
**Objetivo**: Ordenação dentro de CTE

---

## **NÍVEL INTERMEDIÁRIO (6-12)**

### 6. CTE com ROW_NUMBER()
Crie uma CTE que numere os agendamentos por funcionário, mais recentes primeiro:
```sql
-- Sua resposta aqui
```
**Objetivo**: Window functions em CTE

---

### 7. CTE com RANK()
Desenvolva uma CTE que classifique os funcionários pelo número de agendamentos:
```sql
-- Sua resposta aqui
```
**Objetivo**: RANK() e ranking de dados

---

### 8. CTE Recursiva - Sequência Simples
Crie uma CTE recursiva que gere números de 1 a 12:
```sql
-- Sua resposta aqui
```
**Objetivo**: Primeira CTE recursiva simples

---

### 9. CTE com UNION ALL
Crie uma CTE que combine vendas de serviços e vendas de produtos com a descrição do tipo:
```sql
-- Sua resposta aqui
```
**Objetivo**: UNION ALL em CTE

---

### 10. CTE com CASE Statement
Desenvolva uma CTE que categorize animais por faixa etária (recém-nascido, jovem, adulto, idoso):
```sql
-- Sua resposta aqui
```
**Objetivo**: Lógica condicional em CTE

---

### 11. CTE com EXISTS
Crie uma CTE que liste apenas clientes que já fizeram agendamentos:
```sql
-- Sua resposta aqui
```
**Objetivo**: Subconsultas com EXISTS em CTE

---

### 12. CTE com Group By Múltiplo
Desenvolva uma CTE que mostre o total de vendas por cliente e por mês:
```sql
-- Sua resposta aqui
```
**Objetivo**: GROUP BY com múltiplos campos

---

## **NÍVEL AVANÇADO (13-20)**

### 13. CTE Recursiva - Hierarquia
Crie uma CTE recursiva que mostre a hierarquia de categorias de produtos (se existir):
```sql
-- Sua resposta aqui
```
**Objetivo**: CTE recursiva com hierarquia

---

### 14. Múltiplas CTEs com Referência Cruzada
Desenvolva 3 CTEs: uma com total de vendas por cliente, outra com total de agendamentos, terceira combinando-as:
```sql
-- Sua resposta aqui
```
**Objetivo**: CTEs complexas que referenciam outras

---

### 15. CTE com DENSE_RANK() e Filtro
Crie uma CTE que identifique o top 3 de clientes por total de gastos, incluindo seu ranking:
```sql
-- Sua resposta aqui
```
**Objetivo**: Window functions + filtro TOP N

---

### 16. CTE Recursiva com Controle de Profundidade
Crie uma CTE recursiva que mostre uma estrutura hierárquica com limite de profundidade:
```sql
-- Sua resposta aqui
```
**Objetivo**: CTE recursiva com controle avançado

---

### 17. CTE com LAG/LEAD
Desenvolva uma CTE que mostre para cada agendamento a data do anterior e próximo por funcionário:
```sql
-- Sua resposta aqui
```
**Objetivo**: Window functions LAG() e LEAD()

---

### 18. CTE Aninhada em INSERT
Crie uma CTE que calcule um resumo mensal de vendas e insira em uma tabela de resumo:
```sql
-- Sua resposta aqui
-- INSERT INTO TabelaResumo ...
```
**Objetivo**: CTE usado em operação DML

---

### 19. CTE com Múltiplas Agregações
Desenvolva uma CTE que traga para cada cliente: total gasto, quantidade de compras, ticket médio, e média de dias entre compras:
```sql
-- Sua resposta aqui
```
**Objetivo**: Múltiplas agregações e cálculos complexos

---

### 20. CTE Recursiva + Window Functions
Crie uma CTE recursiva que gere uma série de datas (últimos 12 meses) e combine com uma CTE que mostre vendas por mês, exibindo também a tendência (diferença em relação ao mês anterior):
```sql
-- Sua resposta aqui
```
**Objetivo**: Combinar recursividade com window functions avançadas

---

## **GABARITO BÁSICO** (Exemplos de Soluções)

Se precisar das respostas, aqui estão alguns exemplos:

<details>
<summary>Ver Gabarito - Questão 1</summary>

```sql
WITH ClientesAnimais AS (
    SELECT 
        c.id as ClienteID,
        c.Nome as NomeCliente,
        a.id as AnimalID,
        a.Nome as NomeAnimal
    FROM Cliente c
    LEFT JOIN Animal a ON c.id = a.idCliente
)
SELECT * FROM ClientesAnimais
```

</details>

<details>
<summary>Ver Gabarito - Questão 6</summary>

```sql
WITH AgendamentosNumerados AS (
    SELECT 
        f.id as FuncionarioID,
        f.Nome,
        ag.DataAgendada,
        ROW_NUMBER() OVER (PARTITION BY f.id ORDER BY ag.DataAgendada DESC) as NumeroAgendamento
    FROM Agendamento ag
    JOIN Funcionario f ON ag.idFuncionario = f.id
)
SELECT * FROM AgendamentosNumerados
```

</details>

<details>
<summary>Ver Gabarito - Questão 8</summary>

```sql
WITH Sequencia AS (
    SELECT 1 AS Numero
    UNION ALL
    SELECT Numero + 1
    FROM Sequencia
    WHERE Numero < 12
)
SELECT * FROM Sequencia
```

</details>

---

**Dicas para resolver:**
- Comece com a estrutura básica: `WITH NomeCTE AS (SELECT ...) SELECT * FROM NomeCTE`
- Para recursivas, sempre tenha: âncora UNION ALL recursão com condição de parada
- Use aliases descritivos para melhor legibilidade
- Teste cada CTE separadamente antes de combiná-las

Deseja que eu revele as respostas completas para alguma questão específica? 🎯