module NCPlots

using Reexport 

@reexport using GLMakie, NCDatasets, CommonDataModel, Dates
using AstroLib 
using PrecompileTools


export plot, plotvar!, addmeridian!, addequator!, lonlat2xyz

# include("recipe.jl")

function plot(var::Observable{<:CommonDataModel.AbstractVariable{T}}, dt::Observable{<:DateTime}; kwargs...) where T

    fig = Figure(resolution=(1200,1200), figure_padding=0)
    
    ax = LScene(fig[1,1],show_axis=false)
    
    plt = plotvar!(ax,var; kwargs...)    

    addequator!(ax,linewidth=2,color=:green) # ,linestyle=:dash)
    addmeridian!(ax,linewidth=2,color=:green) #,linestyle=:dash)
    @lift(update_camsun!(ax,$dt))

    #eyeposition = @lift(sunpos2($dt)); lookat=Vec3f(0,0,0);
    # eyeposition = Vec3f(1.0,1,1)
   # cam3d = cameracontrols(ax.scene)
   # cam3d.eyeposition = @lift(sunpos2($dt)) # @lift($eyeposition
   # translate_cam!(ax.scene, eyeposition)
    # update_cam!(ax.scene, ,eyeposition[],lookat)
    display(fig)
    
    return fig,ax,plt     
end 


function plotvar!(ax,var::Observable; kwargs...)
    lons  = collect(var[]["longitude"])
    lats  = collect(var[]["latitude"])
    invert_normals = isa(lons,Vector) ? true : false
    x,y,z = lonlat2xyz(lons,lats)
    data = @lift(nomissing(collect($var)))
    surface!(ax,x,y,z,color=data, invert_normals = invert_normals; kwargs...)
    
    
end 

function sunpos2(dt)
    lon = Hour(dt)*360.0 /Hour(24) ; lat=20.0
    x = cosd(lon)*cosd(lat)
    y = sind(lon)*cosd(lat)
    z = sind(lat)
    return Vec3f(3x,3y,3z)
end 
     

function update_camsun!(ax,dt,zoom=3.0)
    # (x,y,z,dx,dy,dz) = xyz(juldate(dt) + 64/86400,2000)
    lon = Minute(-dt)*360.0 /Hour(24) ; lat=45.0
    x = cosd(lon)*cosd(lat);  
    y= sind(lon)*cosd(lat); 
    z = sind(lat); 
    eyeposition = Vec3f(zoom*x,zoom*y,zoom*z)  # eyeposition is sun "position" 
    cam3d = cameracontrols(ax.scene)
    cam3d.eyeposition[] = eyeposition 
    update_cam!(ax.scene, cam3d)
end 



function addequator!(ax; kwargs...)    
    x,y,z = lonlat2xyz(0:0.25:360,[0])
    lines!(ax,x,y,z;kwargs...)
end 

function addmeridian!(ax, lon=0; kwargs...)
    x,y,z = lonlat2xyz([lon],-90:0.25:90)
    lines!(ax,x,y,z;kwargs...)
end 



# Helper functions to extract attributes from Observables 
long_name(var::Observable) =  var[].var.attrib["long_name"]
CommonDataModel.dimnames(var::Observable) =  dimnames(var[])



"""
x,y,z = lonlat2xyz(lons,lats,r=1)

lons, lats can be either vectors or matrices (for LAM models )
optional specify Matrix r 
"""
function lonlat2xyz(lons::AbstractVector,lats::AbstractVector)
    x = [cosd(lat)*cosd(lon) for lon in lons, lat  in lats]
    y = [cosd(lat)*sind(lon) for lon in lons, lat  in lats]
    z = [sind(lat)  for lon in lons, lat  in lats]
    return (x,y,z)
end

function lonlat2xyz(lons::Matrix,lats::Matrix)
    sindlats, cosdlats = sindcosd(lats)
    sindlons, cosdlons = sindcosd(lons)
    x = cosdlats.*cosdlons
    y = cosdlats.*sindlons
    z = sindlats
    return (x,y,z)
