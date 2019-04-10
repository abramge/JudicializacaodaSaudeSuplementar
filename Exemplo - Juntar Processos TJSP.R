
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


#### ABRIR BASES ANUAIS E APENDAR ####

# setar diretório de trabalho
setwd()

# carregar bases de processos
df_tjsp_2007 <- readRDS(file="list_parse_cposg_2007.rds")
df_tjsp_2008 <- readRDS(file="list_parse_cposg_2008.rds")
df_tjsp_2009 <- readRDS(file="list_parse_cposg_2009.rds")
df_tjsp_2010 <- readRDS(file="list_parse_cposg_2010.rds")
df_tjsp_2011 <- readRDS(file="list_parse_cposg_2011.rds")
df_tjsp_2012 <- readRDS(file="list_parse_cposg_2012.rds")
df_tjsp_2013 <- readRDS(file="list_parse_cposg_2013.rds")
df_tjsp_2014 <- readRDS(file="list_parse_cposg_2014.rds")
df_tjsp_2015 <- readRDS(file="list_parse_cposg_2015.rds")
df_tjsp_2016 <- readRDS(file="list_parse_cposg_2016.rds")
df_tjsp_2017 <- readRDS(file="list_parse_cposg_2017.rds")

# appendar os dados
df_tjsp_TOTAL <- do.call("rbind",
                         list(df_tjsp_2007,df_tjsp_2008,
                              df_tjsp_2009,df_tjsp_2010,
                              df_tjsp_2011,df_tjsp_2012,
                              df_tjsp_2013,df_tjsp_2014,
                              df_tjsp_2015,df_tjsp_2016,
                              df_tjsp_2017))


#### EDITAR BASE FINAL ####

# extrair dados do sistema de consultas sobre processos judiciais
df_tjsp_TOTAL <- df_tjsp_TOTAL[3:31]

df_tjsp_TOTAL$id_lawsuit <- clean_id(df_tjsp_TOTAL$id_lawsuit)
df_tjsp_TOTAL$summary_clean <- rm_accent(df_tjsp_TOTAL$summary)


#### SALVAR O ARQUIVO FINAL ####

saveRDS(df_tjsp_TOTAL, file="df_tjsp_TOTAL.rds")


