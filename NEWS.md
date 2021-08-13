# eurocordexr 0.2.2

- updated description with links, put packages and API in single quotes
- spelled out TRUE and FALSE
- check_inventory() now returns an overloaded list of class "eurocordex_inv_check" with specific 
  print method
- added test netCDF files, cropped from EURO-CORDEX for size; used for examples

---

# eurocordexr 0.2.1

- changed package imports to not use `.onLoad()` with `library()` but rely on `#' @import`
- updated `check_inventory()` and `compare_variables_in_inventory()` to reflect changes from `get_inventory()`
- added a check for complete periods in `check_inventory()`
- misc polishing for submission to CRAN
- consolidate licenses for CRAN and github
- added `globalVariables()` and reformatted examples to remove R CHECK NOTES

---

# eurocordexr 0.2.0

- improved `get_inventory()` overview of file dates
- initial version imported from Eurac gitlab
- Added a `NEWS.md` file to track changes to the package.
