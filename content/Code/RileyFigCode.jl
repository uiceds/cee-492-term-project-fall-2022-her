### A Pluto.jl notebook ###
# v0.19.13

using Markdown
using InteractiveUtils

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
	using DataFrames
	using RDatasets
	using Statistics
	using StatsPlots
	using CSV
	using StatsBase
end

# ╔═╡ dc49dea1-047e-4dd1-a44a-9d2a638426b9
@bind f PlutoUI.FilePicker()

# ╔═╡ 5a370b55-c90f-4cb8-9c08-27ded9dc823b

df = UInt8.(f["data"])|>CSV.File|>DataFrame
# remove zero values

# ╔═╡ 5325024b-65b4-4f4d-89c0-7202fb166fd6
begin
	div1=select(df,[:City,:CommonName, :Age, :TreeHt])
	div2=filter((x -> x.Age>0), div1)
	Modesto7=filter(x->x.City == "Modesto, CA",div2)
	Modesto17=filter(x->x.CommonName =="European white birch", Modesto7)
	div3=Modesto17[!,4]./Modesto17[!,3]
	Long7=filter(x->x.City == "Longview, WA",div2)
	Long17=filter(x->x.CommonName =="European white birch", Long7)
	div4=Long17[!,4]./Long17[!,3]
end

# ╔═╡ 59fe0a6a-c74b-4ede-967e-7c727c01108e
mean(div3)

# ╔═╡ 85788371-e5e3-466b-960a-12dd2bb5c954
begin
	plot(div4, label= "Longview, WA")
	plot!(div3, xaxis="Number", yaxis="Growth Rate", Title="European White Birch Growth Rate", label="Modesto, CA")

end


# ╔═╡ 4ea1cdb0-371c-4841-b0a5-32758af0c447
begin
	dfwork3=select(df,[:City,:CommonName, :Age, :TreeHt])
	df4=filter((x -> x.Age>0), dfwork3)
	Modesto3=filter(x->x.City == "Modesto, CA",df4)
	Modesto13=filter(x->x.CommonName =="cherry plum", Modesto3)
	
	Long3=filter(x->x.City == "Longview, WA",df4)
	Long13=filter(x->x.CommonName =="Cherry plum", Long3)
	
	plot(
	Long13[!,3],Long13[!,4], seriestype= :scatter, label= "Longview, WA", xaxis="Age", yaxis="Height", title="Cherry Plum")
	plot!(Modesto13[!,3],Modesto13[!,4], seriestype= :scatter, label="Modesto, CA")
end

# ╔═╡ 24fd1c11-5cc5-4883-8ec8-8f22818328ad
begin
	dfwork=select(df,[:City,:CommonName, :Age, :TreeHt])
	df1=filter((x -> x.Age>0), dfwork)
	Modesto=filter(x->x.City == "Modesto, CA",df1)
	Modesto1=filter(x->x.CommonName =="European white birch", Modesto)
	
	Long=filter(x->x.City == "Longview, WA",df1)
	Long1=filter(x->x.CommonName =="European white birch", Long)
	
	plot(
	Long1[!,3],Long1[!,4], seriestype= :scatter, label= "Longview, WA", xaxis="Age", yaxis="Height", title="European White Birch")
	plot!(Modesto1[!,3],Modesto1[!,4], seriestype= :scatter, label="Modesto, CA")
end

# ╔═╡ 05575eac-3b83-4125-bdcc-a64154f68cf5
begin
	dfwork2=select(df,[:City,:CommonName, :Age, :TreeHt])
	df12=filter((x -> x.Age>0), dfwork2)
	Modesto2=filter(x->x.City == "Modesto, CA",df12)
	Modesto12=filter(x->x.CommonName =="sweetgum", Modesto2)
	
	Long2=filter(x->x.City == "Longview, WA",df12)
	Long12=filter(x->x.CommonName =="Sweetgum", Long2)
	
	plot(Long12[!,3],Long12[!,4], seriestype= :scatter, label= "Longview, WA", xaxis="Age", yaxis="Height",title="Sweetgum")
	plot!(Modesto12[!,3],Modesto12[!,4], seriestype= :scatter, label="Modesto, CA")
