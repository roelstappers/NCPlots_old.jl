module NCPlots

using GLMakie, NCDatasets 
export plot3 

"""
    plot3(fig,var) 

Plots NCDataset variable `var` into figure `fig` 
e.g. plot3(fig[1,1],ds["msl"]) 
Assumes longitude and latitude are set in ds 
"""
function plot3(fig, var)
    lons = var["longitude"][:]; 
    lats = var["latitude"][:];
    title = var.attrib["long_name"]
    
 
    t = Observable(1)
    data = @lift(var[:,:,$t])
    max = @lift(maximum($data))
    min = @lift(minimum($data))
    data2 = @lift(($data.-$min)./($max-$min))
    x,y,z = lonlat2xyz(lons,lats)
    #ax = Axis3(fig,aspect=(1,1,1),viewmode=:fit,title=title)
    pl = PointLight(Point3f(0,0,1.1), RGBf(20, 20, 20))
    al = AmbientLight(RGBf(1, 1, 1))

    ax = LScene(fig,show_axis=false, scenekw = (lights  = [pl,al], ) )
    #ax.elevation = latc*pi/180
    #ax.azimuth = lonc*pi/180
    #hidespines!(ax)
    #hidedecorations!(ax)
    #axl = 0.6
    #ax.limits=(-axl,axl,-axl,axl,-axl,axl)
    ds3 = Dataset("$(dirname(pathof(NCPlots)))/lsm_era5.nc")
    lsm = ds3["lsm"][:,:,1]
    surface!(ax, x, y, z, color = lsm,colormap=:gist_earth)
    
    surf = surface!(ax, x, y, z, color = data2,colormap=(:viridis,0.6))
    return ax,surf,t
end 



"""
    Given e.g. variables msl t u v use 
    plot3(fig,[msl t;u v]) 
    axis are linked 
"""
#function plot3(fig,vars::Array)

#  ax = similar(vars) 
#  for r in 1:size(var,1)
#    for c in 1:size(var,2) 
#      ax, surf ,t = plot3(fig,vars[r,c])
#    end
#  end 
#  linkaxis

#end




"""
x,y,z = lonlat2xyz(lons,lats, r=1)

lons, lats can be either vectors or matrices 
r is an optional lons x lats matrix 
"""
function lonlat2xyz(lons::Vector,lats::Vector, r=1.0)
    x = r.*[cosd(lat)*cosd(lon) for lon in lons, lat  in lats]
    y = r.*[cosd(lat)*sind(lon) for lon in lons, lat  in lats]
    z = r.*[sind(lat)  for lon in lons, lat  in lats]
    return (x,y,z)
end

function lonlat2xyz(lons::Matrix,lats::Matrix, r=1.0 )
    x = r.*cosd.(lats).*cosd.(lons)
    y = r.*cosd.(lats).*sind.(lons)
    z = r.*sind.(lats)
    return (x,y,z)
end


end
