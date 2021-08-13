#' Convert a netcdf array to long format as data.table
#'
#' Extracts a variable from netcdf, and returns a
#' \code{\link[data.table]{data.table}} with cell index, date, values, and
#' optionally: coordinates.
#'
#' Coordinates are usually not put in the result, because it saves space. It is
#' recommended to merge them after the final operations. The unique cell index
#' is more efficient. However, if you plan to merge to data extracted with the
#' raster package (assuming the same grid), then cell indices might differ. Set
#' \code{icell_raster_pkg} to \code{TRUE}, to have the same cell indices. Note
#' that raster and ncdf4 have different concepts of coordinates (cell corner vs.
#' cell center), so merging based on coordinates can produce arbitrary results
#' (besides rounding issues).
#'
#'
#' @param filename Complete path to .nc file.
#' @param variable Name of the variable to extract from \code{filename}
#'   (character).
#' @param icell_raster_pkg Boolean, if \code{TRUE}, cell indices will be ordered
#'   as if you were extracting the data with the raster package.
#' @param add_xy Boolean, if \code{TRUE}, adds columns with x and y coordinates.
#' @param interpolate_to_standard_calendar Boolean, if \code{TRUE} will use
#'   \code{\link{map_non_standard_calendar}} to interpolate values to a standard
#'   calendar.
#' @param verbose Boolean, if \code{TRUE}, prints more information.
#'
#' @return A \code{\link[data.table]{data.table}} with columns: \itemize{\item
#'   icell: Cell index \item date: Date of class
#'   \code{\link{Date}}, unless the .nc file has a non-standard
#'   calendar (360, noleap) and \code{interpolate_to_standard_calendar} is set
#'   to \code{FALSE}, in which it will be character. \item variable: Values,
#'   column is renamed to input \code{variable} \item (optional) x,y:
#'   Coordinates of netcdf dimensions, will be renamed to dimension names found
#'   in array named after input \code{variable}}
#'
#'
#' @section Warning: Netcdf files can be huge, so loading everything in memory
#'   can rapidly crash your R session. Think first about subsetting or
#'   aggregating (e.g. using CDO:
#'   \url{https://code.mpimet.mpg.de/projects/cdo/}).
#'
#' @seealso The raster package can also open netcdf files and create data.frames
#'   with \code{raster::as.data.frame}. But, it does not handle
#'   non-standard calendars, and returns a data.frame, which is slower than
#'   data.table.
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
#' # example data from EURO-CORDEX (cropped for size)
#' fn1 <- system.file("extdata", "test1.nc", package = "eurocordexr")
#' dat <- nc_grid_to_dt(
#'   filename = fn1,
#'   variable = "tasmin"
#' )
#' str(dat)
nc_grid_to_dt <- function(filename,
                          variable,
                          icell_raster_pkg = TRUE,
                          add_xy = FALSE,
                          interpolate_to_standard_calendar = FALSE,
                          verbose = FALSE){

  ncobj <- nc_open(filename,
                   readunlim = FALSE)

  if(verbose) cat("Succesfully opened file:", filename, "\n")

  dimnames <- nc.get.dim.names(ncobj, variable)

  dim_x <- ncvar_get(ncobj, dimnames[1])
  dim_y <- ncvar_get(ncobj, dimnames[2])

  times <- nc.get.time.series(ncobj, variable)

  if(all(is.na(times))){

    if(verbose) cat("No time information found in nc file.\n")
    dates <- NA

  } else if(! attr(times, "cal") %in% c("gregorian", "proleptic_gregorian")){

    if(verbose) cat("Non-standard calendar found:", attr(times, "cal"), "\n")

    dates <- as.character(trunc(times, "day"))

  } else {

    times %>%
      PCICt::as.POSIXct.PCICt() %>%
      as.Date -> dates
  }

  nx <- length(dim_x)
  ny <- length(dim_y)
  ndates <- length(dates)

  dat <- data.table(icell =  rep(1:(nx*ny), ndates),
                    date = rep(dates, each = nx * ny),
                    value = as.vector(ncvar_get(ncobj, variable)))

  if(icell_raster_pkg){
    # raster package orders cells differently (y inverse)
    l_icell_split_y <- split(1:(nx*ny), rep(1:ny, each = nx))
    dat[, icell := rep(unlist(rev(l_icell_split_y)), ndates)]
  }


  if(add_xy){
    dat[, x := rep(dim_x, ny * ndates)]
    dat[, y :=  rep(dim_y, each = nx) %>% rep(ndates)]
    setnames(dat, c("x", "y"), dimnames[1:2])
  }

  if(!all(is.na(times)) &&
     interpolate_to_standard_calendar &&
     ! attr(times, "cal") %in% c("gregorian", "proleptic_gregorian")){

    if(verbose) cat("Interpolating to standard calendar.\n")

    bycols <- "icell"
    if(add_xy) bycols <- c(bycols, dimnames[1:2])

    dtx <- map_non_standard_calendar(times)

    dat <- dat[,
                .(date = dtx$dates_full, value = value[dtx$idx_pcict]),
                by = bycols]

  }


  setnames(dat, "value", variable)

  nc_close(ncobj)
  return(dat)
}



