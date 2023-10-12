module NCPlots

using GLMakie, NCDatasets, CommonDataModel
using PrecompileTools

export surface2!, surface3!, surface3, plot!
include("recipe.jl")

function surface2!(ax,lons,lats,data; kwargs...)
    x,y,z = lonlat2xyz(lons,lats)    
    surface!(ax, x,y,z ,color=data; kwargs...) 
end

function surface3(var::CommonDataModel.AbstractVariable{T}; time=Observable(1), kwargs...) where T
    fig = Figure(resolution=(1200,1200),figure_padding=0)
    pl = PointLight(Point3f(10000,10000,0), RGBf(0.1,0.1,0.1))
    pl = PointLight(Point3f(0,0,1), RGBf(1,1,1))
   
    al = AmbientLight(RGBf(0.8, 0.8, 0.8))

    ax = LScene(fig[1,1],show_axis=false) #; scenekw = (lights = [pl, al],))
    plt = surface3!(ax,var;time) # , invert_normals=true, kwargs...)
    plt.diffuse=0.8
    plt.specular=0.1
    display(fig)
    fig,ax,plt
end


function surface3!(ax,var::CommonDataModel.AbstractVariable{T}; time, kwargs...) where T

    lons = collect(var["longitude"])
    lats = collect(var["latitude"])
    invert_normals = isa(lons,Vector) ? true : false   # For global fields invert normals
    kwargs = (;kwargs..., invert_normals=invert_normals)
    data = @lift(nomissing(collect(var[:,:,$time])))
   
    if lons isa Vector  
        dlon = lons[2]-lons[1]  # Grid spacing
        if (lons[end] + dlon) % 360 == 0
            append!(lons, lons[end]+dlon)
            data = @lift(vcat($data,$data[1:1,:]))
        end
    end  
   
    x,y,z = lonlat2xyz(lons,lats)
    surface!(ax,x,y,z,color=data; specular=1, kwargs...)     
end


function plot(var::Observable{<:CommonDataModel.AbstractVariable{T}}; kwargs...) where T
    fig = Figure(resolutio=(1200,1200),figure_padding=0)
    ax = LScene(fig[1,1],show_axis=false)
    plt = dsplot!(ax,var; kwargs...)

    title = var[].var.attrib["long_name"]
    ds = var[].parent
    dimn = dimnames(ds)[3]
    ind = var[].indices[3]
   
    val = ds[dimn][ind]

    @show kwargs   

    Label(fig[0,1],"$title $dimn=$val",tellwidth=false)
    # display(fig)
    return fig,ax,plt     
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

lons, lats can be either vectors or matrices (for LAM models )
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


include("precompile.jl")
end
