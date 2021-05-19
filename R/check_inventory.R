#' Perform some checks on the inventory
#'
#' Some simple checks for multiple time frequencies, domains, ensembles,
#' and downscale realisations. Also runs \code{\link{compare_variables_in_inventory}}
#' to check for completeness of variables for all models. These checks are meant
#' as guides only, since one might not wish multiple elements of the above for
#' climate model ensemble assessments.
#'
#' @param data_inventory A data.table as resulting from
#'   \code{\link{get_inventory}}.
#'
#' @return Invisibly TRUE if all checks passed, and FALSE if at least one check failed.
#'   Only the checks for multiple values are taken into account, the one for completeness
#'   of variables is not.
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
#' path <- "/mnt/CEPH_BASEDATA/METEO/SCENARIO"
#' dat <- get_inventory(path)
#' check_inventory(dat)
#' }
check_inventory <- function(data_inventory){

  dat_inv <- copy(data_inventory)

  # remove list_files column for nicer printing
  if("list_files" %in% names(dat_inv)) dat_inv[, list_files := NULL]


  # start
  cat("Checks performed:", "\n")
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")

  # check for mutliple timefreq
  test_timefreq <- length(unique(dat_inv$timefreq)) > 1
  if(test_timefreq) {
    cat("Multiple time frequencies detected:", unique(dat_inv$timefreq), "\n")
  } else {
    cat("No multiple time frequencies.", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")

  # check for mutliple domains
  test_domain <- length(unique(dat_inv$domain)) > 1
  if(test_domain) {
    cat("Multiple domains detected:", unique(dat_inv$domain), "\n")
  } else {
    cat("No multiple domains.", "\n")
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")

  # check for multiple ensembles
  dat_mult_ens <- dat_inv[, .N, .(variable, domain, gcm, institute_rcm, experiment,
                                  downscale_realisation, timefreq)]
  dat_mult_ens <- dat_mult_ens[N > 1]
  n_mult_ens <- nrow(dat_mult_ens)
  test_mult_ens <- n_mult_ens > 0
  if(test_mult_ens){
    for(i in 1:n_mult_ens){
      cat("Multiple ensembles in", i, "of", n_mult_ens, ":", "\n")
      print(merge(dat_mult_ens[i], dat_inv,
                  by = c("variable", "domain", "gcm", "institute_rcm",
                         "experiment", "downscale_realisation", "timefreq")))
      cat("------------------------------------------------------\n")
    }
  } else {
    cat("No multiple ensembles.", "\n")
    cat("------------------------------------------------------\n")
  }
  cat("------------------------------------------------------\n")

  # check for multiple downscale_realisation
  dat_mult_ds <- dat_inv[, .N, .(variable, domain, gcm, institute_rcm, experiment,
                                 ensemble, timefreq)]
  dat_mult_ds <- dat_mult_ds[N > 1]
  n_mult_ds <- nrow(dat_mult_ds)
  test_mult_ds <- n_mult_ds > 0
  if(test_mult_ds){
    for(i in 1:n_mult_ds){
      cat("Multiple downscale realisation in", i, "of", n_mult_ds, ":", "\n")
      print(merge(dat_mult_ds[i], dat_inv,
                  by = c("variable", "domain", "gcm", "institute_rcm",
                         "experiment", "ensemble", "timefreq")))
      cat("------------------------------------------------------\n")
    }
  } else {
    cat("No multiple downscale realisations", "\n")
    cat("------------------------------------------------------\n")
  }
  cat("------------------------------------------------------\n")

  # check for complete combinations for all variables
  variables <- unique(dat_inv$variable)
  if(length(variables) == 1){
    cat("Only one variable:", variables, "\n")
    test_variable <- F
  } else {
    dat_comp <- compare_variables_in_inventory(dat_inv, variables)
    dat_comp_mult <- dat_comp[all_nn_files_equal == FALSE | all_years_total_equal == FALSE]
    test_variable <- nrow(dat_comp_mult) > 0
    if(test_variable){
      cat("Following models do not have all variables:", "\n")
      print(dat_comp_mult)
    } else {
      cat("All variables present in all models.", "\n")
    }
  }
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")

  # end
  cat("Finished checks.", "\n")
  cat("------------------------------------------------------\n")
  cat("------------------------------------------------------\n")

  # return invisibly TRUE if all tests passed, FALSE otherwise if one failed
  out_test <- !(test_timefreq | test_domain | test_mult_ens | test_mult_ds)
  invisible(out_test)

}
