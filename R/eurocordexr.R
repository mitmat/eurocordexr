#' eurocordexr: Makes it easier to work with daily netCDF from EURO-CORDEX RCMs
#'
#' Daily netCDF data from e.g. regional climate models (RCM) are not trivial
#' to work with. This package, which relies on data.table, makes it easier
#' to deal with large data from RCMs, such as from EURO-CORDEX. It has functions
#' to extract single grid cells from rotated pole netCDF's as well as the whole
#' array in long format. Can handle non-standard calendars (360, noleap).
#' Potentially applicable to all CF-conform netCDFs.
#'
#' @section Important functions:
#'
#' \code{\link{rotpole_nc_point_to_dt}}
#'
#' \code{\link{nc_grid_to_dt}}
#'
#' \code{\link{get_inventory}}
#'
#'
#' @docType package
#' @name eurocordexr
NULL
