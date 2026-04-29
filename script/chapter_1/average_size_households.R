
# ============================================================================
# IPUMS International
# Purpose: Variables from IPUMS International Data 
# Variable: Average household size
# ============================================================================

# 1. Environment setup ----

rm(list=ls())
gc()

source("R/01_packages.R")


# 2. Downloading data ----
load("data/ipums_microdata.RData")


# 3. Organizing data ----

# Reducing data size to improve memory capacity
data <- data %>%
  select(c(SAMPLE, SERIAL, PERSONS, COUNTRY, YEAR, HHWT, PERWT, RELATE))
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


# 4. Average size of households ----
avg_hh_size <- data %>%
  filter(RELATE==1) %>% 
  group_by(COUNTRY, COUNTRYCODE, YEAR) %>%
  summarise(avg_hh_size = weighted.mean(PERSONS, w = HHWT, na.rm = T),
            .groups = "drop")


# 5. Plotting average ----

ggplot(avg_hh_size) +
  geom_line(aes(x = YEAR, y = avg_hh_size, color = COUNTRYCODE),
            linewidth = 0.8) +
  geom_point(aes(x = YEAR, y = avg_hh_size, color = COUNTRYCODE),
             size = 1.8) +
  labs(x = "Year", 
       y = "Average household size (persons)",
       color  = "Country") +
  theme_minimal() 

# Saving plot
ggsave(plot = plot_5yr_relative, 
       filename = "output/plot_01.jpeg",
       units="cm", 
       width=19, 
       height=15, 
       dpi=400)


# 6. Saving outputs ----
save(avg_household_size, 
     file="output/avg_household_size.RData")


# ============================================================================
# Version: 1.0
# Data: 2026-03-12
# ============================================================================
