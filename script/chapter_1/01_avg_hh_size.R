
# ============================================================================#
# IPUMS International - Censuses
# Purpose: Variables from IPUMS International Data 
# Variable: Average household size
# ============================================================================#

# 1. Environment setup ----

rm(list=ls())
gc()

source("script/01_packages.R")

options(scipen=999)


# 2. Downloading data ----
load("data/ipums_microdata.RData")


# 3. Organizing data ----

# Reducing data size to improve memory capacity
data <- data %>%
  select(c(SAMPLE, SERIAL, PERSONS, 
           COUNTRY, YEAR, HHWT, PERWT, RELATE))
gc()

# Creating auxiliary objects
# varinfo <- ddi$var_info

countries <- ddi[["var_info"]][["val_labels"]][[1]]
countries <- countries %>% 
  filter(val %in% unique(data$COUNTRY))

data$COUNTRY <- as.integer(data$COUNTRY)
data <- left_join(data, countries, by=c("COUNTRY"="val")) 

data <- data %>% 
  rename(country=lbl, 
         IPUMS_CountryCode=COUNTRY)

data$countrycode <- countrycode(data$country, "country.name", "iso3c")

data <- data[, c("countrycode", "country", 
                 setdiff(names(data), c("countrycode", "country")))]

data$IPUMS_CountryCode <- NULL
names(data) <- toupper(names(data))
rm(ddi, countries)
gc() 

# Removing Suriname 2004 and Dominican Republic	1970 
# (persons not organized into households.)
data <- data[!(data$COUNTRYCODE=="DOM" & data$YEAR==1970), ]
data <- data[!(data$COUNTRYCODE=="SUR" & data$YEAR==2004), ]
gc()


# 4. Variable -----

## avg_hh_size ----

### IPUMS ----
avg_hh_size_ipums <- data %>%
  filter(RELATE==1) %>% 
  group_by(COUNTRY, COUNTRYCODE, YEAR) %>%
  summarise(avg_hh_size = weighted.mean(PERSONS, w = HHWT, na.rm = T),
            .groups = "drop")

save(avg_hh_size_ipums, file="data/avg_hh_size_ipums.RData")


### Censuses ----
path <- "/Users/apdatasc/Library/CloudStorage/OneDrive-ElColegiodeMéxicoA.C/Consultancy/BID 2026/LAC_Census_HMicrodata/"


#### *Argentina 2022 ----

arg22_h <- redatam_open(paste0(path, "data/ARG/ARG_2022/Base_PO_A_IG/cpv2022.rxdb"))
#comp <- redatam_query(arg22_h, "freq HOGAR.TOTPOBH BY VIVIENDA.TIPOVIVG BY VIVIENDA.V02")

arg22 <- data.table(COUNTRY="Argentina", COUNTRYCODE="ARG", YEAR=2022, 
                    avg_hh_size=as.numeric(redatam_query(arg22_h, "AVERAGE HOGAR.TOTPOBH")))
redatam_close(arg22_h)

load("output/chapter_1/avg_hh_size_ipums.RData")

avg_hh_size <- rbind(avg_hh_size_ipums, arg22)

write.csv(avg_hh_size, file=paste0("output/chapter_1/", 
                                   "avg_hh_size", 
                                   ".csv"), row.names = F)


#### *Bolivia 2024 ----

bol24_v <- fread(paste0(path, "data/BOL/BOL_2024/Vivienda_CPV-2024.csv"))

#### Average size of households 

bol24 <- data.table(COUNTRY="Bolivia", COUNTRYCODE="BOL", YEAR=2024, 
                    avg_hh_size=bol24_v[v02_condocup<=1 & v01_tipoviv<=6, mean(tot_pers)])
#https://cpv2024.ine.gob.bo/index.php/tabulados-sobre-la-tematica-pobreza/

avg_hh_size <- fread("output/chapter_1/avg_hh_size.csv")
avg_hh_size <- rbind(avg_hh_size, bol24)

write.csv(avg_hh_size, file=paste0("output/chapter_1/", 
                                   "avg_hh_size", 
                                   ".csv"), row.names = F)


#### *Chile 2024 ----


#### Average size of households 

chl24 <- data.table(COUNTRY="Chile", COUNTRYCODE="CHL", YEAR=2024, 
                    avg_hh_size=2.8)
#https://censo2024.ine.gob.cl/resultados-dashboard/
  
avg_hh_size <- fread("output/chapter_1/avg_hh_size.csv")
avg_hh_size <- rbind(avg_hh_size, chl24)

write.csv(avg_hh_size, file=paste0("output/chapter_1/", 
                                   "avg_hh_size", 
                                   ".csv"), row.names = F)


#### *Ecuador 2022 ----

ecu22_h <- fread(paste0(path, "/data/ECU/ECU_2022/1.1 BDD_CPV_2022_CANTON_CSV/CPV_2022_Hogar_Canton.csv"))

#### Average size of households 

ecu22 <- data.table(COUNTRY="Ecuador", COUNTRYCODE="ECU", YEAR=2022, 
                    avg_hh_size=ecu22_h[INH>=1, mean(H1303, na.rm=T)])
#https://www.censoecuador.gob.ec/resultados-censo/#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3DeyJpZCI6Ijk1MjEiLCJ0b2dnbGUiOmZhbHNlfQ%3D%3D

avg_hh_size <- fread("output/chapter_1/avg_hh_size.csv")
avg_hh_size <- rbind(avg_hh_size, ecu22)


# Saving variable ---- 
write.csv(avg_hh_size, file=paste0("output/chapter_1/", 
                                   "avg_hh_size", 
                                   ".csv"), row.names = F)
