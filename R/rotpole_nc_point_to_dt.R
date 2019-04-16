library(ncdf4)
library(ncdf4.helpers)
library(data.table)
library(magrittr)

# reguired:
# - daily netcdf

# todo:
# - interpolation of non-standard calendars (simply take previous day?)
# - convert units? (maybe optional, have a look at the udunits package!)

rotpole_nc_point_to_dt <- function(filename,
                                   variable,
                                   point_lon,
                                   point_lat,
                                   verbose = F){
  
  ncobj <- nc_open(filename,
                   readunlim = F)
  
  grid_lat <- ncvar_get(ncobj, "lat")
  grid_lon <- ncvar_get(ncobj, "lon")
  
  grid_squared_dist <- (grid_lat - point_lat)^2 + (grid_lon - point_lon)^2
  
  # indices of [lon, lat]
  cell_xy <- arrayInd(which.min(grid_squared_dist), 
                      dim(grid_squared_dist))
  
  if(verbose){
    # actual cell coordinates
    cat("Point longitude = ", point_lon, " ## Closest grid cell = ", grid_lon[cell_xy], "\n")
    cat("Point latitude = ", point_lat, " ## Closest grid cell = ", grid_lat[cell_xy], "\n")
    
    # euclidean distance of stn to grid cell midpoint [degrees]
    cat("Euclidean distance in degrees = ", sqrt(grid_squared_dist[cell_xy]), "\n")
  }
  
  
  values <- nc.get.var.subset.by.axes(ncobj,
                                      variable,
                                      list(X = cell_xy[1], Y = cell_xy[2]))
  
  # extract time dimension in IDate format (assuming daily data)
  nc.get.time.series(ncobj,
                     variable) %>% 
    as.POSIXct %>% 
    as.IDate -> dates
  
  nc_close(ncobj)
  
  dat <- data.table(date = dates, 
                    value = values)
  setnames(dat, "value", variable)
  
  return(dat)
}



