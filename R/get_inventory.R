#' Get inventory from path containing EURO-CORDEX .nc files
#'
#' Returns a data.table with information by splitting the netcdf files into
#' their components (GCM, RCM, variable, experiment, ...) and aggregates over
#' years.
#'
#' @param path Path that will be searched recursively for .nc files.
#' @param add_files Boolean, if \code{TRUE}, will add a column containing lists
#'   of associated files with their full paths (useful e.g. for further
#'   processing).
#'
#' @return A data.table with the inventory information.
#'
#' @seealso \code{\link{compare_variables_in_inventory}} for further comparing the
#'   results, and \code{\link{check_inventory}} for performing some checks.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' path <- "/mnt/CEPH_BASEDATA/METEO/SCENARIO"
#' dat <- get_inventory(path)
#' print(dat)
#'
#' # the same, but with files (does not print nicely)
#' dat_file <- get_inventory(path, add_files = T)
#' print(dat_file)
#' }
get_inventory <- function(path,
                          add_files = F){

  all_files_fullpath <- list.files(path,
                                   pattern = ".nc$",
                                   recursive = T,
                                   full.names = T)

  all_files_base <- basename(all_files_fullpath)

  # create info data
  data.table(fn = all_files_base) %>%
    .[, tstrsplit(fn, "_")] %>%
    .[, V9 := gsub(".nc", "", V9)] -> dat_info

  setnames(dat_info, c("variable", "domain", "gcm", "experiment","ensemble",
                       "institute_rcm", "downscale_realisation", "timefreq", "years"))

  dat_info[, file_fullpath := all_files_fullpath]


  # get unique models
  dat_info_summary <- dat_info[,
                               .(nn_files = .N,
                                 list_files = list(file_fullpath),
                                 years_total = paste0(.SD[1, years %>% strsplit("-") %>% .[[1]] %>% .[1]],
                                                      "-",
                                                      .SD[.N, years %>% strsplit("-") %>% .[[1]] %>% .[2]])),
                               keyby = .(variable, domain, gcm, institute_rcm, experiment,
                                         ensemble, downscale_realisation, timefreq)]

  # remove files if not requested
  if(!add_files) dat_info_summary[, list_files := NULL]


  return(dat_info_summary)
}



