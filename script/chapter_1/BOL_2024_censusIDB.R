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

"Bolivia 2024"

bol24 <- fread("data/BOL/BOL_2024/Persona_CPV-2024.csv")
names(bol24)
table(bol24$p31_afiliado)
table(bol24$idep)
table(bol24$iprov)


bol24[ , region_c := factor(idep, levels = 1:9, labels = c("Chuqisaca", 
                            "La paz", "Cochabamba", "Oruro", "Potosá", 
                            "Tarija", "Santa Cruz", "Beni", "Pando"))]
table(bol24$region_c)

#### Average size of households ####

# Ver los valores únicos de parentesco
unique(bol24$p24_parentes)

# Identificar jefes de hogar (asumiendo que 1 = jefe/a)
bol24$es_jefe <- ifelse(bol24$p24_parentes == 1, 1, 0)

# Suponiendo que tienes una variable llamada 'id_hogar'
# Si no, crea una combinación única:
bol24$id_hogar <- paste(bol24$iprov, bol24$imun, bol24$i00, sep = "_")

# Número total de hogares (hogares únicos)
n_hogares <- length(unique(bol24$id_hogar))

# Población total (número de filas/personas)
n_personas <- nrow(bol24)

# Tamaño promedio del hogar (país)
avg_household_size <- n_personas / n_hogares
print(avg_household_size)

# El tamaño promedio del hogar en Bolivia según el Censo 2024 es de 3.1 
# personas por hogar, calculado a partir de 11.37 millones de personas y 
# 3.65 millones de hogares.

## Versión 2: Calcular por departamento (usando dep_res_cod o dep_nac_cod):##

tamano_hogar <- bol24 %>%
  group_by(region_c) %>%   # o la variable geográfica que uses
  summarise(
    total_personas = n(),
    total_hogares = n_distinct(id_hogar),
    tamano_promedio = total_personas / total_hogares
  )

print(tamano_hogar)

## Paso 4: Verificación de consistencia ##

# Verificar que cada hogar tenga exactamente un jefe
jefes_por_hogar <- bol24 %>%
  group_by(id_hogar) %>%
  summarise(num_jefes = sum(es_jefe, na.rm = TRUE))

# Hogares con problemas
problemas <- jefes_por_hogar %>% filter(num_jefes != 1)
print(nrow(problemas))  # Si es > 0, revisar
