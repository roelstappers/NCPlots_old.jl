# NCPlots

NCPlots is a package for plotting meteorological data on the sphere.
Files should conform to the CommonDataModel like `NCDatasets` and `GRIBDatasets`

## Installation

NCPlots is in the Harmonie registry and can be added by 

```
using Pkg
Pkg.add("NCPlots") 

NetCDF files should have dimensions `latitude` `longitude` `time` if there are additiona dimensions create a view
e.g. if the `Dataset` contains an extra dimensions mbr and variable `pv` do 
```
dsview = view(ds,mbr=1)["pv"] 
```

## Example 

To plot marble 

```
ds = Dataset("era5era5_pressure_levels_geopotential_pv.nc")
dsv = view(ds,time=1)["pv"]
fig,ax,plot = surface3(dsv,colormap=:RdBu,colorrange=(-3e-6,3e-6))

dd=3

surf = surface!(ax,[-dd,-dd,dd,dd],[-dd,dd,dd,-dd],[-1,-1,-1,-1],color=:black,specular=0.1)
surf.diffuse[]=0

# pointlight in surface3! was at 0,1,3 with RGBf(1,1,1)
```





Documentation for [NCPlots](https://github.com/roelstappers/NCPlots.jl).

