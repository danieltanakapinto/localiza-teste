SELECT
    COD_VENDEDOR,
    MIN(QUANTIDADE - QUANTIDADE_ANTERIOR) AS QUANTIDADE_DELTA
FROM
    (
        SELECT
            COD_VENDEDOR,
			DATA,
            QUANTIDADE,
            LAG(QUANTIDADE, 1, 0) OVER (
			PARTITION by COD_VENDEDOR
                ORDER BY
                    DATA ASC
            ) AS QUANTIDADE_ANTERIOR
        FROM
            VENDAS 
--------------- INSERIR AQUI OS FILTROS:		
        WHERE
            VENDAS.COD_PRODUTO == 'PROD_1'
            AND VENDAS.DATA BETWEEN 1
            AND 10
--------------- FINAL DA INSERÇÃO DE FILTROS    
    )
GROUP BY
    COD_VENDEDOR
HAVING
    QUANTIDADE_DELTA > 0