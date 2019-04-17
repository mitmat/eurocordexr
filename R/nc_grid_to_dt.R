#' Convert a netcdf array to long format as data.table
#'
#' Extracts a variable from netcdf, and returns a
#' \code{\link[data.table]{data.table}} with date, values, and optionally: cell
#' indices, coordinates.
#'
#' @param filename Complete path to .nc file.
#' @param variable Name of the variable to extract from \code{filename}
#'   (character).
#' @param add_icell Boolean, if \code{TRUE}, adds a column with cell indices.
#' @param add_xy Boolean, if \code{TRUE}, adds columns with x and y coordinates.
#' @param verbose Boolean, if \code{TRUE}, prints more information.
#'
#' @return A \code{\link[data.table]{data.table}} with columns: \itemize{\item
#'   date: Date \item variable: Values, column is renamed to input
#'   \code{variable} \item (optional) icell: Cell index \item (optional) x,y:
#'   Coordinates of netcdf dimensions, will be renamed to dimension names found
#'   in array named after input \code{variable}}
#'
#'
#' @section Warning: Netcdf files can be huge, so loading everything in memory
#'   can rapidly crash your R session. Think first about subsetting or
#'   aggregating (e.g. using CDO:
#'   \url{https://code.mpimet.mpg.de/projects/cdo/}).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' dat <- nc_grid_to_dt(filename = "tas_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_SMHI-RCA4_v1_day_19700101-19701231.nc",
#'                      variable = "tas",
#'                      add_icell = T,
#'                      add_xy = F)
#' }
nc_grid_to_dt <- function(filename,
                          variable,
                          add_icell = T,
                          add_xy = F,
                          verbose = F){

  ncobj <- nc_open(filename,
                   readunlim = F)

  if(verbose) cat("Succesfully opened file:", filename, "\n")

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



