A package to make life easier working with daily netcdf files from the 
EURO-CORDEX RCMs. Relies on `data.table` to do the heavy data lifting.

Main components:

  - extract single grid cells (e.g. for stations) from rotated pole grid
  - extract the whole array of a variable in long format
  - can deal with non-standard calendars (360, noleap) and interpolate them
  
To install, use `devtools`:

    devtools::install_github("mitmat/eurocordexr")


Requires the following packages (which should be installed automatically with above):

    library(data.table)
    library(lubridate)
    library(magrittr)
    library(ncdf4)
    library(ncdf4.helpers)
    
Some documentation can be found in the `doc/` subfolder. To view the HTML files you may need to download the files (and not view them in gitlab).    

