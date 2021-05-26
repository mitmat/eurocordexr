## Test environments
* local R installation, R 4.1.0
* ubuntu 16.04 (on travis-ci), R 4.1.0
* win-builder (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

There were 2 NOTES:
  
* no visible bindings for variables and .() function: I make usage of data.table NSE syntax.
* Rd line widths wider than 100 characters: In examples I use actual RCM-filenames, which are very long.

## Other

* This is a new release.

