
# ============================================================================
# IPUMS International - Censuses
# Purpose: Variables from IPUMS International Data 
# Variable: Average household size
# ============================================================================

# 1. Environment setup ----

rm(list=ls())
gc()

source("R/01_packages.R")

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



# Saving variable ---- 

write.csv(avg_hh_size, file=paste0("output/chapter_1/", 
                                   "avg_hh_size", 
                                   ".csv"))

