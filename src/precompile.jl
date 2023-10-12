



@setup_workload begin 
    lsmfile =  "$(dirname(pathof(NCPlots)))/lsm_era5.nc"
   @compile_workload begin 
       ds = Dataset(lsmfile)
       field = view(ds,time=1)["lsm"]

       NCPlots.surface3(field,colormap=:RdBu,colorrange=(0,1))
   end 

end 