

# using 


#function Makie.convert_arguments(ds::CommonDataModel.AbstractVariable)
#     lons = collect(ds["longitude"])
#     lats = collect(ds["longitude"])
#     data = nomissing(collect(ds))
#     return lons,lats,data
#end




@recipe(DsPlot,var) do scene
   # @assert dimnames(var) == ("longitude", "latitude")
 
   Attributes(
        show_axis = false,
        colormap = Reverse(:RdBu)
   #    lons = collect(var["longitude"]),
   #    lats = collect(var["latitude"]) 
   
   )
end


function Makie.plot!(p::DsPlot{<:Tuple{<:CommonDataModel.AbstractVariable}})

    var = p[:var][]
    show_axis = p[:show_axis][]
    @show show_axis
    @assert dimnames(var) == ("longitude", "latitude")
   
    lons  = collect(var["longitude"])
    lats  = collect(var["latitude"])
    x,y,z = lonlat2xyz(lons,lats)
    data = nomissing(collect(var))
  #  println(lons)
    #data  = p[:ds][][:,:,1,1]
    @show typeof(data)
    
    surface!(p,x,y,z,color=data,
        colormap = p[:colormap],
        invert_normals = true,
      #   axis = (show_axis=show_axis,)
    )
    return p
end
