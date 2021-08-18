This is a re-submission.

## CRAN comments:

1. 
Please provide a link to the used webservices to the description field
of your DESCRIPTION file in the form
<http:...> or <https:...>
with angle brackets for auto-linking and no space after 'http:' and
'https:'.

2.
Please always write package names, software names and API (application
programming interface) names,... in single quotes in title and
description. e.g: --> 'data.table', 'netCDF'

3.
Please write TRUE and FALSE instead of T and F.

4.
You write information messages to the console that cannot be easily
suppressed. It is more R like to generate objects that can be used to
extract the information a user is interested in, and then print() that
object. Instead of print()/cat() rather use message()/warning() or
if(verbose)cat(..) (or maybe stop()) if you really have to write text to
the console. (except for print, summary, interactive functions)

5.
If possible: Please add small executable examples in your Rd-files (not
wrapped in \dontrun{}) to illustrate the use of the exported function
but also enable automatic testing.



## Answers to CRAN comments

1. Added links.
2. Modified as suggested.
3. Spelled out T(RUE) and F(ALSE)
4. I guess this refers to `check_inventory()`, which printed a lot to console. This was fixed, by returning an overloaded list of class "eurocordexr_check_inv", which has its own `print()`. The other functions that also print to console, already had a `verbose` argument, which by default is false.
5. Unfortunately not possible for the functions with "inventory", since they're based on local paths and files. But I added some small test netCDF files in the package, which are now used in the other function's examples.


## Test environments

-   local R installation, R 4.1.0
-   win-builder (devel)
-   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
-   Ubuntu Linux 20.04.1 LTS, R-release, GCC
-   Fedora Linux, R-devel, clang, gfortran


## R CMD check results

There were 0 ERRORS, 0 WARNINGS, 1 NOTES.

- CRAN incoming feasibility: New submssions; and possible misspellings (actually OK)
