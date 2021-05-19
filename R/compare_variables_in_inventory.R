
#' Compare an EURO-CORDEX inventory for different variables
#'
#' Casts the result from \code{\link{get_inventory}} for different variables in
#' order to compare completeness of the inventory. Adds columns for checking
#' equality of years and number of files.
#'
#' @param data_inventory A data.table as resulting from
#'   \code{\link{get_inventory}}.
#' @param vars Character vector of variables to compare.
#'
#' @return The casted data.table with boolean columns if all years and number of
#'   files are equal for all variables.
#'
#' @export
#'
#' @import data.table
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#'
#' path <- "/mnt/CEPH_BASEDATA/METEO/SCENARIO"
#' dat <- get_inventory(path)
#' dat_compare <- compare_variables_in_inventory(dat, c("tas","rsds","pr"))
#' }
compare_variables_in_inventory <- function(data_inventory, vars){

  dat <- copy(data_inventory)

  if("list_files" %in% names(dat)) {
    dat[, list_files := NULL]
  }

  dat[variable %in% vars] %>%
    dcast(... ~ variable, value.var = c("nn_files", "years_total")) -> dat_compare

  dat_compare[,
              all_nn_files_equal := apply(as.matrix(.SD), 1, function(x) length(unique(x)) == 1),
              .SDcols = patterns("nn_files")]
  dat_compare[,
              all_years_total_equal := apply(as.matrix(.SD), 1, function(x) length(unique(x)) == 1),
              .SDcols = patterns("years_total")]

  dat_compare

}
