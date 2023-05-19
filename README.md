## Overview


A package to make life easier working with daily netcdf files from the EURO-CORDEX RCMs. Relies on `data.table` to do the heavy data lifting.

Main components:

  - extract single grid cells (e.g. for stations) from rotated pole grid: `rotpole_nc_point_to_dt()`
  - extract the whole array of a variable in long format: `nc_grid_to_dt()`
  - can deal with non-standard calendars (360, noleap) and interpolate them
  - get and check list of EURO-CORDEX .nc files: `get_inventory()`

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
# or from github
devtools::install_github("mitmat/eurocordexr")
```

Requires the following packages (which should be installed automatically with above):

```{r}
library(data.table)
library(lubridate)
library(magrittr)
library(ncdf4)
library(ncdf4.helpers)
```
    

For the netCDF packages, depending on your system, additional libraries might be needed.

## Other
    
Some documentation can be found in the `doc/` subfolder. To view the HTML files you may need to download the files (and not view them in github).

## Contribution and help

Any ideas and suggestions are welcome! Feel free to contact me or open issues in github.




