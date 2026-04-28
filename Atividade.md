Abaixo estão questões práticas usando as tabelas que aparecem no seu banco: `Cliente`, `Animal`, `AnimalAlergia`, `VendaServico`, `HistoricoVacina`, `HistoricoPreco`, `Venda`, `Agendamento`, `VendaProduto`, `Fornecedor`, `Funcionario`, `Produto`, `TipoPagamento`, `Raca`, `FuncionarioEspecialidade`, `Especie`, `CategoriaProduto`, `TipoServico`, `ProdutoFornecedor` e `Pagamento`.

A ideia é você tentar montar os comandos SQL sozinho. Foque em `SELECT`, filtros, `JOINs` e subselects.

## 1. SELECT e filtros

1. Liste todos os clientes cadastrados.

2. Liste apenas o nome, telefone e e-mail dos clientes.

3. Liste todos os animais cadastrados.

4. Liste os animais cujo sexo seja masculino.

5. Liste os animais com peso maior que 10 kg.

6. Liste os animais nascidos depois de uma determinada data.

7. Liste os produtos com preço maior que R$ 50,00.

8. Liste os produtos com estoque menor que 10 unidades.

9. Liste os produtos ativos.

10. Liste os produtos inativos.

11. Liste os funcionários ordenados pelo nome em ordem alfabética.

12. Liste os clientes ordenados pela data de cadastro, do mais recente para o mais antigo.

13. Liste os agendamentos marcados para uma data específica.

14. Liste os agendamentos que ainda estão pendentes.

15. Liste as vendas feitas em um determinado mês.

16. Liste os pagamentos com valor maior que R$ 100,00.

17. Liste os produtos cujo nome contenha a palavra `"ração"`.

18. Liste os clientes cujo nome comece com a letra `"A"`.

19. Liste os animais que não possuem data de nascimento cadastrada.

20. Liste os produtos que têm preço entre R$ 20,00 e R$ 100,00.

Exemplo esperado de raciocínio:

```sql
SELECT *
FROM Produto
WHERE Preco BETWEEN 20 AND 100;
```

Mas adapte os nomes das colunas ao seu banco real.

## 2. JOINs básicos

21. Liste o nome de cada animal junto com o nome do seu cliente/dono.

22. Liste o nome do animal, a espécie e a raça.

23. Liste todos os animais com seus respectivos donos, mesmo que algum dado relacionado esteja incompleto.

24. Liste todos os clientes e seus animais, incluindo clientes que ainda não têm animal cadastrado.

25. Liste os produtos junto com suas categorias.

26. Liste as vendas junto com o nome do cliente que realizou a compra.

27. Liste os pagamentos junto com a venda correspondente e o tipo de pagamento usado.

28. Liste os produtos vendidos em cada venda.

29. Liste o nome do produto, quantidade vendida e valor unitário em cada item de venda.

30. Liste os serviços vendidos em cada venda.

31. Liste o nome do serviço, nome do cliente e data da venda.

32. Liste os agendamentos com o nome do cliente, nome do animal e nome do funcionário responsável.

33. Liste os funcionários e suas especialidades.

34. Liste todos os funcionários, mesmo os que ainda não possuem especialidade cadastrada.

35. Liste todos os tipos de serviço e os funcionários especializados neles.

36. Liste os produtos e seus fornecedores.

37. Liste todos os fornecedores e os produtos que eles fornecem.

38. Liste os produtos que possuem mais de um fornecedor.

39. Liste os históricos de vacinação com o nome do animal e o nome do cliente.

40. Liste as alergias de cada animal com o nome do animal e do dono.

## 3. JOINs com filtros

41. Liste os animais da espécie `"Cachorro"`.

42. Liste os animais da raça `"Poodle"`.

43. Liste os clientes que possuem animais da espécie `"Gato"`.

44. Liste os produtos da categoria `"Medicamento"`.

45. Liste as vendas feitas por um cliente específico.

46. Liste todos os pagamentos feitos com cartão de crédito.

47. Liste os agendamentos de um funcionário específico.

48. Liste os agendamentos de uma data específica mostrando cliente, animal e serviço.

49. Liste as vacinas aplicadas em animais de um cliente específico.

50. Liste os produtos vendidos em vendas acima de R$ 200,00.

51. Liste os serviços vendidos para animais da espécie `"Cachorro"`.

52. Liste os fornecedores que fornecem produtos da categoria `"Ração"`.

53. Liste os funcionários especializados em `"Banho e Tosa"`.

54. Liste as vendas de produto feitas em determinado mês.

55. Liste os clientes que compraram determinado produto.

56. Liste os animais que possuem alergias cadastradas.

57. Liste os animais que não possuem alergias cadastradas.

58. Liste os produtos que nunca foram vendidos.

59. Liste os serviços que nunca foram vendidos.

60. Liste os clientes que nunca fizeram uma venda.

## 4. Agregações com JOIN

61. Mostre a quantidade de animais por cliente.

62. Mostre a quantidade de animais por espécie.

63. Mostre a quantidade de animais por raça.

64. Mostre a quantidade de produtos por categoria.

65. Mostre o total vendido por venda.

66. Mostre o total gasto por cada cliente.

67. Mostre a quantidade de vendas por cliente.

68. Mostre a quantidade de produtos vendidos por produto.

69. Mostre o faturamento total por produto.

70. Mostre o faturamento total por serviço.