end
  

#function lonlat2xyz(lons::AbstractVector,lats::AbstractVector,r::Observable)
#    println("Observable")
#    x = @lift($r.*[cosd(lat)*cosd(lon) for lon in lons, lat  in lats])
#    y = @lift($r.*[cosd(lat)*sind(lon) for lon in lons, lat  in lats])
#    z = @lift($r.*[sind(lat)  for lon in lons, lat  in lats])
#    return (x,y,z)
#end
 

"""
    isperiodiclon(lons)

If lons is a vector returns true if lons is periodic, e.g. 
     true  for [0,1,...,359]      [0,0.1, ... 359.9]    
     false for [0,0.1,...,359]   [0,1,...,360]  
for matrices always returns false
"""
isperiodiclon(lons::Vector) = (lons[end] + (lons[2]-lons[1])) % 360 == 0
isperiodiclon(lons::Matrix) = false

"""
   lonpadview(data::Matrix) 
   lonpadview(data::Vector) 
   
   Returns a view of data with the first row repeated at the end. 
"""
lonpadview(data::Matrix) = view(data,[1:size(data)[1]...,1],1:size(data)[2])
lonpadview(lon::Vector) = view(lon,[1:length(lon)...,1]) 


# include("precompile.jl")




#function surface3!(ax,var::CommonDataModel.AbstractVariable{T}; time, kwargs...) where T

#    lons = collect(var["longitude"])
#    lats = collect(var["latitude"])
#    invert_normals = isa(lons,Vector) ? true : false   # For global fields invert normals
#    kwargs = (;kwargs..., invert_normals=invert_normals)
#    data = @lift(nomissing(collect(var[:,:,$time])))
   
#    if lons isa Vector  
        
#        if (lons[end] + dlon) % 360 == 0
#            append!(lons, lons[end]+dlon)
#            data = @lift(vcat($data,$data[1:1,:]))
#        end
#    end  
   
#    x,y,z = lonlat2xyz(lons,lats)
#    surface!(ax,x,y,z,color=data; specular=1, kwargs...)     
#end

## Unfinished level and time should become sliders
#function surface(ds::NCDataset; kwargs...)

#    vars = setdiff(keys(ds),dimnames(ds))
#    dsview = view(ds,level=1,time=1)
#    data  = dsview["pv"]
   
#    fig = Figure()
#    menu = Menu(fig[1,1],options=vars)
  #   ax = Axis3(fig[2,1],aspect=(1,1,1),viewmode=:fit,protrusions=0)
   #  ax = LScene(fig[2,1],show_axis=false)
    
    #hidedecorations!(ax)
    #hidespines!(ax)
#    plt = surface3!(ax,data; kwargs...)
#    zoom!(ax.scene,0.7)

#    return fig,ax,plt
# end 


#function surface2!(ax,lons,lats,data; kwargs...)
#    x,y,z = lonlat2xyz(lons,lats)    
#    surface!(ax, x,y,z ,color=data; kwargs...) 
#end

#function surface3(var::CommonDataModel.AbstractVariable{T}; time=Observable(1), kwargs...) where T
#    fig = Figure(resolution=(1200,1200),figure_padding=0)
#    pl = PointLight(Point3f(10000,10000,0), RGBf(0.1,0.1,0.1))
#    pl = PointLight(Point3f(0,0,1), RGBf(1,1,1))
#   
#    al = AmbientLight(RGBf(0.8, 0.8, 0.8))

#    ax = LScene(fig[1,1],show_axis=false) #; scenekw = (lights = [pl, al],))
#    plt = surface3!(ax,var;time) # , invert_normals=true, kwargs...)
#    plt.diffuse=0.8
#    plt.specular=0.1
#    display(fig)
#    fig,ax,plt
# end








end
