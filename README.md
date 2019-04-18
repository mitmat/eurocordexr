A package to make life easier working with daily netcdf files from the 
EURO-CORDEX RCMs. Relies on data.table to do the heavy data lifting.

Main components:

  - extract single grid cells (e.g. for stations) from rotated pole grid
  - extract the whole array of a variable in long format
  - can deal with non-standard calendars (360, noleap) and interpolate them
  
