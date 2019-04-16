

# reguired:
# - daily netcdf

# todo:
# - convert units? (maybe optional, have a look at the udunits package!)

rotpole_nc_point_to_dt <- function(filename,
                                   variable,
                                   point_lon,
                                   point_lat,
                                   interpolate_to_standard_calendar = F,
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


  times <- nc.get.time.series(ncobj, variable)

  # modification for non-standard calendars
  if(! attr(times, "cal") %in% c("gregorian", "proleptic_gregorian")){

    if(verbose) cat("Non-standard calendar found:", attr(times, "cal"))

    if(interpolate_to_standard_calendar){

      dtx <- map_non_standard_calendar(times)

      dates <- dtx$dates_full
      values <- values[dtx$idx_pcict]


    } else {

      dates <- trunc(times, "day")

    }

  } else {
    # standard calendar: extract time dimension in IDate format (assuming daily data)
    times %>%
      PCICt::as.POSIXct.PCICt() %>%
      as.IDate -> dates
  }


  nc_close(ncobj)

  dat <- data.table(date = dates,
                    value = values)
  setnames(dat, "value", variable)

  return(dat)
}



