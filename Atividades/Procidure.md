Boa base para treinar. Seu modelo tem relacionamentos suficientes para praticar procedure de verdade (com joins, validação, transações e relatórios), sem ficar só em exemplo artificial.

Vou montar em progressão: do básico até um nível que já começa a parecer demanda real de empresa. Não vou entregar as respostas, só os desafios — porque o ganho está em você montar, errar e ajustar.

---

## 1. Procedure mais básica: listar registros

Crie uma procedure chamada `sp_ListarClientes` que retorne todos os clientes (`Cliente`) ordenados por nome.

**Treina:**

* `CREATE PROCEDURE`
* `SELECT`
* `ORDER BY`

---

## 2. Procedure com parâmetro

Crie `sp_BuscarAnimalPorCliente` que receba `@IdCliente` e liste todos os animais desse cliente.

Mostrar:

* nome do animal
* peso
* data de nascimento

Tabela principal: `Animal`

**Treina:**

* parâmetro
* `WHERE`
* filtro por FK

---

## 3. Procedure com insert

Crie `sp_CadastrarCliente` recebendo:

* nome
* cpf
* telefone
* email

Inserir na tabela `Cliente`.

Depois retornar:

> Cliente cadastrado com sucesso

**Treina:**

* insert por procedure
* parâmetros
* retorno simples

---

## 4. Procedure com validação

Crie `sp_CadastrarClienteValidandoCpf`.

Antes de inserir:

* verificar se o CPF já existe.

Se existir:

> CPF já cadastrado

Se não existir:

* inserir.

**Treina:**

* `IF EXISTS`
* validação
* regra de negócio

---

## 5. Procedure com update

Crie `sp_AtualizarPrecoProduto`.

Receber:

* `@IdProduto`
* `@NovoPreco`

Atualizar o preço do produto.

Mas antes:

salvar o preço antigo em `HistoricoPreco`.

**Fluxo:**

1. busca preço atual
2. grava histórico
3. atualiza produto

**Treina:**

* `SELECT INTO variável`
* update
* insert antes do update

---

## 6. Procedure com JOIN

Crie `sp_ListarAgendamentosDetalhados`.

Mostrar:

* nome do cliente
* nome do animal
* nome do funcionário
* tipo serviço
* data/hora agendada

Usar:

* Agendamento
* Cliente
* Animal
* Funcionario
* TipoServico

**Treina:**

* joins reais
* leitura de modelo relacional

---

## 7. Procedure com totalização

Crie `sp_TotalVendasCliente`.

Receber `@IdCliente`.

Retornar:

* quantidade de vendas
* valor total gasto

Base: `Venda`

**Treina:**

* `COUNT`
* `SUM`
* agregação

---

## 8. Procedure com transação

Crie `sp_RegistrarVendaCompleta`.

Fluxo:

1. recebe cliente
2. recebe funcionário
3. recebe produto
4. recebe quantidade
5. cria venda
6. cria item em `VendaProduto`
7. cria pagamento

Usar:

* `BEGIN TRANSACTION`
* `COMMIT`
* `ROLLBACK`

**Treina:**

* transação
* fluxo multi tabela
* cenário real

---

## 9. Procedure com tratamento de erro

Refaça a questão 8 usando:

* `TRY`
* `CATCH`

Se der erro:

retornar a mensagem com `ERROR_MESSAGE()`.

**Treina:**

* robustez
* tratamento profissional

---

## 10. Procedure avançada (nível legal mesmo)

Crie `sp_RelatorioClienteCompleto`.

Receber `@IdCliente`.

Retornar:

### Dados do cliente

* nome
* cpf

### Animais

* nome
* raça
* espécie

### Vacinas

* nome vacina
* aplicação
* próxima dose

### Compras

* data venda
* total

### Agendamentos

* serviço
* funcionário
* data

---

Isso envolve:

* vários joins
* subconsultas
* agrupamentos
* relatório consolidado

Esse exercício já aproxima de procedure usada em ERP/sistema interno.

---

## Ordem ideal de estudo

Faça exatamente assim:

**1 → 2 → 3 → 4 → 6 → 7 → 5 → 8 → 9 → 10**

(5 fica melhor depois que você dominar insert/update básico)

---

## Recomendação real

Se quiser aprender de verdade, para cada uma faça:

1. procedure
2. execute
3. teste erro
4. melhore
5. documente o que aprendeu

Porque procedure só fixa quando você **debuga comportamento**, não quando copia sintaxe.

---

Se quiser, eu também posso montar as **10 soluções comentadas**, mas no estilo professor: explicando *por que cada parte da procedure existe*, para você realmente evoluir em SQL Server.
