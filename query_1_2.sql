WITH table_sum as (
    SELECT
        VENDAS.COD_VENDEDOR,
        VENDEDOR.COD_LOJA,
        SUM(VENDAS.QUANTIDADE) as sum_quantidade
    from
        VENDAS
        LEFT JOIN VENDEDOR ON VENDAS.COD_VENDEDOR = VENDEDOR.COD_VENDEDOR
--------------- INSERIR AQUI OS FILTROS:		
    WHERE
        VENDAS.COD_PRODUTO == 'PROD_2'
        AND VENDAS.DATA BETWEEN 1
        AND 10
--------------- FINAL DA INSERÇÃO DE FILTROS
    GROUP BY
        VENDAS.COD_VENDEDOR,
        VENDEDOR.COD_LOJA
),
table_avg as (
    SELECT
        VENDAS_SUM.COD_LOJA,
        AVG(VENDAS_SUM.sum_quantidade) as avg_quantidade,
        SUM(VENDAS_SUM.sum_quantidade) as sum_quantidade
    FROM
        (
            SELECT
                VENDAS.COD_VENDEDOR,
                VENDEDOR.COD_LOJA,
                SUM(VENDAS.QUANTIDADE) as sum_quantidade
            from
                VENDAS
                LEFT JOIN VENDEDOR ON VENDAS.COD_VENDEDOR = VENDEDOR.COD_VENDEDOR
--------------- INSERIR AQUI OS FILTROS:
            WHERE
                VENDAS.COD_PRODUTO == 'PROD_2'
                AND VENDAS.DATA BETWEEN 1
                AND 10
--------------- FINAL DA INSERÇÃO DE FILTROS
            GROUP BY
                VENDAS.COD_VENDEDOR,
                COD_LOJA
        ) AS VENDAS_SUM
    GROUP BY
        VENDAS_SUM.COD_LOJA
-------------- INSERIR CONDIÇÃO DE MAIS DE 1000 VENDAS AQUI:
        HAVING sum_quantidade > 1000
)
SELECT
    table_sum.COD_VENDEDOR,
    table_sum.COD_LOJA,
    table_sum.sum_quantidade - table_avg.avg_quantidade as var_sum_avg
FROM
    table_sum
    INNER JOIN table_avg on table_sum.COD_LOJA = table_avg.COD_LOJA
WHERE
    table_sum.sum_quantidade - table_avg.avg_quantidade > 0
