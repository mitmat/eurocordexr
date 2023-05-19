#' Get inventory from path containing EURO-CORDEX .nc files
#'
#' Returns a data.table with information by splitting the netcdf files into
#' their components (GCM, RCM, variable, experiment, ...) and aggregates over
#' years.
#'
#' @param path Path that will be searched recursively for .nc files.
#' @param add_files Boolean (default \code{TRUE}), if \code{TRUE}, will add a
#'   column containing lists of associated files with their full paths (useful
#'   e.g. for further processing).
#'
#' @return A data.table with the inventory information.
#'
#' @seealso \code{\link{compare_variables_in_inventory}} for further comparing
#'   the results, and \code{\link{check_inventory}} for performing some checks.
#'
#' @export
#'
#' @import data.table
#' @importFrom magrittr %>% equals
#' @importFrom lubridate ymd day day<-
#'
#'
#' @examples
#' \dontrun{
#'
#' path <- "/mnt/CEPH_BASEDATA/METEO/SCENARIO"
#' dat <- get_inventory(path)
#' print(dat)
#'
#' }
get_inventory <- function(path,
                          add_files = TRUE){

  all_files_fullpath <- fs::dir_ls(path,
                                   regexp = "[.]nc$",
                                   recurse = TRUE)

  all_files_base <- fs::path_file(all_files_fullpath)

  # create info data
  data.table(fn = fs::path_ext_remove(all_files_base)) %>%
    .[, tstrsplit(fn, "_")] -> dat_info

  # add period column (V9), if it does not exist, as e.g. for OROG
  if(! "V9" %in% names(dat_info)){
    dat_info[, V9 := NA_character_]
  }

  setnames(dat_info,
           old = paste0("V", 1:9),
           new = c("variable", "domain", "gcm", "experiment","ensemble",
                   "institute_rcm", "downscale_realisation", "timefreq", "period"))

  # check for errors in period encoding
  dat_info[period == ensemble, period := NA]

  # add file
  dat_info[, file_fullpath := all_files_fullpath]

  # prep dates
  dat_info[, c("date_start", "date_end") := tstrsplit(period, "-")]
  dat_info[, date_start := ymd(date_start)]
  dat_info[, date_end := ymd(date_end)]

  # helper fun to check for complete contiguous period
  f_date_complete <- function(date_start, date_end){

    if(all(is.na(date_start))) return(NA)

    # 360 calendar adjustment
    lgl_check <- month(date_end) == 12 & day(date_end) == 30
    day(date_end[lgl_check]) <- 31

    mapply(seq, date_start, date_end, by = "day") %>%
      unlist %>%
      sort %>%
      unique %>%
      diff %>%
      equals(1) %>%
      all

  }

  f_sim_years <- function(date_start, date_end){

    if(all(is.na(date_start))) return(NA_integer_)

    mapply(seq, year(date_start), year(date_end), SIMPLIFY = FALSE) %>%
      unlist %>%
      unique %>%
      length

  }


  # get unique models
  dat_info_summary <- dat_info[,
                               .(nn_files = .N,
                                 date_start = min(date_start),
                                 date_end = max(date_end),
                                 total_simulation_years = f_sim_years(date_start, date_end),
                                 period_contiguous = f_date_complete(date_start, date_end),
                                 list_files = list(file_fullpath)),
                               keyby = .(variable, domain, gcm, institute_rcm, experiment,
                                         ensemble, downscale_realisation, timefreq)]

  # remove files if not requested
  if(!add_files) dat_info_summary[, list_files := NULL]

  # make a class to define specific print options
  setattr(dat_info_summary, "class", c("eurocordexr_inv", class(dat_info_summary)))

  return(dat_info_summary)
}
#' Print an inventory
#'
#' Modified
#'   \code{\link[data.table:print.data.table]{data.table::print.data.table}} to
#'   print an inventory from \code{\link{get_inventory}} more nicely by
#'   removing some columns.
#'
#' @param x data.table to print
#' @param all_cols Boolean (default \code{FALSE}), if \code{TRUE}, will print all
#'   columns available
#' @param ... passed on to \code{\link[data.table:print.data.table]{data.table::print.data.table}}
#'
#' @return x invisibly, used for side effects: prints to console
#'
#' @seealso \code{\link{print.default}}
#' @export
print.eurocordexr_inv <- function(x, all_cols = F, ...){

  # remove "eurocordexr_inv" class, so print falls back to data.table default (internal)
  setattr(x, "class", c("data.table", "data.frame"))

  cols_optional <- c("nn_files",
                     "total_simulation_years",
                     "period_contiguous",
                     "list_files")
  class_abbs <- c("<int>", "<int>", "<lgcl>", "<list>")

  # print less columns
  if(!all_cols){

    avail <- cols_optional %in% colnames(x)
    cols_not_print <- cols_optional[avail]
    n <- length(cols_not_print)
    print(x[, -..cols_not_print],
          class = TRUE, trunc.cols = FALSE,
          ...)
    # borrowed from data.table:::print.data.table()
    if(n > 0L){
      cat(sprintf(ngettext(n,
                           "%d variable not shown: %s\n",
                           "%d variables not shown: %s\n"),
                  n,
                  paste(cols_not_print, class_abbs[avail], collapse = ", ")))
    }


  } else {
    print(x,
          class = TRUE, trunc.cols = FALSE,
          ...)
  }

  # add back "eurocordexr_inv" class, since modified by refernce
  setattr(x, "class", c("eurocordexr_inv", "data.table", "data.frame"))

  invisible(x)
}

