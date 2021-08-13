#' Extract time series of a single grid cell of a rot-pole daily netcdf to
#' data.table
#'
#' Creates a \code{\link[data.table]{data.table}} from a rotated pole netcdf (as
#' usually found in RCMs), which includes values and date. Useful for extracting
#' e.g. the series for a station. Requires that dimension variables in netcdf
#' file contain rlon and rlat, and that it contains daily data.
#'
#' Calculates the euclidean distance, and takes the grid cell with minimal
#' distance to \code{point_lon} and \code{point_lat}. Requires that the .nc file
#' contains variables lon[rlon, rlat] and lat[rlon, rlat].
#'
#' @param filename Complete path to .nc file.
#' @param variable Name of the variable to extract from \code{filename}
#'   (character).
#' @param point_lon Numeric longitude of the point to extract (decimal degrees).
#' @param point_lat Numeric latitude of the point to extract (decimal degrees).
#' @param interpolate_to_standard_calendar Boolean, if \code{TRUE} will use
#'   \code{\link{map_non_standard_calendar}} to interpolate values to a standard
#'   calendar.
#' @param verbose Boolean, if \code{TRUE}, will print more information.
#' @param add_grid_coord Boolean, if \code{TRUE}, will add columns to the result
#'   which give the longitude and latitude of the underlying grid.
#'
#' @return A \code{\link[data.table]{data.table}} with two columns: the dates in
#'   date, and the values in a variable named after input \code{variable}. The
#'   date column is of class \code{\link{Date}}, unless the .nc
#'   file has a non-standard calendar (360, noleap) and
#'   \code{interpolate_to_standard_calendar} is set to \code{FALSE}, in which it
#'   will be character. If \code{add_grid_coord} is set to \code{TRUE}, then
#'   two more columns named grid_lon and grid_lat.
#'
#' @export
#'
#' @import data.table
#' @importFrom magrittr %>%
#' @import PCICt
#' @import ncdf4
#' @import ncdf4.helpers
#'
#' @examples
#' \dontrun{
#' # data are from EURO-CORDEX
#' # standard calendar
#' dt1 <- rotpole_nc_point_to_dt(
#'   filename =
#'     "tas_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_SMHI-RCA4_v1_day_19700101-19701231.nc",
#'   variable = "tas",
#'   point_lon = 11.31,
#'   point_lat = 46.5,
#'   verbose = TRUE
#' )
#'
#' # non-standard calendar (360)
#' dt2 <- rotpole_nc_point_to_dt(
#'   filename =
#'     "tas_EUR-11_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_day_19491201-19501230.nc",
#'   variable = "tas",
#'   point_lon = 11.31,
#'   point_lat = 46.5,
#'   interpolate_to_standard_calendar = TRUE,
#'   verbose = TRUE
#' )
#' }
rotpole_nc_point_to_dt <- function(filename,
                                   variable,
                                   point_lon,
                                   point_lat,
                                   interpolate_to_standard_calendar = FALSE,
                                   verbose = FALSE,
                                   add_grid_coord = FALSE){

  ncobj <- nc_open(filename,
                   readunlim = FALSE)

  if(verbose) cat("Succesfully opened file:", filename, "\n")

  grid_lon <- ncvar_get(ncobj, "lon")
  grid_lat <- ncvar_get(ncobj, "lat")

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


  values <- as.vector(nc.get.var.subset.by.axes(ncobj,
                                                variable,
                                                list(X = cell_xy[1], Y = cell_xy[2])))


  times <- nc.get.time.series(ncobj, variable)

  if(all(is.na(times))){

    if(verbose) cat("No time information found in nc file.\n")
    dates <- NA

  } else if(! attr(times, "cal") %in% c("gregorian", "proleptic_gregorian")){

    # modification for non-standard calendars
    if(verbose) cat("Non-standard calendar found:", attr(times, "cal"), "\n")

    if(interpolate_to_standard_calendar){

      if(verbose) cat("Interpolating to standard calendar.\n")

      dtx <- map_non_standard_calendar(times)

      dates <- dtx$dates_full
      values <- values[dtx$idx_pcict]


    } else {

      dates <- as.character(trunc(times, "day"))

    }

  } else {
    # standard calendar: extract time dimension in IDate format (assuming daily data)
    times %>%
      PCICt::as.POSIXct.PCICt() %>%
      as.Date -> dates
  }


  nc_close(ncobj)

  dat <- data.table(date = dates,
                    value = values)
  setnames(dat, "value", variable)

  if(add_grid_coord){
    dat[, ":="(grid_lon = grid_lon[cell_xy],
               grid_lat = grid_lat[cell_xy])]
  }


  return(dat)
}



