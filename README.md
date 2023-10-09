# NCPlots 


Plots NetCdf files using CF convention

## Example 

```julia
using NCPlots, GLMakie, NCDatasets

ds = Dataset("east_domain.nc") 
lons = ds["longitude"][:]
lats = ds["latitidue"][:]
data = ds["t"][:,:,65]

fig = Figure()
ax = LScene(fig[1,1], lons,lats,data)
surface2!(ax,lons,lats,data) 

![](east_domain.png)
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

