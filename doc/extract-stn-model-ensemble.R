## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(eurocordexr)

path_eurocordex <- "/mnt/CEPH_BASEDATA/METEO/SCENARIO"
dat_inventory <- get_inventory(path_eurocordex)
dat_inventory_files <- get_inventory(path_eurocordex, add_files = T)

dat_inventory

## ------------------------------------------------------------------------
dat_inventory_sub <- dat_inventory[variable %in% c("tas", "pr") & 
                                     timefreq == "day" & 
                                     institute_rcm == "SMHI-RCA4" &
                                     experiment %in% c("historical", "rcp45", "rcp85")]

## ------------------------------------------------------------------------
dat_compare <- compare_variables_in_inventory(dat_inventory_sub, c("tas", "pr"))
dat_compare

