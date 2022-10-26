using Markdown
using InteractiveUtils

###
# exec '/private/var/folders/54/6x42fkzj20x83xgrkxdqswj40000gn/T/AppTranslocation/AA6D02C9-59B0-4AEA-AA0E-06FAB5FE5475/d/Julia-1.6.app/Contents/Resources/julia/bin/julia'
# run this line first to use julia
###


#import Pkg; 
#Pkg.add("PlutoUI")
#Pkg.add("DataFrames")
#Pkg.add("Plots")
#Pkg.add("RDatasets")
#Pkg.add("Statistics")
#Pkg.add("StatsPlots")
#Pkg.add("CSV")
#Pkg.add("StatsBase")

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8094d2de-2b98-11ec-168c-ad337353816e
begin
	# Deleting this cell may cause the notebook to stop working.
	if "PRAIRIELEARN" ∈ keys(ENV)
		using Pkg; Pkg.activate("/jl")
	end
	using PlutoUI
	using CSV
	using DataFrames
	using StatsPlots
	using Plots
	using Statistics
	
	
end

# ╔═╡ 530b993b-91fd-4df3-8e22-24b1a4dcb1b3
md"""
You can load a CSV file below by clicking "Choose file" and uploading a CSV file. Then, the file will be loaded as `df`.

"""

# ╔═╡ d395f941-8e03-45bd-86f3-2b62c9b1cfb7
@bind f PlutoUI.FilePicker() # pick a csv file

# ╔═╡ 34eff784-5cb0-4b18-ae3f-ff06e4d411a3
df = UInt8.(f["data"]) |> IOBuffer |> CSV.File |> DataFrame

# ╔═╡ cb2e3ccd-a42d-4dc1-8a16-a0275ec577a6
unique(df.WireConf)

# ╔═╡ 6c089f49-1048-4988-a518-fe7484d03d96
ff= filter(x-> (x.WireConf > 2),df)

# ╔═╡ 513a1c66-1bae-4d45-8875-9b0485d25ab6
f1= filter(x -> (x.WireConf !=-1) && (x.Leaf !=-1) && (x.TreeHt !=-1) && (x.Age !=-1) && (x.DBH !=-1), df)

# ╔═╡ 4fd11e5c-b5b3-4e6a-af96-356f37536c47
gg= groupby(f1, :WireConf)

# ╔═╡ af0fb015-3177-4e4b-9a3f-df2cab478a46

fw0= filter(x -> (x.WireConf ==0), f1)

# ╔═╡ 84a11511-74cd-405b-a6e7-38ec5473b4bb


# ╔═╡ 0516b9be-3949-436a-8d18-70caba8501a6
c0= groupby(fw0,:Age)

# ╔═╡ b36c283b-88ce-47fb-8719-bced4010d1b9
c00= combine(c0,:TreeHt=>mean)

