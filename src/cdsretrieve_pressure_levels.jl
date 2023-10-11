import CDSAPI 

year = 2020
month = 4    # use e.g. 1:12 for all months
day = 1:10      # use e.g. 1:31 for all days in month
times = 0:1:23  # use 0:1:23 for all hours in day(s)

# variable = "mean_sea_level_pressure"  # "surface_pressure"
variable = ["geopotential", "pv"]


CDSAPI.retrieve(
    "reanalysis-era5-pressure-levels",
    Dict(    
        "product_type" =>  "reanalysis",
        "format" => "netcdf",
        "variable" => variable,
        "pressure_level" => "500",
        "time"  =>  lpad.(times,2,"0") .*":00",    # 00:00 00:06 00:12 etc 
        "day"  => lpad.(day,2,"0"),            # 01 02 03 etc ,
        "month" => lpad.(month,2,"0"),         # 01 02 03 etc
        "year" => "$year",
       #   "area" => area  # leave  out for global fields
    ),
    "/home/roel/era5/era5_pressure_levels_$(join(variable,"_")).nc"
)

