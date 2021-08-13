#' Perform some checks on the inventory
#'
#' Some simple checks for multiple time frequencies, domains, ensembles,
#' downscale realizations, and completeness of simulation periods.
#' Can also run \code{\link{compare_variables_in_inventory}}
#' to check for completeness of variables for all models. These checks are meant
#' as guides only, since one might not wish multiple elements of the above for
#' climate model ensemble assessments.
#'
#' The checks are \itemize{
#' \item for multiple time frequency (day, month, ...)
#' \item for multiple domains (EUR-11, EUR-44, ...)
#' \item for multiple ensembles (r1i1p1, r2i1p1, ...)
#' \item for multiple downscale realizations (v1, v2, ..)
#' \item for complete periods of simulations: historical usually goes approx.
#' from 1950/70 - 2005, and rcp* from 2006 - 2100; evaluation is not checked,
#' because it has very heterogeneous periods
#' \item that all variables (tas, pr, ...) are available for all models
#' }
#'
#'
#' @param data_inventory A data.table as resulting from
#'   \code{\link{get_inventory}}.
#' @param check_vars Boolean, if \code{TRUE}, runs \code{\link{compare_variables_in_inventory}}
#'  to check if all variables are available in all models.
#'
#' @return An object of class "eurocordexr_inv_check" (an overloaded list) with results
#' from the checks. Has a special print method, which shows a verbose summary of the results.
#'
#'
#' @export
#'
#' @import data.table
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#'
#' path <- "/mnt/CEPH_PROJECTS/SCENARIO/CLIMATEDATA/"
#' dat_inv <- get_inventory(path)
#' inv_check <- check_inventory(dat_inv)
#' inv_check
#' }
check_inventory <- function(data_inventory,
                            check_vars = FALSE){

  dat_inv <- copy(data_inventory)

  # remove list_files column for nicer printing
  if("list_files" %in% names(dat_inv)) dat_inv[, list_files := NULL]


  l_out <- list()



  # check for multiple timefreq
  timefreqs <- sort(unique(dat_inv$timefreq))
  timefreqs <- timefreqs[timefreqs != "fx"]

  l_out$timefreqs <- timefreqs

  # check for multiple domains
  l_out$domains <- sort(unique(dat_inv$domain))


  # check for multiple ensembles
  dat_mult_ens <- dat_inv[,
                          .(N = .N,
                            ensembles = paste(ensemble, collapse = ", ")),
                          .(variable, domain, gcm, institute_rcm, experiment,
                            downscale_realisation, timefreq)]
  dat_mult_ens <- dat_mult_ens[N > 1]

  l_out$multiple_ensembles <- dat_mult_ens


  # check for multiple downscale_realisation
  dat_mult_ds <- dat_inv[,
                         .(N = .N,
                           downscale_realisations = paste(downscale_realisation, collaps = ", ")),
                         .(variable, domain, gcm, institute_rcm, experiment,
                           ensemble, timefreq)]
  dat_mult_ds <- dat_mult_ds[N > 1]


  l_out$multiple_downscale_realisations <- dat_mult_ds


  # check for complete periods ~1950/70-2005 and ~2006-2100
  dat_period_complete <- rbind(
    dat_inv[experiment == "historical" & !is.na(date_start) &
              !(year(date_start) %in% 1948:1951 &
                  total_simulation_years >= 54) &
              !(year(date_start) %in% c(1970) &
                  total_simulation_years >= 36)],
    dat_inv[startsWith(experiment, "rcp") & !is.na(date_start) &
              !(year(date_start) %in% c(2005, 2006) &
                  total_simulation_years >= 93)]
  )

  l_out$incomplete_periods <- dat_period_complete


  # check for complete combinations for all variables
  if(check_vars){
    variables <- unique(dat_inv$variable)
    if(length(variables) > 1){
      dat_comp <- compare_variables_in_inventory(dat_inv, variables)
      dat_comp_mult <- dat_comp[all_date_start_equal == FALSE | all_years_equal == FALSE]
      l_out$incomplete_variables <- dat_comp_mult
    }
  }


  class(l_out) <- c("eurocordexr_inv_check", class(l_out))
  l_out
}


#' @export
print.eurocordexr_inv_check <- function(x, ...){

  # start
  cat("Checks performed:", "\n")
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")


  # check for multiple timefreq
  test_timefreq <- length(x$timefreqs) > 1

  if(test_timefreq) {
    cat("Multiple time frequencies detected:", x$timefreqs, "\n")
  } else {
    cat("No multiple time frequencies.", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")



  # check for multiple domains
  test_domain <- length(x$domains) > 1
  if(test_domain) {
    cat("Multiple domains detected:", x$domains, "\n")
  } else {
    cat("No multiple domains.", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")




  # check for multiple ensembles
  n_mult_ens <- nrow(x$multiple_ensembles)
  test_mult_ens <- n_mult_ens > 0

  if(test_mult_ens){
    cat("Multiple ensembles in", n_mult_ens, "cases:", "\n")
    print(x$multiple_ensembles)
  } else {
    cat("No multiple ensembles.", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")




  # check for multiple downscale_realisation
  n_mult_ds <- nrow(x$multiple_downscale_realisations)
  test_mult_ds <- n_mult_ds > 0
  if(test_mult_ds){
    cat("Multiple downscale realisation in", n_mult_ds, "cases:", "\n")
    print(x$multiple_downscale_realisations)
  } else {
    cat("No multiple downscale realisations", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")


  if(nrow(x$incomplete_periods) == 0){
    cat("All historical and rcp simulations have complete periods.\n")
    test_complete_period <- FALSE
  } else {
    cat("Following model runs do not have complete periods:", "\n")
    print(x$incomplete_periods)
    test_complete_period <- TRUE
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")



  if(!is.null(x$incomplete_variables)){
    test_variable <- nrow(x$incomplete_variables) > 0
    if(test_variable){
      cat("Following models do not have all variables:", "\n")
      print(x$incomplete_variables)
    } else {
      cat("All variables present in all models.", "\n")
    }
    cat("------------------------------------------------------\n")
    cat("------------------------------------------------------\n")
  }


  # end
  cat("Finished checks.", "\n")
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")


}
