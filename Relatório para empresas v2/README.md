    # Análise de Dados de Invalidez - Relatório Detalhado por Diferentes Critérios de Contagem

Este relatório tem o mesmo objetivo do relatório anterior (Relatório para empresas): fornecer insights sobre os dados enviados pelas empresas, identificando possíveis inconsistências, ausências ou erros. No entanto, devido a algumas limitações e a necessidade de uma análise mais estruturada focada no segmento de invalidez, uma nova abordagem e um conjunto de consultas foram desenvolvidos.

## ⚠️ Contexto e Desafios

O processo de análise anterior, baseado nos dados do usuário `RODRIGO`, enfrentou os seguintes desafios:

* **Dados Incompletos:** As tabelas originais não continham a totalidade das informações que foram fornecidas e são necessárias para uma análise abrangente.
* **Foco em Invalidez:** Houve a necessidade de direcionar a análise especificamente para o segmento de invalidez.
* **Novos Dados e Banco Provisório:** Novos dados foram inseridos, e devido a problemas técnicos com o banco de dados original, optamos por criar um banco de dados provisório. Neste novo ambiente, para cada empresa e tipo de dado (ativos ou saídas), foram criadas tabelas separadas.
* **Necessidade de Estrutura:** As consultas foram reescritas de forma mais estruturada para facilitar a compreensão e manutenção.

## 📊 Metodologias de Contagem Adotadas

Para obter uma visão mais completa e robusta dos dados de invalidez, implementamos a contagem dos segurados utilizando três metodologias distintas:

* **Por Registro (TABELAO\_VIEW\_REG):** Nesta abordagem, cada registro na tabela de ativos (`AT_INV`) é considerado como um segurado individual. As agregações são feitas com base nos atributos presentes em cada registro.

* **Por CPF Único (TABELAO\_VIEW\_CPF\_UNI):** Para mitigar a possibilidade de contagens duplicadas devido a múltiplos registros para o mesmo indivíduo, esta metodologia considera cada CPF único como um segurado. Mesmo que um CPF apareça em diversos registros, ele será contado apenas uma vez dentro do contexto de ano, empresa, código da empresa e cobertura. Para informações como data de ingresso e nascimento, são consideradas as datas mínima e máxima associadas ao CPF.

* **Por Indivíduo (TABELAO\_VIEW\_IND):** Esta metodologia adota um critério ainda mais refinado para identificar um segurado único. Um indivíduo é definido pela combinação única de CPF, data de nascimento e sexo dentro do contexto de ano, empresa, código da empresa e cobertura. Essa abordagem visa eliminar ambiguidades causadas por possíveis erros ou inconsistências nos dados de sexo.

## 🛠️ Views Criadas

Com base nessas metodologias, foram criadas as seguintes views no banco de dados provisório:

* **`SUL.TABELAO_VIEW_REG`:** Contém a análise dos dados de invalidez com contagem por registro. (Detalhes da estrutura e cálculos podem ser encontrados na seção específica deste README).

* **`TABELAO_VIEW_CPF_UNI`:** Apresenta a análise dos dados de invalidez com contagem por CPF único. (Detalhes da estrutura e cálculos podem ser encontrados na seção específica deste README).

* **`TABELAO_VIEW_IND`:** Fornece a análise dos dados de invalidez com contagem por indivíduo, utilizando a tríade CPF, data de nascimento e sexo como identificador único. (Detalhes da estrutura e cálculos podem ser encontrados na seção específica deste README).

