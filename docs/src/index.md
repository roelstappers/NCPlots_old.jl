```@meta
CurrentModule = NCPlots
```

# NCPlots

To plot marble 

```
ds = Dataset("/home/roel/era5era5_pressure_levels_geopotential_pv.nc")
dsv = view(ds,time=1)["pv"]
fig,ax,plot = surface3(dsv,colormap=:RdBu,colorrange=(-3e-6,3e-6))

dd=3

surf = surface!(ax,[-dd,-dd,dd,dd],[-dd,dd,dd,-dd],[-1,-1,-1,-1],color=:black,specular=0.1)
surf.diffuse[]=0

# pointlight in surface3! was at 0,1,3 with RGBf(1,1,1)
```





Documentation for [NCPlots](https://github.com/roelstappers/NCPlots.jl).

```@index
```

```@autodocs
Modules = [NCPlots]
```
