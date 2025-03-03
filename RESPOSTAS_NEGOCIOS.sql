
-- Liste usuários com aniversário de hoje cujo número de vendas realizadas em janeiro de 2020 seja superior a 1500.
SELECT * FROM (

SELECT C.NAME, 
      COUNT(O.ORDER_ID) AS  QTDE_VENDAS

FROM CUSTOMER C

LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID 

WHERE TIPO_CLIENTE = 'VENDEDORES'
AND DATA_NASCIMENTO = CONVERT(DATE,GETDATE())
AND ORDER_DATE >= '2020-01-01'

GROUP BY NAME)

WHERE QTDE_VENDAS > 1500

/* Para cada mês de 2020, são solicitados os 5 principais usuários que mais venderam (R$) na categoria Celulares. 
São obrigatórios o mês e ano da análise, nome e sobrenome do vendedor, quantidade de vendas realizadas, 
quantidade de produtos vendidos e valor total transacionado. */

WITH TOP_CELULARES AS 

(
SELECT C.NAME,
	   C.SOBRENOME,
	   FORMAT(ORDER_DATE,'MM/YYYY') AS DATA_ANALISE,
       COUNT(O.ORDER_ID) AS  QTDE_VENDAS,
	   SUM(O.VALOR_ORDER) AS VALOR_TOTAL,
	   ROW_NUMBER() OVER(PARTITION BY FORMAT(ORDER_DATE,'MM/YYYY') ORDER BY SUM(O.VALOR_ORDER) DESC) AS RK

FROM CUSTOMER C

LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID 
LEFT JOIN ITEM   I ON I.ITEM_ID = O.ITEM_ID

WHERE TIPO_CLIENTE = 'VENDEDORES'
AND I.ITEM_NOME = 'CELULAR'
AND ORDER_DATE BETWEEN '2020-01-01' AND '2020-12-31'

GROUP BY NAME, SOBRENOME,FORMAT(ORDER_DATE,'MM/YYYY') 
)

SELECT * FROM TOP_CELULARES

WHERE RK <= 5



