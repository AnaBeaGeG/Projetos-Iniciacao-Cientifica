  # Repositório de Projetos de Iniciação Científica

Este repositório contém os trabalhos desenvolvidos durante minha iniciação científica no Laboratório de Matemática Aplicada do Rio de Janeiro - UFRJ, com foco na análise de dados do segmento de mortalidade para empresas do mercado segurador, utilizando **PL/SQL no banco de dados Oracle** e **Power BI** para visualização.

O principal objetivo das consultas presentes neste repositório era produzir relatórios para as empresas que nos forneceram dados, com o intuito de identificar e evidenciar possíveis inconsistências, ausências ou erros nos dados submetidos.

## 💾 Contexto e Estrutura dos Dados

Os dados fornecidos pelas empresas estavam organizados em múltiplas tabelas distintas dentro do esquema do usuário `RODRIGO` no banco de dados Oracle. Para consolidar essas informações e facilitar a análise, realizei uma **iteração sobre todas as tabelas que seguiam um padrão de nomenclatura específico** (`SG_AT_MOR%` para ativos e `SG_SA%` para saídas), permitindo a unificação dos dados antes da manipulação e análise detalhada.

## 📊 Colunas Relevantes para a Análise

As seguintes colunas foram consideradas cruciais para a análise realizada:

- `emp`: Nome da empresa
- `cod_emp`: Código da empresa
- `ref_info`: Ano ao qual os dados se referem
- `cpf`: Cadastro de Pessoa Física
- `sexo`: Sexo do indivíduo
- `data_nasc`: Data de nascimento
- `data_ingr`: Data de ingresso no seguro
- `produto`: Tipo de produto de seguro
- `cobertura`: Tipo de cobertura do seguro
- `linha_valida`: Indicador binário que sinaliza se o registro possui os campos relevantes válidos para utilização na análise
- `repeticoes`: Número de vezes que a mesma linha foi identificada no arquivo original

## ⚙️ Metodologia e Visões Materializadas

A opção pela criação de **materialized views** (`CREATE MATERIALIZED VIEW`) foi estratégica. Dada a natureza da consulta, que envolve a união de um grande volume de dados e a necessidade de execução frequente para geração de relatórios, as materialized views proporcionam uma significativa melhoria no desempenho. Os resultados das consultas são pré-computados e armazenados, reduzindo o tempo de execução em acessos subsequentes.

### `ATIVOS_MOR`: Base de Dados de Ativos

A materialized view `ATIVOS_MOR` serviu como uma camada base, contendo apenas as colunas essenciais extraídas das tabelas originais. Essa visão simplificada forneceu a estrutura necessária para as etapas de manipulação subsequentes.

### `ATIVOS_MOR_AGRUPADOS`: Análise e Cálculos Adicionais

A materialized view `ATIVOS_MOR_AGRUPADOS` foi construída a partir da `ATIVOS_MOR` e incorporou diversas transformações e cálculos para gerar insights relevantes:

- **Faixa Etária:** Categorização dos segurados em diferentes faixas de idade.
- **Estoque Inicial:** Identificação dos segurados que já possuíam o seguro no ano anterior (`ref_info - 1`) e permaneceram segurados no ano de referência (`ref_info`).
- **Estoque Final:** Identificação dos segurados que permaneceram com o seguro até o final do ano de referência (`ref_info`).
- **Entradas:** Identificação dos novos segurados para o ano de referência (`ref_info`).
- **Coringas:** Identificação de CPFs que foram associados a mais de uma combinação única de data de nascimento e sexo, sinalizando possíveis inconsistências nos dados.

Os scripts SQL para a criação dessas materialized views e as consultas adicionais podem ser encontrados na pasta `consultas_sql` deste repositório.
