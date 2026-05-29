---

## 20 Questões de DML Triggers — SQL Server

### AFTER Triggers — Nível básico

---

**Questão 1 — AFTER INSERT**
> Recurso: `inserted`, `GETDATE()`

Crie uma tabela `LogVenda` com as colunas `Id`, `IdVenda`, `DataRegistro` e `Mensagem`. Em seguida, crie um trigger `AFTER INSERT` na tabela `Venda` que insira automaticamente um registro em `LogVenda` sempre que uma nova venda for cadastrada, registrando o id da venda, a data/hora atual e a mensagem `'Nova venda registrada'`.

---

**Questão 2 — AFTER DELETE**
> Recurso: `deleted`

Crie uma tabela `LogExclusao` com as colunas `Id`, `IdCliente`, `NomeCliente` e `DataExclusao`. Crie um trigger `AFTER DELETE` na tabela `Cliente` que registre nessa tabela os dados do cliente excluído, usando os valores disponíveis na tabela virtual `deleted`.

---

**Questão 3 — AFTER UPDATE**
> Recurso: `inserted`, `deleted`

Crie um trigger `AFTER UPDATE` na tabela `Produto` que, sempre que o campo `Preco` for atualizado, insira um registro na tabela `HistoricoPreco` com o `IdProduto`, o `PrecoAnterior` (via `deleted`) e o `PrecoNovo` (via `inserted`).

---

**Questão 4 — AFTER INSERT com auditoria de usuário**
> Recurso: `inserted`, `SYSTEM_USER`, `HOST_NAME()`

Crie uma tabela `AuditoriaCliente` com as colunas `Id`, `IdCliente`, `UsuarioSistema`, `Maquina` e `DataAcao`. Crie um trigger `AFTER INSERT` na tabela `Cliente` que registre nessa tabela quem inseriu o cliente, em qual máquina e quando, usando as funções `SYSTEM_USER` e `HOST_NAME()`.

---

**Questão 5 — AFTER DELETE com contagem de linhas**
> Recurso: `deleted`, `@@ROWCOUNT`

Crie um trigger `AFTER DELETE` na tabela `VendaProduto` que, ao ser disparado, registre em uma tabela de log quantas linhas foram excluídas na operação, usando `@@ROWCOUNT`. A mensagem gravada deve conter o texto `'X linha(s) removidas de VendaProduto'`.

---

### AFTER Triggers — Nível básico-intermediário

---

**Questão 6 — AFTER INSERT com validação e ROLLBACK**
> Recurso: `inserted`, `ROLLBACK TRANSACTION`, `RAISERROR`

Crie um trigger `AFTER INSERT` na tabela `AnimalAlergia` que verifique se o `IdAnimal` informado existe na tabela `Animal`. Caso não exista, o trigger deve desfazer a operação com `ROLLBACK TRANSACTION` e informar o erro com `RAISERROR('Animal não encontrado', 16, 1)`.

---

**Questão 7 — AFTER UPDATE bloqueando campo protegido**
> Recurso: `inserted`, `deleted`, `UPDATE(coluna)`, `THROW`

Crie um trigger `AFTER UPDATE` na tabela `Funcionario` que impeça a alteração do campo `Cpf`. Use a função `UPDATE(Cpf)` para detectar se a coluna foi incluída no `SET`. Se sim, execute `ROLLBACK` e lance o erro com `THROW 50001, 'Não é permitido alterar o CPF de um funcionário', 1`.

---

**Questão 8 — AFTER DELETE em cascata controlada**
> Recurso: `deleted`, `ROWCOUNT`, `ROLLBACK TRANSACTION`

Crie um trigger `AFTER DELETE` na tabela `Animal` que exclua automaticamente todos os registros relacionados nas tabelas `AnimalAlergia`, `HistoricoVacina` e `VendaServico` usando o `IdAnimal` presente em `deleted`. Registre em log quantas linhas foram removidas em cada tabela.

---

**Questão 9 — AFTER UPDATE com lógica condicional por coluna**
> Recurso: `inserted`, `deleted`, `UPDATE(coluna)`, `IF`

Crie um trigger `AFTER UPDATE` na tabela `Funcionario` que só execute alguma ação caso a coluna `Salario` tenha sido alterada. Se o novo salário (em `inserted`) for inferior ao salário anterior (em `deleted`), registre um aviso em uma tabela de log com a mensagem `'Redução salarial detectada'`.

---

**Questão 10 — AFTER INSERT evitando recursão**
> Recurso: `TRIGGER_NESTLEVEL()`, `inserted`

Crie um trigger `AFTER INSERT` na tabela `HistoricoPreco` que registre a inserção em uma tabela de auditoria geral. Use `TRIGGER_NESTLEVEL()` para garantir que o trigger não entre em loop caso a própria tabela de auditoria também possua triggers ativos.

---

### INSTEAD OF Triggers — Nível básico-intermediário

---

**Questão 11 — INSTEAD OF INSERT em view simples**
> Recurso: `inserted`, `INSTEAD OF`

Crie uma view `vw_ProdutoFornecedor` que una as tabelas `Produto` e `Fornecedor` exibindo `NomeProduto`, `NomeFornecedor` e `Preco`. Em seguida, crie um trigger `INSTEAD OF INSERT` nessa view que redirecione a inserção para a tabela `Produto`, preenchendo os campos corretos com os dados recebidos via `inserted`.