# ╔═╡ ca79e188-6d7b-4fba-91cd-b001c4ee5326
p0= plot(c00.Age, c00.TreeHt_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average Tree Height")

# ╔═╡ 0ab1fe62-b4f0-4ae2-bab1-e7cb73785303
begin
fw1= filter(x -> (x.WireConf ==1), f1)
c1= groupby(fw1,:Age)
c11= combine(c1,:TreeHt=>mean)
p1= plot(c11.Age, c11.TreeHt_mean, st= [:scatter], title= "Utility Lines & No Poten. Conflect",xlabel= "Tree Age", ylabel= "Average Tree Height")
end

# ╔═╡ b0a8a96a-2790-473a-b358-5cbc24259b45
begin
fw2= filter(x -> (x.WireConf ==2), f1)
c2= groupby(fw2,:Age)
c22= combine(c2,:TreeHt=>mean)
p2= plot(c22.Age, c22.TreeHt_mean, st= [:scatter],title= "Utility Lines & Conflecting",xlabel= "Tree Age", ylabel= "Average Tree Height")
end

# ╔═╡ 7fed0222-6be8-4b9c-b174-627850b378b9
begin
fw3= filter(x -> (x.WireConf ==3), f1)
c3= groupby(fw3,:Age)
c33= combine(c3,:TreeHt=>mean)
p3= plot(c33.Age, c33.TreeHt_mean, st= [:scatter],title= "Utility Lines & Poten. Conflect",xlabel= "Tree Age", ylabel= "Average Tree Height")
end

# ╔═╡ a2eb0ae5-7d93-48e7-b68e-fb99659ced9e
plot(p0,p1,p2,p3, size= (800,800))

# ╔═╡ 9bb69d71-fe1b-4789-b46a-1106b5b85e7a
begin
	cor0= cor(c00.Age, c00.TreeHt_mean)
	cor1= cor(c11.Age, c11.TreeHt_mean)
	cor2= cor(c22.Age, c22.TreeHt_mean)
	cor3= cor(c33.Age, c33.TreeHt_mean)
	cor0, cor1,cor2,cor3
end

# ╔═╡ bcbda324-ab43-4132-aed0-7f515ef0c5b4
begin
p00= plot(c00.Age, c00.TreeHt_mean, st= [:scatter])
p11= plot!(c11.Age, c11.TreeHt_mean, st= [:scatter])
p22= plot!(c22.Age, c22.TreeHt_mean, st= [:scatter])
p33= plot!(c33.Age, c33.TreeHt_mean, st= [:scatter], xlabel= "Tree Age", ylabel= "Average Tree Height")
end

# ╔═╡ cfe0e2b8-216e-478d-baca-9d97d4d3d586
# to check if the present of wireconf has an effect on the number of leaves, height of trees

#WireConf = Utility lines that interfere with or appear above tree (0=no lines, 1=present and no potential conflict, 2=present and conflicting, 3=present and potential for conflicting). (NOTE: -1 denotes data were not collected.)

# it looks like that the majority of trees have conflict with utility line and that does not affecting the growth of tress (height, # of leaves)
com_group = combine(gg, :Leaf =>mean, :TreeHt=>mean, :Age=>mean,:DBH=>mean, nrow)

# ╔═╡ f670545d-4e78-43da-8c06-dc625e0bfc40
graph1 = plot(com_group.nrow, st=pie)

# ╔═╡ 617f6443-82f6-4afc-acad-7c870009f0e8
graph2 = plot(com_group.WireConf,com_group.TreeHt_mean, st=bar, xlabel= "WireConf", ylabel="Average Tree Height")

# ╔═╡ aa54e530-320c-411c-aed0-7f39fb265027
begin
dbh0= filter(x -> (x.WireConf ==0), f1)
d0= groupby(dbh0,:Age)
d00= combine(d0,:DBH=>mean)
p10= plot(d00.Age, d00.DBH_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average DBH")
end

# ╔═╡ 2574b548-afb7-4fa7-9b5f-43d0eb05a66a
begin
dbh1= filter(x -> (x.WireConf ==1), f1)
d1= groupby(dbh1,:Age)
d11= combine(d1,:DBH=>mean)
p21= plot(d11.Age, d11.DBH_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average DBH")
end

# ╔═╡ 4dd49d7a-7b27-40c2-ac37-c5120076b965
begin
dbh2= filter(x -> (x.WireConf ==2), f1)
d2= groupby(dbh2,:Age)
d22= combine(d2,:DBH=>mean)
pp2= plot(d22.Age, d22.DBH_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average DBH")
end

# ╔═╡ 51864f4b-6cb9-420b-b823-92a54d681a3c
begin
dbh3= filter(x -> (x.WireConf ==3), f1)
d3= groupby(dbh3,:Age)
d33= combine(d3,:DBH=>mean)
pp3= plot(d33.Age, d33.DBH_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average DBH")
end

# ╔═╡ 740d735e-8b82-4a78-97ab-c1166196ab05
let
pp0= plot(d00.Age, d00.DBH_mean, st= [:scatter], title= "No Utility Lines",xlabel= "Tree Age", ylabel= "Average DBH")
pp1= plot(d11.Age, d11.DBH_mean, st= [:scatter], title= "Unitily Lines & No Conflicting",xlabel= "Tree Age", ylabel= "Average DBH")
pp2= plot(d22.Age, d22.DBH_mean, st= [:scatter], title= "Utility Lines & Conflicting",xlabel= "Tree Age", ylabel= "Average DBH")
pp3= plot(d33.Age, d33.DBH_mean, st= [:scatter], title= "Utility Lines & Poten. Conflect",xlabel= "Tree Age", ylabel= "Average DBH")
plot(pp0,pp1,pp2,pp3, size= (800,800), m="red" )
end


# ╔═╡ 358fdd32-98e6-41a5-88a4-2a8593060980
let
	cor0= cor(d00.Age, d00.DBH_mean)
	cor1= cor(d11.Age, d11.DBH_mean)
	cor2= cor(d22.Age, d22.DBH_mean)
	cor3= cor(d33.Age, d33.DBH_mean)
	cor0, cor1,cor2,cor3
end

# ╔═╡ d1cbca81-703d-4e5a-84c6-c6020834b5be


# ╔═╡ dbfbc375-b08d-4286-b29a-3079c16a53fc
let
pp0= plot(d00.Age, d00.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")
pp1= plot!(d11.Age, d11.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")
pp2= plot!(d22.Age, d22.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")
pp3= plot!(d33.Age, d33.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")

end

# ╔═╡ b6f85a1e-ca77-41a6-99b4-66e005a94d87
cor_Height_DBH= cor( f1.TreeHt,f1.DBH)

# ╔═╡ 3b70ac99-2720-4186-a7fc-0effb61954b3
plot(f1.DBH, f1.TreeHt, st= [:scatter],xlabel= "DBH", ylabel= "Tree Height", m="green")

# ╔═╡ Cell order:
# ╠═8094d2de-2b98-11ec-168c-ad337353816e
# ╟─530b993b-91fd-4df3-8e22-24b1a4dcb1b3
# ╠═d395f941-8e03-45bd-86f3-2b62c9b1cfb7
# ╠═34eff784-5cb0-4b18-ae3f-ff06e4d411a3
# ╠═cb2e3ccd-a42d-4dc1-8a16-a0275ec577a6
# ╠═6c089f49-1048-4988-a518-fe7484d03d96
# ╠═513a1c66-1bae-4d45-8875-9b0485d25ab6
# ╠═4fd11e5c-b5b3-4e6a-af96-356f37536c47
# ╠═af0fb015-3177-4e4b-9a3f-df2cab478a46
# ╠═84a11511-74cd-405b-a6e7-38ec5473b4bb
# ╠═0516b9be-3949-436a-8d18-70caba8501a6
# ╠═b36c283b-88ce-47fb-8719-bced4010d1b9
# ╠═ca79e188-6d7b-4fba-91cd-b001c4ee5326
# ╠═0ab1fe62-b4f0-4ae2-bab1-e7cb73785303
# ╠═b0a8a96a-2790-473a-b358-5cbc24259b45
# ╠═7fed0222-6be8-4b9c-b174-627850b378b9
# ╠═a2eb0ae5-7d93-48e7-b68e-fb99659ced9e
# ╠═9bb69d71-fe1b-4789-b46a-1106b5b85e7a
# ╠═bcbda324-ab43-4132-aed0-7f515ef0c5b4
# ╠═cfe0e2b8-216e-478d-baca-9d97d4d3d586
# ╠═f670545d-4e78-43da-8c06-dc625e0bfc40
# ╠═617f6443-82f6-4afc-acad-7c870009f0e8
# ╠═aa54e530-320c-411c-aed0-7f39fb265027
# ╠═2574b548-afb7-4fa7-9b5f-43d0eb05a66a
# ╠═4dd49d7a-7b27-40c2-ac37-c5120076b965
# ╠═51864f4b-6cb9-420b-b823-92a54d681a3c
# ╠═740d735e-8b82-4a78-97ab-c1166196ab05
# ╠═358fdd32-98e6-41a5-88a4-2a8593060980
# ╠═d1cbca81-703d-4e5a-84c6-c6020834b5be
# ╠═dbfbc375-b08d-4286-b29a-3079c16a53fc
# ╠═b6f85a1e-ca77-41a6-99b4-66e005a94d87
# ╠═3b70ac99-2720-4186-a7fc-0effb61954b3
