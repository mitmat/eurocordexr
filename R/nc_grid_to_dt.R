library(ncdf4)
library(ncdf4.helpers)
library(data.table)
library(magrittr)

# reguired:
# - daily netcdf
# - 3d (x, y, time)

# todo:
# - interpolation of non-standard calendars (simply take previous day?)
# - check if ordering of icell is the same as with raster()

nc_grid_to_dt <- function(filename,
                          variable,
                          add_icell = T,
                          add_xy = F,
                          verbose = F){
  
  ncobj <- nc_open(filename,
                   readunlim = F)
  
  dimnames <- nc.get.dim.names(ncobj, variable)
  
  dim_x <- ncvar_get(ncobj, dimnames[1])
  dim_y <- ncvar_get(ncobj, dimnames[2])
  
  # extract time dimension in IDate format (assuming daily data)
  nc.get.time.series(ncobj,
                     variable) %>% 
    as.POSIXct %>% 
    as.IDate -> dates
  
  nx <- length(dim_x)
  ny <- length(dim_y)
  ndates <- length(dates)
  
  dat <- data.table(date = rep(dates, each = nx * ny),
                    value = as.vector(ncvar_get(ncobj, variable)))
  setnames(dat, "value", variable)
  
  if(add_icell){
    dat[, icell :=  rep(1:(nx*ny), ndates)]
  }
  
  if(add_xy){
    dat[, x := rep(dim_x, ny * ndates)]
    dat[, y :=  rep(dim_y, each = nx) %>% rep(ndates)]
    setnames(dat, c("x", "y"), dimnames[1:2])
  }
  
  nc_close(ncobj)
  return(dat)
}



