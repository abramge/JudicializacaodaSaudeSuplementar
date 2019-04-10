
#### CARREGAR PACOTES ####

library(devtools)
library(esaj)
library(abjutils)
library(httr)
library(XML)
library(xml2)
library(rvest)
library(dplyr)
library(tibble)
library(rlang)
library(stringr)
library(purrr)
library(zoo)

#### LISTAR ASSUNTOS E CAMARAS ####

assuntos <- as.vector(esaj::cjsg_table("subjects"))
camaras <- esaj::cjsg_table("courts")


#### DOWNLOAD PÁGINA DECISÕES ####


#### EXEMPLO PARA O ANO DE 2018 ####

# setar diretório de trabalho
setwd()

# contar quantidade de processos identificados
n_2018 <- esaj::peek_cjsg(query='',
                          # extrair processos com códigos referentes aos planos de saúde
                          subjects=c('5967','6233','10000629','10000983','10001132','10001318'),
                          # data de início - 1º dia de 2018
                          registration_start="2018-01-01",
                          # data final - último dia de 2018
                          registration_end="2018-12-31",
                          # fonte: TJSP
                          tj="tjsp")

# extrair dados do sistema de consultas sobre processos judiciais
TESTE_2018 <- esaj::download_cjsg(query='',
                                  # extrair processos com códigos referentes aos planos de saúde
                                  subjects=c('5967','6233','10000629','10000983','10001132','10001318'),
                                  # data de início - 1º dia de 2018
                                  registration_start="2018-01-01",
                                  # data final - último dia de 2018
                                  registration_end="2018-12-31",
                                  # fonte: TJSP
                                  tj="tjsp",
                                  # definir o número máximo de páginas no site do TJ
                                  max_page=ceiling(n_2018[2]/20))

# vetorizar e parsear os dados
files_2018 <- as.vector(fs::dir_ls(regexp="page"))
df_files_2018 <- parse_cjsg_teste(files_2018)


#### AGREGAR DADOS E EDITAR DATAS DA BASE FINAL ####

# criar dataframe para editar as datas
df_tjsp_2018 <- df_files_2018

df_tjsp_2018$date_decision_DAY <- as.numeric(substr(df_tjsp_2018$date_decision,0,2))
df_tjsp_2018$date_decision_MONTH <- as.numeric(substr(df_tjsp_2018$date_decision,4,5))
df_tjsp_2018$date_decision_YEAR <- as.numeric(substr(df_tjsp_2018$date_decision,7,10))

df_tjsp_2018$date_decision_FINAL <- as.Date(as.yearmon(paste(df_tjsp_2018$date_decision_YEAR,
                                                             df_tjsp_2018$date_decision_MONTH,
                                                             df_tjsp_2018$date_decision_DAY),
                                                       "%d/%m/%Y"),
                                            format="%d/%m/%Y")

df_tjsp_2018$date_decision_Q <- ifelse(df_tjsp_2018$date_decision_MONTH <= 3 & df_tjsp_2018$date_decision_MONTH >= 1, 3,
                                       ifelse(df_tjsp_2018$date_decision_MONTH <= 6 & df_tjsp_2018$date_decision_MONTH >= 4, 6,
                                              ifelse(df_tjsp_2018$date_decision_MONTH <= 9 & df_tjsp_2018$date_decision_MONTH >= 7, 9,
                                                     ifelse(df_tjsp_2018$date_decision_MONTH <= 12 & df_tjsp_2018$date_decision_MONTH >= 10, 12, 0
                                                     ))))

df_tjsp_2018$date_decision_QUARTER <- as.Date(as.yearmon(paste(df_tjsp_2018$date_decision_YEAR,
                                                               df_tjsp_2018$date_decision_Q),
                                                         "%Y %m"),
                                              format="%d/%m/%Y")


df_tjsp_2018$date_publication_DAY <- as.numeric(substr(df_tjsp_2018$date_publication,0,2))
df_tjsp_2018$date_publication_MONTH <- as.numeric(substr(df_tjsp_2018$date_publication,4,5))
df_tjsp_2018$date_publication_YEAR <- as.numeric(substr(df_tjsp_2018$date_publication,7,10))

df_tjsp_2018$date_publication_FINAL <- as.Date(as.yearmon(paste(df_tjsp_2018$date_publication_YEAR,
                                                                df_tjsp_2018$date_publication_MONTH,
                                                                df_tjsp_2018$date_publication_DAY),
                                                          "%d/%m/%Y"),
                                               format="%d/%m/%Y")

df_tjsp_2018$date_publication_Q <- ifelse(df_tjsp_2018$date_publication_MONTH <= 3 & df_tjsp_2018$date_publication_MONTH >= 1, 3,
                                          ifelse(df_tjsp_2018$date_publication_MONTH <= 6 & df_tjsp_2018$date_publication_MONTH >= 4, 6,
                                                 ifelse(df_tjsp_2018$date_publication_MONTH <= 9 & df_tjsp_2018$date_publication_MONTH >= 7, 9,
                                                        ifelse(df_tjsp_2018$date_publication_MONTH <= 12 & df_tjsp_2018$date_publication_MONTH >= 10, 12,
                                                               0))))

df_tjsp_2018$date_publication_QUARTER <- as.Date(as.yearmon(paste(df_tjsp_2018$date_publication_YEAR,
                                                                  df_tjsp_2018$date_publication_Q),
                                                            "%Y %m"),
                                                 format="%d/%m/%Y")


df_tjsp_2018$date_registration_DAY <- as.numeric(substr(df_tjsp_2018$date_registration,0,2))
df_tjsp_2018$date_registration_MONTH <- as.numeric(substr(df_tjsp_2018$date_registration,4,5))
df_tjsp_2018$date_registration_YEAR <- as.numeric(substr(df_tjsp_2018$date_registration,7,10))

df_tjsp_2018$date_registration_FINAL <- as.Date(as.yearmon(paste(df_tjsp_2018$date_registration_YEAR,
                                                                 df_tjsp_2018$date_registration_MONTH,
                                                                 df_tjsp_2018$date_registration_DAY),
                                                           "%d/%m/%Y"),
                                                format="%d/%m/%Y")

df_tjsp_2018$date_registration_Q <- ifelse(df_tjsp_2018$date_registration_MONTH <= 3 & df_tjsp_2018$date_registration_MONTH >= 1, 3,
                                           ifelse(df_tjsp_2018$date_registration_MONTH <= 6 & df_tjsp_2018$date_registration_MONTH >= 4, 6,
                                                  ifelse(df_tjsp_2018$date_registration_MONTH <= 9 & df_tjsp_2018$date_registration_MONTH >= 7, 9,
                                                         ifelse(df_tjsp_2018$date_registration_MONTH <= 12 & df_tjsp_2018$date_registration_MONTH >= 10, 12, 0
                                                                ))))

df_tjsp_2018$date_registration_QUARTER <- as.Date(as.yearmon(paste(df_tjsp_2018$date_registration_YEAR,
                                                                   df_tjsp_2018$date_registration_Q),
                                                             "%Y %m"),
                                                  format="%d/%m/%Y")

#### SALVAR O ARQUIVO FINAL ####

saveRDS(df_tjsp_2018,file="df_tjsp_2018.rds")


