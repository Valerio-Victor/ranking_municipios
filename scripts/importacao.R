# PACOTES NECESSÁRIOS: ----------------------------------------------------
library(basedosdados)
library(magrittr, include.only = '%>%')


# IMPORTAÇÃO DOS DADOS: ---------------------------------------------------
# Utilizar o seu ID (entre as aspas) Google Cloud no código abaixo:
basedosdados::set_billing_id(billing_project_id = '')

# Para identificar o tabela no site base dos dados basta "juntar"
# o nome do conjunto com o nome da tabela, no nosso caso.
# Nome do Conjunto: br_me_siconfi
# Nome da Tabela: municipio_despesas_orcamentarias
dados <- basedosdados::bdplyr(
  table = 'br_me_siconfi.municipio_despesas_funcao')

# Ao imprimir os dados no console pode-se ter uma ideia das primeiras linhas da
# tabela.
dados

# Neste caso, vou filtrar a base para o ano de 2022.
despesas_2022 <- dados %>%
  dplyr::filter(ano == 2022)

# Caso você queira traduzir o comando acima em linguagem SQL basta utilizar o
# comando abaixo, mas isso é opcional.
dplyr::show_query(despesas_2022)

# Para coletar os dados já filtrados para o R, deve-se executar o comando
# bd_collect(). Neste caso, vou atribuir o nome final para o objeto.
despesas_municipais_2022 <- basedosdados::bd_collect(despesas_2022)

# Para evitar ficar baixando os dados da núvem, vou exportar em formato csv
write.csv2(x = despesas_municipais_2022,
           file = './dados/despesas_municipais_2022_funcao.csv')

# Da próxima vez, podemos apenas importar o csv dos dados gerados para 2022.
# Basta utilizar o código abaixo:
despesas_municipais_2022 <- readr::read_csv2(
  file = './dados/despesas_municipais_2022_funcao.csv')


# ARRUMAÇÃO DOS DADOS: ----------------------------------------------------
# Despesas com estagio e conta:
despesas_estagio_conta <- despesas_municipais_2022 %>%
  dplyr::select(id_municipio,
                estagio_bd,
                conta_bd,
                valor) %>%
  dplyr::group_by(id_municipio,
                  estagio_bd,
                  conta_bd) %>%
  dplyr::summarise(valor = sum(valor)/1000)

# Despesas com conta, apenas:
despesas_conta <- despesas_municipais_2022 %>%
  dplyr::select(id_municipio,
                conta_bd,
                valor) %>%
  dplyr::group_by(id_municipio,
                  conta_bd) %>%
  dplyr::summarise(valor = sum(valor)/1000)

# Uma dificuldade seria pensar em agrupar as contas (ou estágios) em variáveis
# insumos, devido a quantidade de rubricas:
unique(despesas_estagio_conta$estagio) # Ao todo, são 5 estágios
unique(despesas_estagio_conta$conta) # Ao todo, são 158 contas

