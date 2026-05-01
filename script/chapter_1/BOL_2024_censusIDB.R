#**************************************************************************************#
#**************************************************************************************#
#
#                           Harmonization of census microdata 
#                            Latin America and the Caribbean
#                                        2026
#                         Inter-American Development Bank (IDB)
#        Unit 2: Estimation and Projection of fertility levels and structure
#
#   Created by:               @vicmgg 
#                             Center for Demographic, Urban and Environmental Studies
#                             El Colegio de México  
#   Creation date:            02/03/2026
#   Last update:              31/03/2026
#   Contact information:      vmgarcia@colmex.mx
#
#   Country & year:           Bolivia 2024       
#
#**************************************************************************************#
#**************************************************************************************#

rm(list = ls())

library(redatam)
library(redatamx)
library(dplyr)
library(data.table)
library(srvyr)
library(survey)
library(googledrive)

path <- "/Users/apdatasc/Library/CloudStorage/OneDrive-ElColegiodeMéxicoA.C/Consultancy/BID 2026/LAC_Census_HMicrodata/"


"Bolivia 2024"

bol24_v <- fread(paste0(path, "data/BOL/BOL_2024/Vivienda_CPV-2024.csv"))
names(bol24_v)

bol24_v[ , region_c := factor(idep, levels = 1:9, labels = c("Chuqisaca", 
                            "La paz", "Cochabamba", "Oruro", "Potosá", 
                            "Tarija", "Santa Cruz", "Beni", "Pando"))]
table(bol24_v$region_c)

#### Average size of households ####

bol24_v[v02_condocup<=1 & v01_tipoviv<=6, mean(tot_pers)]
