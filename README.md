# NCPlots 


Plots NetCdf files using CF convention

[](docs/geop2.gif)


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

```
using NCDatasets, GLMakie, NCPlots
ds = Dataset("geopotential_2020.nc")
dsz = ds["z"]
lons = ds["longitude"]
lats = ds["latitude"]
x,y,z = NCPlots.lonlat2xyz(lons,lats)
t = Observable(1)
geop = @lift(nomissing(dsz[:,:,$t]))
xg = @lift($geop.*x)
yg = @lift($geop.*y)
zg = @lift($geop.*z)

fig = Figure()
ax = Axis3(fig[1,1], viewmode=:fit)
surface!(ax,xg,yg,zg,color=geop,colormap=:RdBu)
maxg = maximum(geop.val)
hidedecorations!(ax)
hidespines!(ax)
ax.protrusions=0

record(fig,"geop.mp4", 1:100,framerate=10) do ti
  t[]=ti
end
```

![](docs/geop.gif)

```julia
ax, surf ,t = plot3(fig[1,1],msl)

for i in 1:length(t)
   t[] = i 
   sleep(0.01)
end 
```

