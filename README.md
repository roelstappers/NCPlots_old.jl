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
```

![](east_domain.png)

## Multiple plots 

```julia
ds2 = Dataset("west_domain.nc") 
lons2 = ds["longitude"][:]
lats2 = ds["latitidue"][:]
data2 = ds["t"][:,:,65]
surface2!(ax,lons2,lat2,data2)
```

![](east_west_domain.png)


## Animations 

```julia
ax, surf ,t = plot3(fig[1,1],msl)

for i in 1:length(t)
   t[] = i 
   sleep(0.01)
end 
```

