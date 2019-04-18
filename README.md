A package to make life easier working with daily netcdf files from the 
EURO-CORDEX RCMs. Relies on data.table to do the heavy data lifting.

Main components:

  - extract single grid cells (e.g. for stations) from rotated pole grid
  - extract the whole array of a variable in long format
  - can deal with non-standard calendars (360, noleap) and interpolate them
  
Since not public (yet), needs authentification to install:

    library(devtools)
    library(git2r)
    library(getPass)

    username <- "Your GITLAB username" # typically EURAC email

    devtools::install_git("https://gitlab.inf.unibz.it/REMSEN/eurocordexr", 
                          credentials = git2r::cred_user_pass(username, getPass::getPass()))


Requires the following packages (which should be installed automatically with above):

    library(data.table)
    library(lubridate)
    library(magrittr)
    library(ncdf4)
    library(ncdf4.helpers)