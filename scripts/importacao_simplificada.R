# PACOTES NECESSÁRIOS: ----------------------------------------------------
library(magrittr, include.only = '%>%')


# IMPORTAÇÃO DOS DADOS: ---------------------------------------------------
# Da próxima vez, podemos apenas importar o csv dos dados gerados para 2022.
# Basta utilizar o código abaixo:
despesas_municipais_2022 <- readr::read_csv2(
  file = './dados/despesas_municipais_2022.csv')


# ARRUMAÇÃO DOS DADOS: ----------------------------------------------------
# Despesas com estagio e conta:
despesas_estagio_conta <- despesas_municipais_2022 %>%
  dplyr::select(id_municipio,
                estagio,
                conta,
                valor) %>%
  dplyr::group_by(id_municipio,
                  estagio,
                  conta) %>%
  dplyr::summarise(valor = sum(valor)/1000)

# Despesas com conta, apenas:
despesas_conta <- despesas_municipais_2022 %>%
  dplyr::select(id_municipio,
                conta,
                valor) %>%
  dplyr::group_by(id_municipio,
                  conta) %>%
  dplyr::summarise(valor = sum(valor)/1000)

# Uma dificuldade seria pensar em agrupar as contas (ou estágios) em variáveis
# insumos, devido a quantidade de rubricas:
unique(despesas_estagio_conta$estagio) # Ao todo, são 5 estágios
unique(despesas_estagio_conta$conta) # Ao todo, são 158 contas
