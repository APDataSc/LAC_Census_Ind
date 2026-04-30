

# ============================================================================
# IPUMS International - Censuses
# Packages
# Purpose: To install and load all packages.
# ============================================================================


# Packages to be loaded

packages <- c(
  "ipumsr",
  "dplyr",
  "ggplot2",
  "countrycode",
  "haven",
  "tidyr",
  "data.table"
)


for (package in packages) {
  if (!requireNamespace(package, quietly=T)) {
    install.packages(package)
  } else {
    library(package, character.only=T)
  }
}

rm(package, packages)

message("\nPackages loaded.")
