This is a re-submission.

Answers to CRAN comment (package did not pass automatic incoming tests):

-   consolidated the License field in DESCRIPTION and LICENSE file to match CRAN and github requirements. License is GPL-3
-   The other tests result only in NOTES: They are by design and explained further below

## Test environments

-   local R installation, R 4.1.0
-   ubuntu 16.04 (on travis-ci), R 4.1.0
-   win-builder (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

There were 3 NOTES:

-   "CRAN incoming feasibility": New submission; possible misspellings are actually ok.
-   "no visible bindings for variables and .() function": I make usage of data.table NSE syntax.
-   "Rd line widths wider than 100 characters": In examples I use actual EUROCORDEX RCM-filenames, which are very long.
