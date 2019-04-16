#' Create map indices from non-standard calendars
#'
#' Interpolates non-standard calendars (360 and noleap) to the standard
#' Gregorian. Assumes daily data as input.
#'
#'
#' @param times Vector of class PCICT (will be truncated to days).
#'
#'
#' @return A data.table with columns:
#'
#'   \itemize{
#'   \item dates_full: sequence of standard dates from min to max date
#'   in input times as data.table::IDate
#'   \item dates_pcict_inter: which dates in
#'   PCICT from times correspond to the standard dates
#'   \item idx_pcict: the
#'   index associated to the input times to be used for mapping e.g. values
#'   }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ncobj <- nc_open("tas_EUR-11_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_day_19491201-19501230.nc")
#' times <- nc.get.time.series(ncobj, "tas")
#'
#' dtx <- map_non_standard_calendar(times)
#' dates <- dtx$dates_full
#' values <- values[dtx$idx_pcict]
#' }
map_non_standard_calendar <- function(times){


  dates_pcict <- trunc(times, "day")

  dates_pcict %>%
    min %>%
    as.character %>%
    lubridate::ymd() -> date_min

  dates_pcict %>%
    max %>%
    as.character %>%
    lubridate::ymd() -> date_max

  # if last day of year is Dec 30, make it Dec 31
  if(month(date_max) == 12 & day(date_max) == 30){
    day(date_max) <- 31
  }

  dates_full <- seq(date_min, date_max, by = "day")

  seq_pcict <- seq(1, length(dates_pcict), length.out = length(dates_full))
  idx_pcict <- round(seq_pcict)

  dtx <- data.table(dates_full = dates_full,
                    dates_pcict_inter = as.character(dates_pcict[idx_pcict]),
                    idx_pcict = idx_pcict)

  return(dtx)

}

