## code to prepare `shortnames_g|rcm` dataset goes here

shortnames_gcm <- setNames(
  c("CNRM-CM5", "EC-EARTH", "IPSL-CM5A-LR", "IPSL-CM5A-MR", "HadGEM2-ES",
    "MPI-ESM-LR", "NorESM1-M", "GFDL-ESM2G"),
  c("CNRM-CERFACS-CNRM-CM5", "ICHEC-EC-EARTH", "IPSL-IPSL-CM5A-LR",
    "IPSL-IPSL-CM5A-MR", "MOHC-HadGEM2-ES", "MPI-M-MPI-ESM-LR",
    "NCC-NorESM1-M", "NOAA-GFDL-GFDL-ESM2G")
)

usethis::use_data(shortnames_gcm, overwrite = TRUE)




shortnames_rcm <- setNames(
  c("CCLM4-8-17", "COSMO-crCLIM-v1-1", "ALADIN63", "HIRHAM5", "REMO2015", "RegCM4-6",
    "WRF381P", "RACMO22E", "HadREM3-GA7-05", "REMO2009", "ALARO-0", "RCA4"),
  c("CLMcom-CCLM4-8-17", "CLMcom-ETH-COSMO-crCLIM-v1-1", "CNRM-ALADIN63",
    "DMI-HIRHAM5", "GERICS-REMO2015", "ICTP-RegCM4-6", "IPSL-WRF381P",
    "KNMI-RACMO22E", "MOHC-HadREM3-GA7-05", "MPI-CSC-REMO2009",
    "RMIB-UGent-ALARO-0", "SMHI-RCA4")
)

usethis::use_data(shortnames_rcm, overwrite = TRUE)