---

**Questão 12 — INSTEAD OF DELETE em view**
> Recurso: `deleted`, `INSTEAD OF`

Crie uma view `vw_ClienteAnimal` que una `Cliente` e `Animal`. Implemente um trigger `INSTEAD OF DELETE` nessa view que, ao receber um comando de exclusão, exclua apenas o animal correspondente da tabela `Animal`, sem excluir o cliente, usando os dados de `deleted`.

---

**Questão 13 — INSTEAD OF UPDATE redirecionando para duas tabelas**
> Recurso: `inserted`, `deleted`, `INSTEAD OF`

Crie uma view `vw_VendaCliente` que exiba `IdVenda`, `NomeCliente` e `ValorTotal`. Crie um trigger `INSTEAD OF UPDATE` que, ao receber um UPDATE nessa view, atualize o `ValorTotal` na tabela `Venda` e o `Nome` na tabela `Cliente` separadamente, usando os valores de `inserted` para os novos dados.

---

### Nível intermediário

---

**Questão 14 — AFTER INSERT com verificação de duplicidade**
> Recurso: `inserted`, `IF EXISTS`, `ROLLBACK TRANSACTION`, `THROW`

Crie um trigger `AFTER INSERT` na tabela `Cliente` que verifique se já existe outro cliente cadastrado com o mesmo `Cpf`. Use `IF EXISTS` consultando a tabela `Cliente` com o `Cpf` de `inserted`. Se houver duplicidade, execute `ROLLBACK` e lance um erro informando o CPF duplicado na mensagem.

---

**Questão 15 — AFTER UPDATE em múltiplas linhas**
> Recurso: `inserted`, `deleted`, `CURSOR` ou `JOIN entre inserted e deleted`

Crie um trigger `AFTER UPDATE` na tabela `Produto` que funcione corretamente para atualizações em lote (múltiplas linhas). Para cada produto atualizado, registre na tabela `HistoricoPreco` o preço anterior e o novo preço. Resolva sem usar `CURSOR`, fazendo um `INSERT ... SELECT` com `JOIN` entre `inserted` e `deleted` pelo `Id`.

---

**Questão 16 — AFTER INSERT calculando total automaticamente**
> Recurso: `inserted`, `UPDATE` (DML dentro do trigger)

Crie um trigger `AFTER INSERT` na tabela `VendaProduto` que, após cada item inserido, recalcule e atualize o campo `ValorTotal` na tabela `Venda` somando o `Preco` de cada produto multiplicado pela `Quantidade` de todos os itens daquela venda. Use o `IdVenda` de `inserted` para filtrar.

---

**Questão 17 — AFTER DELETE protegendo exclusão de registros ativos**
> Recurso: `deleted`, `IF EXISTS`, `ROLLBACK TRANSACTION`, `RAISERROR`

Crie um trigger `AFTER DELETE` na tabela `Funcionario` que impeça a exclusão caso o funcionário possua agendamentos futuros na tabela `Agendamento` (onde `DataHoraAgendado > GETDATE()`). Se houver agendamentos, execute `ROLLBACK` e informe: `'Funcionário possui agendamentos futuros e não pode ser excluído'`.

---

**Questão 18 — AFTER UPDATE com histórico versionado**
> Recurso: `inserted`, `deleted`, `GETDATE()`, `SYSTEM_USER`

Crie um trigger `AFTER UPDATE` na tabela `TipoServico` que registre em uma tabela `HistoricoTipoServico` cada versão anterior do registro alterado, guardando todos os campos antes da mudança (via `deleted`), além do usuário que fez a alteração (`SYSTEM_USER`) e a data (`GETDATE()`). O objetivo é manter um histórico completo de todas as versões anteriores.

---

**Questão 19 — INSTEAD OF INSERT com regra de negócio complexa**
> Recurso: `inserted`, `IF`, `THROW`, `INSTEAD OF`

Crie um trigger `INSTEAD OF INSERT` na tabela `Agendamento` que valide, antes de confirmar a inserção, se o funcionário informado já possui outro agendamento no mesmo horário na tabela `Agendamento`. Se houver conflito de horário, lance um erro com `THROW` informando o conflito. Se não houver, realize o `INSERT` normalmente dentro do próprio trigger.

---

**Questão 20 — AFTER INSERT + AFTER UPDATE com trigger unificado**
> Recurso: `inserted`, `deleted`, `IF EXISTS`, `TRIGGER_NESTLEVEL()`, `SYSTEM_USER`, `GETDATE()`

Crie um único trigger na tabela `Pagamento` que responda tanto ao `INSERT` quanto ao `UPDATE`. Dentro do trigger, identifique qual operação ocorreu verificando se `deleted` contém linhas (`IF EXISTS (SELECT 1 FROM deleted)`): se não contiver, é um INSERT; se contiver, é um UPDATE. Para cada caso, registre em uma tabela `AuditoriaPagamento` a operação realizada, o usuário, a data e o valor envolvido. Use `TRIGGER_NESTLEVEL()` para evitar execuções recursivas.

---

