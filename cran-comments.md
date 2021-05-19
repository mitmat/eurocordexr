## Test environments

-   local R installation, R 4.0.5
-   ubuntu 16.04 (on travis-ci), R 4.0.5
-   win-builder (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

There were 3 NOTES:

### NOTE 1:

(not a package issue)

-   checking for future file timestamps ... NOTE unable to verify
    current time

### NOTE 2:

(I use data.table extensively... all caused by NSE)

-   checking R code for possible problems ... NOTE check_inventory: no
    visible binding for global variable 'list_files' check_inventory: no
    visible global function definition for '.' check_inventory: no
    visible binding for global variable 'variable' check_inventory: no
    visible binding for global variable 'domain' check_inventory: no
    visible binding for global variable 'gcm' check_inventory: no
    visible binding for global variable 'institute_rcm' check_inventory:
    no visible binding for global variable 'experiment' check_inventory:
    no visible binding for global variable 'downscale_realisation'
    check_inventory: no visible binding for global variable 'timefreq'
    check_inventory: no visible binding for global variable 'N'
    check_inventory: no visible binding for global variable 'ensemble'
    check_inventory: no visible binding for global variable
    'all_nn_files_equal' check_inventory: no visible binding for global
    variable 'all_years_total_equal' compare_variables_in_inventory: no
    visible binding for global variable 'list_files'
    compare_variables_in_inventory: no visible binding for global
    variable 'variable' compare_variables_in_inventory: no visible
    binding for global variable 'all_nn_files_equal'
    compare_variables_in_inventory: no visible global function
    definition for 'patterns' compare_variables_in_inventory: no visible
    binding for global variable 'all_years_total_equal' get_inventory:
    no visible binding for global variable '.' get_inventory: no visible
    binding for global variable 'fn' get_inventory: no visible binding
    for global variable 'V9' get_inventory: no visible binding for
    global variable 'period' get_inventory: no visible binding for
    global variable 'ensemble' get_inventory: no visible binding for
    global variable 'file_fullpath' get_inventory: no visible binding
    for global variable 'date_start' get_inventory: no visible binding
    for global variable 'date_end' get_inventory : f_date_complete: no
    visible global function definition for 'day' get_inventory :
    f_date_complete: no visible global function definition for 'day\<-'
    get_inventory : f_date_complete: no visible global function
    definition for 'equals' get_inventory: no visible global function
    definition for '.' get_inventory: no visible binding for global
    variable 'variable' get_inventory: no visible binding for global
    variable 'domain' get_inventory: no visible binding for global
    variable 'gcm' get_inventory: no visible binding for global variable
    'institute_rcm' get_inventory: no visible binding for global
    variable 'experiment' get_inventory: no visible binding for global
    variable 'downscale_realisation' get_inventory: no visible binding
    for global variable 'timefreq' get_inventory: no visible binding for
    global variable 'list_files' map_non_standard_calendar: no visible
    global function definition for 'day' map_non_standard_calendar: no
    visible global function definition for 'day\<-' nc_grid_to_dt: no
    visible binding for global variable 'icell' nc_grid_to_dt: no
    visible binding for global variable 'x' nc_grid_to_dt: no visible
    binding for global variable 'y' nc_grid_to_dt: no visible global
    function definition for '.' nc_grid_to_dt: no visible binding for
    global variable 'value' Undefined global functions or variables: . N
    V9 all_nn_files_equal all_years_total_equal date_end date_start day
    day\<- domain downscale_realisation ensemble equals experiment
    file_fullpath fn gcm icell institute_rcm list_files patterns period
    timefreq value variable x y

### NOTE 3:

(These are original EURO-CORDEX filenames, which are just long...)

-   checking Rd line widths ... NOTE Rd file
    'map_non_standard_calendar.Rd': \examples lines wider than 100
    characters: ncobj \<-
    nc_open("tas_EUR-11_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_day_19491201-19501230.nc")

    Rd file 'nc_grid_to_dt.Rd': \examples lines wider than 100
    characters: dat \<- nc_grid_to_dt(filename =
    "tas_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_SMHI-RCA4_v1_day_19700101-19701231.nc",

    Rd file 'rotpole_nc_point_to_dt.Rd': \examples lines wider than 100
    characters: dt1 \<- rotpole_nc_point_to_dt(filename =
    "tas_EUR-11_CNRM-CERFACS-CNRM-CM5_historical_r1i1p1_SMHI-RCA4_v1_day_19700101-19701231.nc",
    dt2 \<- rotpole_nc_point_to_dt(filename =
    "tas_EUR-11_MOHC-HadGEM2-ES_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_day_19491201-19501230.nc",

-   This is a new release.
