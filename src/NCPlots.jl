module NCPlots

using GLMakie, NCDatasets, CommonDataModel

export surface2!, surface3!

function surface2!(ax,lons,lats,data; kwargs...)
    x,y,z = lonlat2xyz(lons,lats)    
    surface!(ax, x,y,z ,color=data; kwargs...) 
end

function surface3!(ax,var::CommonDataModel.AbstractVariable{T}; kwargs...) where T
    lons = var["longitude"][:]
    data = nomissing(collect(var))
    lats = var["latitude"][:]
    
    # Add extra lon point to close surface for global fields
    # could make data a circular buffer instead
    if lons isa Vector  
        println("appending")
        dlon = lons[2]-lons[1]  # Grid spacing
        if (lons[end] + dlon) % 360 == 0
            println("now")
            append!(lons, lons[end]+dlon)
            data = vcat(data,data[1:1,:])
        end
    end  

    x,y,z = lonlat2xyz(lons,lats)
    surface!(ax,x,y,z,color=data; kwargs...) 
end


## Unfinished level and time should become sliders
function surface(ds::NCDataset; kwargs...)

    vars = setdiff(keys(ds),dimnames(ds))
    dsview = view(ds,level=1,time=1)
    data  = dsview["pv"]
   
    fig = Figure()
    menu = Menu(fig[1,1],options=vars)
  #   ax = Axis3(fig[2,1],aspect=(1,1,1),viewmode=:fit,protrusions=0)
     ax = LScene(fig[2,1],show_axis=false)
    
    #hidedecorations!(ax)
    #hidespines!(ax)
    plt = surface3!(ax,data; kwargs...)
    zoom!(ax.scene,0.7)

    return fig,ax,plt
end 


"""
x,y,z = lonlat2xyz(lons,lats)

lons, lats can be either vectors or matrices 
"""
function lonlat2xyz(lons::Vector,lats::Vector)
    x = [cosd(lat)*cosd(lon) for lon in lons, lat  in lats]
    y = [cosd(lat)*sind(lon) for lon in lons, lat  in lats]
    z = [sind(lat)  for lon in lons, lat  in lats]
    return (x,y,z)
end

function lonlat2xyz(lons::Matrix,lats::Matrix)
    x = cosd.(lats).*cosd.(lons)
    y = cosd.(lats).*sind.(lons)
    z = sind.(lats)
    return (x,y,z)
end


end