end

# ╔═╡ 1074752e-df3f-4ee0-b5d4-cf878560524e
df2=groupby(df1, :City)

# ╔═╡ 9dd7f3d1-1c6e-4667-a9ca-6f1a9e79b80a
MeanAgeByCity=combine(df2,:Age => mean)

# ╔═╡ 2e552376-87ac-46bc-a847-f6265450e187
MeanAgeByCityMat=Matrix(MeanAgeByCity)

# ╔═╡ 4bfbbaeb-8967-4d67-a133-ccf674e841f6
MeanHeightByCity=combine(df2,:TreeHt => mean)

# ╔═╡ 6a047b30-324f-41e7-a04c-af9b6ab49ba0
MeanHeightByCityMat=Matrix(MeanHeightByCity)

# ╔═╡ 15e083d9-7d91-4363-b2ff-7b9868d94c6f
bar(MeanAgeByCityMat[:,1],MeanAgeByCityMat[:,2], xlabel="Cities", ylabel=" Mean Tree Age", Title= "Mean Tree Age By City",size=(1000,300), color="red")#, xticks=["Modesto,CA","Santa Monica, CA","Claremont, CA","Berkeley, CA","Glendale, AZ", "Fort Collins, CO","Minneapolis, MN"])

# ╔═╡ ee0fb0c2-2cc6-4e11-bfc4-352af9acab39
bar(MeanHeightByCityMat[:,1],MeanHeightByCityMat[:,2], xlabel="Cities", ylabel=" Mean Tree Height", Title= "Mean Tree Height by City",size=(1000,300), color="red")#png

# ╔═╡ cf38ebf9-cd34-4ca3-bd00-3284367c1efb
scatter(MeanHeightByCityMat[:,2],MeanAgeByCityMat[:,2],xlabel="Mean Tree Height", ylabel="Mean Tree Age")

# ╔═╡ 185d85d9-47a8-4d3a-ae0c-e86e2dafff95
df3=groupby(df1, [:CommonName,:City, :Age])
#use filter

# ╔═╡ 5a982224-c839-4a5a-9edc-58c66be99897
TreeType=combine(df3,:Age=> ==(10))

# ╔═╡ Cell order:
# ╠═8094d2de-2b98-11ec-168c-ad337353816e
# ╠═dc49dea1-047e-4dd1-a44a-9d2a638426b9
# ╠═5a370b55-c90f-4cb8-9c08-27ded9dc823b
# ╠═5325024b-65b4-4f4d-89c0-7202fb166fd6
# ╠═59fe0a6a-c74b-4ede-967e-7c727c01108e
# ╠═85788371-e5e3-466b-960a-12dd2bb5c954
# ╠═4ea1cdb0-371c-4841-b0a5-32758af0c447
# ╠═24fd1c11-5cc5-4883-8ec8-8f22818328ad
# ╠═05575eac-3b83-4125-bdcc-a64154f68cf5
# ╠═1074752e-df3f-4ee0-b5d4-cf878560524e
# ╠═9dd7f3d1-1c6e-4667-a9ca-6f1a9e79b80a
# ╠═2e552376-87ac-46bc-a847-f6265450e187
# ╠═4bfbbaeb-8967-4d67-a133-ccf674e841f6
# ╠═6a047b30-324f-41e7-a04c-af9b6ab49ba0
# ╠═15e083d9-7d91-4363-b2ff-7b9868d94c6f
# ╠═ee0fb0c2-2cc6-4e11-bfc4-352af9acab39
# ╠═cf38ebf9-cd34-4ca3-bd00-3284367c1efb
# ╠═185d85d9-47a8-4d3a-ae0c-e86e2dafff95
# ╠═5a982224-c839-4a5a-9edc-58c66be99897