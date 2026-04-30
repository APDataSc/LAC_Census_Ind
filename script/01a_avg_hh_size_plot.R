
# ============================================================================
# IPUMS International - Censuses
# Purpose: Plot suggested for variables from IPUMS International - Censuses
# Variable: Average household size
# ============================================================================

# 1. Environment setup ----

rm(list=ls())
gc()

source("R/01_packages.R")


# 2. Downloading data ----
data <- read.csv(paste0("output/chapter_1/", 
                        "avg_hh_size",
                        ".csv"))


# 3. Plot option ----

# Trends in average household size across countries.

ggplot(avg_hh_size) +
  geom_line(aes(x=YEAR, y=avg_hh_size, color=COUNTRYCODE),
            linewidth=0.7) +
  labs(x="Year", y="Average household size (persons)", color="") +
  theme_minimal() +
  theme(axis.text = element_text(size=9),
        axis.title = element_text(size=10),
        legend.text = element_text(size=10))


## Saving plot ----
ggsave(filename=paste0("output/chapter_1/", "avg_hh_size_option1.png"), 
       plot=last_plot(), 
       units="cm", width=16, height=10, dpi=400)
