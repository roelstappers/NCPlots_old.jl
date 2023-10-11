

# using 

@recipe(DsPlot,cdmvar) do scene
    Attributes(
       lons = cdmvar["longitude"],
       lats = cdmvar["latitude"] 
       )
       end


function Makie.plot!(p::DsPlot{<:Tuple{<:CommonDataModel.AbstractVariable}})
    lons  = p[:lons][]
    lats  = p[:lats][]
    data  = p[:ds][][:,:,1,1]
    heatmap!(p,data)
end
