module NCPlots

using GLMakie

export surface2!


function surface2!(ax,lons,lats,var; kwargs...)
    #lons = lons[:] # ds["longitude"]
    #lats = lats[:] # ds["latitude"]
    data = nomissing(var) 
    x,y,z = lonlat2xyz(lons,lats)    
    surface!(ax, x,y,z ,color=data; kwargs...) 
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
