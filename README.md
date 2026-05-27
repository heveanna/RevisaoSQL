#  Banco de Dados Petshop

Esse repositório foca na prática em Banco de Dados. Este espaço foi criado com o propósito de: servir como um ambiente de treinamento para o desenvolvimento e a consolidação em consultas SQL estruturadas e lógica de programação procedural em bancos de dados relacionais.

O cenário escolhido é o ecossistema de um **Petshop**, um modelo de negócios com entidades, relacionamentos e regras de negócio. Através dele, simulamos desafios reais enfrentados no dia a dia do desenvolvimento de software e da análise de dados, englobando desde o controle de clientes e prontuários médicos de animais até a gestão financeira de vendas e fluxos de estoque.

---

## O Propósito deste Repositório

O repositório foca na autonomia e na evolução gradual do raciocínio lógico. 

### 1. Consultas SQL
Esta seção reúne uma trilha de **140 questões** projetadas para cobrir toda a jornada de construção de queries. Os exercícios estão divididos em níveis de complexidade que forçam o desenvolvedor a evoluir sua percepção sobre a álgebra relacional:
* **Filtros e Seleções Básicas:** Domínio de cláusulas condicionais, operadores lógicos e manipulação de datas e strings.
* **Relacionamentos (JOINs):** Acoplamento preciso de tabelas usando `INNER`, `LEFT` e `RIGHT JOIN` para consolidar dados espalhados pelo sistema.
* **Agregações e Agrupamentos:** Uso de funções de agrupamento (`SUM`, `AVG`, `COUNT`) combinadas com filtros (`HAVING`).
* **Subconsultas Avançadas:** Uso de subselects correlacionados e não-correlacionados (`IN`, `NOT IN`, `EXISTS`) para tomadas de decisão complexas e comparações com médias gerais.
* **Simulações de Prova e Desafios de Negócio:** Questões que simulam demandas reais de uma empresa, como cálculo de faturamento mensal, identificação de clientes inativos, detecção de flutuação de preços históricos e análise de comportamento de compra.

### 2. Automação com Stored Procedures
O foco é aprender a encapsular regras de negócio diretamente no servidor de banco de dados, garantindo performance e segurança. As atividades propõem cenários onde deve automatizar processos como:
* Validação de estoque mínimo no momento da venda.
* Atualização automática de históricos de preços e carteiras de vacinação.
* Rotinas complexas de agendamento e conciliação de pagamentos parciais.

---

## Estrutura do Banco de Dados

 As soluções utilizam uma estrutura robusta composta por 20 tabelas interconectadas:

* **Núcleo de Atendimento:** `Cliente`, `Animal`, `Raca`, `Especie` e `AnimalAlergia`.
* **Operação e Serviços:** `Funcionario`, `Especialidade`, `TipoServico` e `Agendamento`.
* **Comercial e Estoque:** `Produto`, `CategoriaProduto`, `Fornecedor` e `ProdutoFornecedor`.
* **Vendas e Financeiro:** `Venda`, `VendaProduto`, `VendaServico`, `HistoricoPreco`, `HistoricoVacina`, `Pagamento` e `TipoPagamento`.

---
