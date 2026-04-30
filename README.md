# Indicators from the LAC censuses

## Latin America and the Caribbean

### Inter-American Development Bank (IDB)

## Table of Contents

-   [Introduction](#introduction)
-   [Workflow](#workflow)
-   [Prerequisites](#prerequisites)
-   [Important links](#important-links) <br><br>

------------------------------------------------------------------------

## Introduction

The `LAC_Census_HMicrodata` repository contains the transformation scripts for the original censuses, providing census information that is comparable over time and across countries. The variables in these databases are built under a common approach and structure (where possible), with standardized names, definitions and disaggregations, and stored in a separate folder for each country.

------------------------------------------------------------------------

## Workflow

The repository that has folders, referring to the countries of the region, are named with the acronym of the country (ISO 3166-1 alpha-3).


The raw `data` have been taken from two main sources: 1) national statistical offices of the region and 2) REDATAM microdata from CELADE-ECLAC. It was found in multiple formats (`*.csv`, `*.dicx`, `*.rxdb`, `*.sav`, `*.dta`, `*.sas`, `*.dbf`, among others).

Each folder in `script`contains the harmonization scripts available for the country in question. The scripts are written in R (files with the \*.R extension), and their names are constructed as follows: COUNTRY_year_censusIDB.R. The number of scripts within a folder depends on the number of Population and Housing Censuses that have been harmonized for that country.

-   `data` : raw input data, 
census forms, data dictionaries & user manuals
-   `script` : microdata homologation code
-   `output` : standardized microdata
-   `graphs` : graphs for the reports


In all cases, it was verified that the aggregated figures of the microdata are equal to those published in the national statistical offices.

```         
{LAC_Census_HMicrodata}/
  └── README.html
  
  └── {data}/
    ── {ARG}/
      ── {ARG_2001}
      ── {ARG_2010}
      ── {ARG_2022}
    ── {BOL}/
      ── {BOL_1992}
      ── {BOL_2001}
      ── {BOL_2012}
      ── {BOL_2024}
      .
      ...
    ── {URY}/
      ── {URY_2011}
      ── {URY_2023}
    ── {VEN}/
      ── {VEN_2011}
      
  └── {script}/
    ── {ARG}/
      ── ARG_2001_censusIDB.R
      ── ARG_2010_censusIDB.R
      ── ARG_2022_censusIDB.R
    ── {BOL}/
      ── BOL_1992_censusIDB.R
      ── BOL_2001_censusIDB.R
      ── BOL_2012_censusIDB.R
      ── BOL_2024_censusIDB.R
      .
      ...
    ── {URY}/
      ── URY_2011_censusIDB.R
      ── URY_2023_censusIDB.R
    ── {VEN}/
      ── URY_2011_censusIDB.R
      
  └── {output}/
    ── {ARG}/
      ── ARG_2001_censusIDB.rds
      ── ARG_2010_censusIDB.rds
      ── ARG_2022_censusIDB.rds
    ── {BOL}/
      ── BOL_1992_censusIDB.rds
      ── BOL_2001_censusIDB.rds
      ── BOL_2012_censusIDB.rds
      ── BOL_2024_censusIDB.rds
      .
      ...
    ── {URY}/
      ── URY_2011_censusIDB.rds
      ── URY_2023_censusIDB.rds
    ── {VEN}/
      ── VEN_2011_censusIDB.rds
  
  └── {graphs}/
    ── {ARG}
    ── {BOL}
    ...
    ── {URY}
    ── {VEN}
```

------------------------------------------------------------------------

## Prerequisites

### Software Requirements

-   **R** (version 4.0 or higher recommended)
-   **RStudio** (R IDE; optional but recommended)

### R Packages

``` r
library(redatam)
library(redatamx)
library(dplyr)
library(data.table)
library(srvyr)
library(survey)
```

------------------------------------------------------------------------

## Important links

-   [ARGENTINA](https://www.indec.gob.ar/indec/web/Nivel4-Tema-2-41-165)