71. Mostre a quantidade de agendamentos por funcionário.

72. Mostre a quantidade de agendamentos por status.

73. Mostre a quantidade de pagamentos por tipo de pagamento.

74. Mostre o valor total recebido por tipo de pagamento.

75. Mostre o total de vacinas aplicadas por animal.

76. Mostre o total de vacinas aplicadas por espécie.

77. Mostre os clientes com mais de 2 animais.

78. Mostre os produtos que venderam mais de 10 unidades.

79. Mostre os funcionários com mais de 5 agendamentos.

80. Mostre as categorias de produto com mais de 3 produtos cadastrados.

## 5. Subselects simples

81. Liste os clientes que possuem pelo menos um animal cadastrado.

82. Liste os clientes que não possuem animais cadastrados.

83. Liste os animais que possuem alergia cadastrada.

84. Liste os animais que nunca foram vacinados.

85. Liste os produtos que já foram vendidos.

86. Liste os produtos que nunca foram vendidos.

87. Liste os serviços que já foram vendidos.

88. Liste os serviços que nunca foram vendidos.

89. Liste os clientes que já fizeram alguma venda.

90. Liste os clientes que nunca fizeram venda.

Exemplo de raciocínio:

```sql
SELECT *
FROM Cliente
WHERE IdCliente IN (
    SELECT IdCliente
    FROM Animal
);
```

Ou, dependendo do caso, usando `NOT IN`.

## 6. Subselects com comparação

91. Liste os produtos com preço maior que a média dos produtos.

92. Liste os produtos com preço menor que a média dos produtos.

93. Liste os clientes que gastaram mais que a média geral de gasto dos clientes.

94. Liste as vendas com valor maior que a média das vendas.

95. Liste os produtos com estoque acima da média.

96. Liste os produtos com estoque abaixo da média.

97. Liste os funcionários que têm mais agendamentos que a média de agendamentos por funcionário.

98. Liste os clientes que possuem mais animais que a média de animais por cliente.

99. Liste os serviços cujo preço atual é maior que a média dos serviços.

100. Liste os produtos cujo preço está acima do maior preço histórico anterior registrado.

## 7. Questões mais próximas de prova

101. Liste nome do cliente, nome do animal, espécie e raça, apenas para animais ativos.

102. Liste nome do cliente, nome do produto, quantidade comprada e data da venda.

103. Liste nome do cliente, nome do serviço, nome do funcionário e data do agendamento.

104. Liste os clientes que compraram produtos, mas nunca compraram serviços.

105. Liste os clientes que compraram serviços, mas nunca compraram produtos.

106. Liste os clientes que compraram tanto produtos quanto serviços.

107. Liste os animais que possuem histórico de vacina, mas não possuem alergias.

108. Liste os animais que possuem alergias, mas nunca foram vacinados.

109. Liste os produtos que possuem fornecedor, mas nunca foram vendidos.

110. Liste os fornecedores que fornecem produtos com estoque baixo.

111. Liste os funcionários que têm especialidade, mas nunca atenderam agendamento.

112. Liste os tipos de serviço que existem no sistema, mas nunca foram vendidos.

113. Liste os clientes com venda registrada, mas sem pagamento registrado.

114. Liste as vendas que possuem mais de um produto vendido.

115. Liste as vendas que possuem produto e serviço na mesma venda.

116. Liste o cliente que mais gastou no sistema.

117. Liste o produto mais vendido.

118. Liste o serviço mais vendido.

119. Liste o funcionário com mais agendamentos.

120. Liste a espécie com mais animais cadastrados.

## 8. Desafios mais difíceis

121. Monte uma consulta que retorne o ranking dos clientes que mais gastaram.

122. Monte uma consulta que retorne o ranking dos produtos mais vendidos.

123. Monte uma consulta que retorne o faturamento mensal.

124. Monte uma consulta que retorne o faturamento mensal separado por produto e serviço.

125. Monte uma consulta que mostre o ticket médio por cliente.

126. Monte uma consulta que mostre o valor médio de cada venda.

127. Monte uma consulta que mostre clientes que ficaram mais de 6 meses sem comprar.

128. Monte uma consulta que mostre animais sem vacina nos últimos 12 meses.

129. Monte uma consulta que mostre produtos sem venda nos últimos 3 meses.

130. Monte uma consulta que mostre fornecedores que fornecem produtos nunca vendidos.

131. Monte uma consulta que mostre funcionários que atendem mais de um tipo de serviço.

132. Monte uma consulta que mostre clientes que têm animais de mais de uma espécie.

133. Monte uma consulta que mostre produtos cujo preço atual é diferente do último preço histórico.

134. Monte uma consulta que mostre o último preço registrado de cada produto.

135. Monte uma consulta que mostre a última vacina aplicada em cada animal.

136. Monte uma consulta que mostre o último agendamento de cada cliente.

137. Monte uma consulta que mostre a última venda de cada cliente.

138. Monte uma consulta que mostre clientes com mais de um pagamento pendente.

139. Monte uma consulta que mostre o total pago e o total pendente por venda.

140. Monte uma consulta que mostre o saldo restante de cada venda, considerando pagamentos parciais.

Minha sugestão: faça primeiro as questões 1 a 30 sem consultar resposta. Depois passe para 31 a 60. As de 100 para frente já são nível mais próximo de sistema real/prova prática.
