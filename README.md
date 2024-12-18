<!-- badges: start -->
[![R-CMD-check](https://github.com/mitmat/eurocordexr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mitmat/eurocordexr/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/mitmat/eurocordexr/graph/badge.svg)](https://app.codecov.io/gh/mitmat/eurocordexr)
<!-- badges: end -->

## Overview


A package developped to make life easier working with daily netcdf files from the EURO-CORDEX RCMs. Relies on `data.table` to do the heavy data lifting.

Works with many CF-conform netCDF files, like from CMIP, and others, too!

Main components:

  - extract the whole array of a variable in long format, optionally subset by dates: `nc_grid_to_dt()`
  - can deal with non-standard calendars (360, noleap) and interpolate them
  - get and check list of EURO-CORDEX .nc files: `get_inventory()`, and CMIP5 (`get_inventory_cmip5()`)
  - extract single grid cells (e.g. for stations) from rotated pole grid: `rotpole_nc_point_to_dt()`
  - raw backbone to extract curvilinear netcdf array to long format: `nc_grid_to_dt_raw()`

Alternatives:

The [stars](https://CRAN.R-project.org/package=stars) and [terra](https://CRAN.R-project.org/package=terra) (previously raster) packages can be used similarly, although the functionality for rotated pole grids and non-standard calendars might be different.
 
## Installation

Get the CRAN version:

```{r}
# from CRAN
install.packages("eurocordexr")
```


Or get the latest (development) version from github:

```{r}
# from github
remotes::install_github("mitmat/eurocordexr")
```

Requires netCDF system libraries.

## Other
    
Some documentation can be found in the `doc/` subfolder. To view the HTML files you may need to download the files (and not view them in github).

## Contribution and help

Any ideas and suggestions are welcome! Feel free to contact me or open issues in github.




