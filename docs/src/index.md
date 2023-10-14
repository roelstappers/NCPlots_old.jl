# NCPlots

NCPlots is a Julia package for plotting meteorological data on the sphere. It is mainly used for plotting numerical weather prediction output. It works for both global (ERA5) and limited area domains (CARRA, MetCoop). It should work for any dataset that conforms to the CF convention and implements the `CommonDataModel` interface. 


See [Getting data](@ref getting_data) how to obtain ERA5 and CARRA data to recreate the examples in this documentation 

NCPlots uses [Observables](https://docs.makie.org/stable/explanations/nodes/index.html) for interactivity 


## Installation

NCPlots is in the Harmonie registry. 
Add the Harmonie registry (hit `]` in the Julia REPL to enter package mode).  


```julia
pkg> registry add https://github.com/Hirlam/HarmonieRegistry.git
```

Then install NCPlots with 
```
pkg> add NCPlots 
```

!!! note 
    For convenience `NCPlots` reexports `GLMakie` and `NCDatasets` 


## Data requirements 

Variables should only have dimensions `longitude` and `latitude`. If there are additional dimensions create a view
e.g. for a dataset `ds` that contains a variable `pv` where `pv` in addition to `longitude` and `latitude` also has dimension  `time` do 

```julia
julia> using NCPlots
julia> ds = Dataset("era5_pressure_levels_geopotential_pv.nc")
julia> pv = view(ds,time=1)["pv"]
pv (1440 × 721)
  Datatype:    Union{Missing, Float64}
  Dimensions:  longitude × latitude
  Attributes:
   scale_factor         = 1.814417934243432e-9
   add_offset           = 4.442749788103522e-5
   _FillValue           = -32767
   missing_value        = -32767
   units                = K m**2 kg**-1 s**-1
   long_name            = Potential vorticity
```

Or to control which time is shown  

```julia
t = Observable(1)
pv = @lift(view(ds,time=$t)["pv"])
plot(pv) 
```

The plot will update automatically with  

```julia
t[]=2
```

to make a basic animation you can do

```julia
for ti = 1:100
   t[]=ti
   sleep(0.01)
end 
```

See [Animations](@ref Animations) how to control the camera position



