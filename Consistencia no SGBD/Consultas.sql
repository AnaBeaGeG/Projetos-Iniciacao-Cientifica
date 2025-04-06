--Consultas relatório das empresas

--View para ativos do segmento de mortalidade
--Unifica todas as informações das tabelas inseridas no usuário do Rodrigo
DECLARE
    -- Variável que vai armazenar a consulta em SQL
    v_sql VARCHAR(32767) := 'CREATE MATERIALIZED VIEW ATIVOS_MOR AS ';
    -- Variável que indica o início da consulta 
    -- sem ela, a última tabela a ser inserida na consulta terminaria com union all sem nada posteriormente, o que significaria erro
    first_table BOOLEAN := TRUE;
BEGIN
    FOR r IN (SELECT table_name FROM all_tables WHERE owner = 'RODRIGO' AND table_name LIKE 'SG_AT_MOR%' AND table_name NOT LIKE '%ERR%') LOOP
        IF first_table THEN
            v_sql := v_sql || 'SELECT emp, cod_emp, ref_info, cpf, sexo, data_nasc, ref_info - EXTRACT(YEAR FROM data_nasc) AS IDADE, data_ingr, produto, cobertura, linha_valida, repeticoes FROM rodrigo.' || r.table_name;
            first_table := FALSE;
        ELSE
            v_sql := v_sql || ' UNION ALL SELECT emp, cod_emp, ref_info, cpf, sexo, data_nasc, ref_info - EXTRACT(YEAR FROM data_nasc) AS IDADE, data_ingr, produto, cobertura, linha_valida, repeticoes FROM rodrigo.' || r.table_name;
        END IF;
    END LOOP;
    
    EXECUTE IMMEDIATE v_sql;
END;


--Reduzindo o número de linhas desse "tabelão" para rodar as consultas a partir do agrupamento dos dados
CREATE MATERIALIZED VIEW ATIVOS_MOR_AGRUPADOS AS
SELECT emp, cod_emp, sexo, ref_info, data_ingr, data_nasc, idade, produto, cobertura, count(cpf) as qtde_cpf,
COUNT(cpf) OVER (PARTITION BY cpf, sexo, data_nasc, ref_info, emp, cod_emp) AS CORINGAS,
SUM(CASE
  WHEN EXTRACT(YEAR FROM DATA_INGR) = REF_INFO THEN 1
  ELSE 0
END) AS SOMA_ENTRADAS,
SUM(CASE
 WHEN DATA_INGR=999999 THEN 1
 ELSE 0
END) AS SOMA_ESTOQUE_FINAL,
SUM(CASE 
 WHEN EXTRACT(YEAR FROM DATA_INGR) != REF_INFO AND DATA_INGR != 999999 THEN 1
 ELSE 0
END) AS SOMA_ESTOQUE_INICIAL,
CASE				
 WHEN IDADE BETWEEN 0 AND 4 THEN '00 a 04'		
 WHEN IDADE BETWEEN 5 AND 9 THEN '05 a 09' 		
 WHEN IDADE BETWEEN 10 AND 14 THEN '10 a 14'				
 WHEN IDADE BETWEEN 15 AND 19 THEN '15 a 19'				
 WHEN IDADE BETWEEN 20 AND 24 THEN '20 a 24'				
 WHEN IDADE BETWEEN 25 AND 29 THEN '25 a 29'				
 WHEN IDADE BETWEEN 30 AND 34 THEN '30 a 34'				
 WHEN IDADE BETWEEN 35 AND 39 THEN '35 a 39'				
 WHEN IDADE BETWEEN 40 AND 44 THEN '40 a 44'				
 WHEN IDADE BETWEEN 45 AND 49 THEN '45 a 49'				
 WHEN IDADE BETWEEN 50 AND 54 THEN '50 a 54'				
 WHEN IDADE BETWEEN 55 AND 59 THEN '55 a 59'				
 WHEN IDADE BETWEEN 60 AND 64 THEN '60 a 64'				
 WHEN IDADE BETWEEN 65 AND 69 THEN '65 a 69'				
 WHEN IDADE BETWEEN 70 AND 74 THEN '70 a 74'				
 WHEN IDADE BETWEEN 75 AND 79 THEN '75 a 79'				
 WHEN IDADE BETWEEN 80 AND 84 THEN '80 a 84'				
 WHEN IDADE BETWEEN 85 AND 89 THEN '85 a 89'				
 WHEN IDADE BETWEEN 90 AND 94 THEN '90 a 94'				
 WHEN IDADE BETWEEN 95 AND 100 THEN '95 a 100'		
 ELSE '+100'				
END FAIXA_ETÁRIA, sum(repeticoes) as qtde_linhas_repetidas, linha_valida, count(linha_valida)
FROM ATIVOS_MOR
group by emp, cod_emp, sexo, ref_info, data_ingr, data_nasc, idade, produto, cobertura, linha_valida
CASE				
 WHEN IDADE BETWEEN 0 AND 4 THEN '00 a 04'		
 WHEN IDADE BETWEEN 5 AND 9 THEN '05 a 09' 		
 WHEN IDADE BETWEEN 10 AND 14 THEN '10 a 14'				
 WHEN IDADE BETWEEN 15 AND 19 THEN '15 a 19'				
 WHEN IDADE BETWEEN 20 AND 24 THEN '20 a 24'				
 WHEN IDADE BETWEEN 25 AND 29 THEN '25 a 29'				
 WHEN IDADE BETWEEN 30 AND 34 THEN '30 a 34'				
 WHEN IDADE BETWEEN 35 AND 39 THEN '35 a 39'				
 WHEN IDADE BETWEEN 40 AND 44 THEN '40 a 44'				
 WHEN IDADE BETWEEN 45 AND 49 THEN '45 a 49'				
 WHEN IDADE BETWEEN 50 AND 54 THEN '50 a 54'				
 WHEN IDADE BETWEEN 55 AND 59 THEN '55 a 59'				
 WHEN IDADE BETWEEN 60 AND 64 THEN '60 a 64'				
 WHEN IDADE BETWEEN 65 AND 69 THEN '65 a 69'				
 WHEN IDADE BETWEEN 70 AND 74 THEN '70 a 74'				
 WHEN IDADE BETWEEN 75 AND 79 THEN '75 a 79'				
 WHEN IDADE BETWEEN 80 AND 84 THEN '80 a 84'				
 WHEN IDADE BETWEEN 85 AND 89 THEN '85 a 89'				
 WHEN IDADE BETWEEN 90 AND 94 THEN '90 a 94'				
 WHEN IDADE BETWEEN 95 AND 100 THEN '95 a 100'		
 ELSE '+100'				
END
