## ----installation, eval=FALSE--------------------------------------------
## install.packages("devtools")
## devtools::install_github("tlverse/tlverse")


## ----load_washb_data_intro, message=FALSE, warning=FALSE-----------------
library(here)
library(tidyverse)

# read in data
dat <- read_csv(here("data", "washb_data.csv"))
dat


## ----skim_washb_data, message=FALSE, warning=FALSE-----------------------
library(skimr)
skim(dat)

