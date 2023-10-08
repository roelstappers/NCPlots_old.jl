# NCPlots 


Plots NetCdf files using CF convention

## Example 

```julia
using NCPlots, GLMakie, NCDatasets

ds = Dataset("era5_dataset.nc") 
msl = ds["msl"] 

fig = Figure()
plot3(fig[1,1], msl) 
```


## Multiple plots 

```julia
plot3(fig[1,1],msl)
plot3(fig[1,2],t)
plot3(fig[2,1],u) 
plot3(fig[2,2],v) 
```

## Animations 

```julia
ax, surf ,t = plot3(fig[1,1],msl)

for i in 1:length(t)
   t[] = i 
   sleep(0.01)
end 
```

