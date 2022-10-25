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

# ╔═╡ 675f7ffd-60b8-4f02-a354-2743dacf4f3d
@bind f PlutoUI.FilePicker() # pick a csv file


# ╔═╡ 8bfb61ac-e331-4d17-8f03-e36b8f13e67c
df = UInt8.(f["data"]) |> IOBuffer |> CSV.File |> DataFrame

# ╔═╡ 14fd160c-828c-4c9f-a3ca-066e3242eab3
a1 = select(df, ["City", "CommonName", "Age", "TreeHt (m)", "Setback"])

# ╔═╡ acd57e26-4d4c-46a0-ab1d-677d1b3b1900
F_setback = filter(row -> row.Setback > 0, a1)

# ╔═╡ 00abefc7-8880-45d8-a1ae-644586a3a238


# ╔═╡ 05e3e117-b625-43d7-902e-00de5d8178fa
gdf1 = groupby(F_setback, :City)

# ╔═╡ 18314519-174c-46c2-a028-9e34e7adc91b
a2 = combine(gdf1, :Setback => mean) #Albuquerque, Glendale, Charlotte, Longview have the highest setback
#Queens, Claremont, Berkeley, Indianapolis have the lowest setback

# ╔═╡ 4200d91d-b405-46da-93d4-2b275811b110
plot1 = bar(a2.City, a2.Setback_mean, title="Mean setback across locations", lab= "Mean Setback", size = (1600,1000))

# ╔═╡ 902c1c45-c193-4be4-8658-d569bf9b3821
savefig(plot1,"plot1.png")

# ╔═╡ 5305f24d-305a-4bf3-976b-2c123381b514
png(plot1, "Plot1")

# ╔═╡ 7fbbdc3c-5c00-4591-881c-abc2c0f3058c
#Compare the change in tree heights of the 4 cities for similar trees and the effect on their heights

# ╔═╡ 305d897f-2814-4d42-81e8-1b701deff481
a1

# ╔═╡ 496b6e74-2dc6-49ec-8653-4343c12c1b13
gdff = filter(row -> row.Setback > 0 && row.City == "Albuquerque, NM",a1)

# ╔═╡ cc16457f-1dd2-4b02-bc66-8287d0e5bbd5
gdff1 = groupby(gdff, :CommonName)

# ╔═╡ b77f8f5d-3993-4f88-ae91-e87c5e0049bf
albu_species_setback = combine(gdff1, :Setback => mean)

# ╔═╡ 176be898-ac03-42ae-8c4a-58554985dd7d
bar(albu_species_setback.CommonName, albu_species_setback.Setback_mean, size(1500,1000), Title = "Mean setback across different regions")

# ╔═╡ c161751f-0f75-46a9-8c27-41af75f5c28c
bar(albu_species_setback.CommonName, albu_species_setback.Setback_mean, size(2500,1000), Title = "Mean setback across different regions")

# ╔═╡ 0665ad7f-f6eb-4266-8a84-90fe91077fd1
Glen = filter(row -> row.Setback > 0 && row.City == "Glendale, AZ",a1)

# ╔═╡ 0480ef6f-2fd0-4cc2-bbe2-3139e74fed6b
begin
Glen2 = groupby(Glen, :CommonName)
glen_species_setback = combine(Glen2, :Setback => mean)
end

# ╔═╡ 95fec536-459f-4013-b018-eca2966841d0
begin
	queens1 = filter(row -> row.Setback > 0 && row.City == "Queens, NY",a1)
	queens2 = groupby(queens1, :CommonName)
	queens_species_setback = combine(queens2, :Setback => mean)
end

# ╔═╡ 72919b40-8812-428b-8b36-97413069c06a
begin
	clare1 = filter(row -> row.Setback > 0 && row.City == "Claremont, CA",a1)
	clare2 = groupby(clare1, :CommonName)
	clare_species_setback = combine(clare2, :Setback => mean)
end

# ╔═╡ 3e277bf0-30bd-4632-b2b7-d3d5f9322387
arr1 = Vector(glen_species_setback.CommonName)

# ╔═╡ 4ace5201-7f94-4856-a14c-f2c53f050d7f
arr2 = Vector(queens_species_setback.CommonName)

# ╔═╡ 923321ae-804a-47f9-bac5-73c687640f97
arr3 = Vector(albu_species_setback.CommonName)

# ╔═╡ 2cc8f8c5-4f0a-4db3-8af1-72f7d53eaa13
arr4 = Vector(clare_species_setback.CommonName)

# ╔═╡ ecc563ab-2639-45a9-80a9-a98585f029d0
typeof(arr1)

# ╔═╡ 2418f9fe-25c9-48a3-b49f-8ae438925e58
begin
for i in 1:length(arr3)
if arr3[i] == arr4[1:end]
	print(arr3[i])
else print("Nada")
end
end
end

# ╔═╡ 271e54db-1408-401a-b5ea-196401f011c9
begin
	char1 = filter(row -> row.Setback > 0 && row.City == "Charlotte, NC",a1)
	char2 = groupby(char1, :CommonName)
	char_species_setback = combine(char2, :Setback => mean)
	long1 = filter(row -> row.Setback > 0 && row.City == "Longview, WA",a1)
	long2 = groupby(long1, :CommonName)
	long_species_setback = combine(long2, :Setback => mean)
	berk1 = filter(row -> row.Setback > 0 && row.City == "Berkeley, CA",a1)
	berk2 = groupby(berk1, :CommonName)
	berk_species_setback = combine(berk2, :Setback => mean)
	ind1 = filter(row -> row.Setback > 0 && row.City == "Indianapolis, IN",a1)
	ind2 = groupby(ind1, :CommonName)
	ind_species_setback = combine(ind2, :Setback => mean)
	
end

# ╔═╡ b2aa847d-9c8e-4470-ab2a-fb8634ab5774
begin 
arr5 = Vector(char_species_setback.CommonName)
arr6 = Vector(long_species_setback.CommonName)
arr7 = Vector(berk_species_setback.CommonName)
arr8 = Vector(ind_species_setback.CommonName)
end

# ╔═╡ 050f5a2a-433d-4b75-8034-92134426e0e3
function similarity(a,b)
for i in 1:length(a)
if a[i] == b[1:end]
	print(a[i])
end
end
	print("No correlation")
end

# ╔═╡ a97077f0-87b6-4ca6-85df-d3d3e225b796
begin 
similarity(arr1,arr2)
similarity(arr1,arr4)
similarity(arr1,arr7)
similarity(arr1,arr8)
end

# ╔═╡ 001aa774-79de-4735-a606-76f2dcb900e2
begin 
similarity(arr3,arr2)
similarity(arr3,arr4)
similarity(arr3,arr7)
similarity(arr3,arr8)
end

# ╔═╡ 333e2926-758d-4245-8341-7504ea9c59c4
begin 
similarity(arr5,arr2)
similarity(arr5,arr4)
similarity(arr5,arr7)
similarity(arr5,arr8)
end

# ╔═╡ d6de5602-42ba-46c9-9862-a5564c1e803e
begin 
similarity(arr6,arr2) 
similarity(arr6,arr4)
similarity(arr6,arr7)
similarity(arr6,arr8)
end

# ╔═╡ 55a20b0a-3999-4e0a-804c-a16929e2890d
char3 = filter(x -> x.CommonName == "River birch" && x.Setback >= 3 && x.Age == 15,char1)


# ╔═╡ 079658db-84ea-4ed5-9c61-210a0cddd491
tree = select(char3, ["TreeHt (m)"])

# ╔═╡ 601bf560-1936-4916-98cb-834f61421f60
char3.NewColumn = [17.0,13.0,12.0,10.0,19.0,6.5,13.0,9.0]

# ╔═╡ 68243c1a-1cde-4a2d-b2e2-0e4e4dda9d65
char3

# ╔═╡ 36513931-2f8b-4d1c-affd-63a53413a5b4
mean_ht_setback3 = mean([13,19])

# ╔═╡ 52392290-0e2e-4df7-adf9-de08a309e93b
mean_ht_setback4 = mean([17.0,12.0,10.0,6.5,13.0,9.0])

# ╔═╡ 51fecca7-a686-446f-87dc-b0b7431b6275


# ╔═╡ cc88460e-ce0d-4734-af5e-b552ad6ee726
plot(char3.Setback, char3.NewColumn, st=[:scatter,:scatter])

# ╔═╡ ebc32bf3-b7a3-4e63-95e8-ec08cb72d8b4
begin
char4 = filter(x -> x.CommonName == "Silver maple" && x.Setback >= 0 && x.Age == 35, char1)
char4.Ht = [20.0,22,15,17,24,17.5,21.5,18,20]
char4
end

# ╔═╡ 501dce00-8225-49f4-9cd4-eac66a163945
chargdf1, chargdf2 = groupby(char4, :Setback)

# ╔═╡ 9f97fc9b-6d36-4ec4-9b14-b5cf968ca5c8
plot(char4.Setback, char4.Ht, st=[:bar,:scatter])

# ╔═╡ bfe21c24-5031-4384-88ab-cf1425e7d792
chargdf1, chargdf2

# ╔═╡ 1d704b5d-b11c-429e-b2cc-509d75460353
mean_ht_maple_setback2 = mean([20,15,17.5,20])

# ╔═╡ 3fd870c5-2b1d-4d23-9a11-acaf22b712ff
mean_ht_maple_setback3 = mean([22,17,24,21.5,18])

# ╔═╡ 6268d028-2885-4c2b-bc13-78b0734c986a


# ╔═╡ Cell order:
# ╠═8094d2de-2b98-11ec-168c-ad337353816e
# ╟─675f7ffd-60b8-4f02-a354-2743dacf4f3d
# ╠═8bfb61ac-e331-4d17-8f03-e36b8f13e67c
# ╠═14fd160c-828c-4c9f-a3ca-066e3242eab3
# ╠═acd57e26-4d4c-46a0-ab1d-677d1b3b1900
# ╠═00abefc7-8880-45d8-a1ae-644586a3a238
# ╠═05e3e117-b625-43d7-902e-00de5d8178fa
# ╠═18314519-174c-46c2-a028-9e34e7adc91b
# ╠═4200d91d-b405-46da-93d4-2b275811b110
# ╠═902c1c45-c193-4be4-8658-d569bf9b3821
# ╠═5305f24d-305a-4bf3-976b-2c123381b514
# ╠═ce946ba8-d3cf-4c46-a6b2-f443379a960a
# ╠═7fbbdc3c-5c00-4591-881c-abc2c0f3058c
# ╠═305d897f-2814-4d42-81e8-1b701deff481
# ╠═496b6e74-2dc6-49ec-8653-4343c12c1b13
# ╠═cc16457f-1dd2-4b02-bc66-8287d0e5bbd5
# ╠═b77f8f5d-3993-4f88-ae91-e87c5e0049bf
# ╠═176be898-ac03-42ae-8c4a-58554985dd7d
# ╠═c161751f-0f75-46a9-8c27-41af75f5c28c
# ╠═0665ad7f-f6eb-4266-8a84-90fe91077fd1
# ╠═0480ef6f-2fd0-4cc2-bbe2-3139e74fed6b
# ╠═95fec536-459f-4013-b018-eca2966841d0
# ╠═72919b40-8812-428b-8b36-97413069c06a
# ╠═3e277bf0-30bd-4632-b2b7-d3d5f9322387
# ╠═4ace5201-7f94-4856-a14c-f2c53f050d7f
# ╠═923321ae-804a-47f9-bac5-73c687640f97
# ╠═2cc8f8c5-4f0a-4db3-8af1-72f7d53eaa13
# ╠═ecc563ab-2639-45a9-80a9-a98585f029d0
# ╠═2418f9fe-25c9-48a3-b49f-8ae438925e58
# ╠═271e54db-1408-401a-b5ea-196401f011c9
# ╠═b2aa847d-9c8e-4470-ab2a-fb8634ab5774
# ╠═050f5a2a-433d-4b75-8034-92134426e0e3
# ╠═a97077f0-87b6-4ca6-85df-d3d3e225b796
# ╠═001aa774-79de-4735-a606-76f2dcb900e2
# ╠═333e2926-758d-4245-8341-7504ea9c59c4
# ╠═d6de5602-42ba-46c9-9862-a5564c1e803e
# ╠═55a20b0a-3999-4e0a-804c-a16929e2890d
# ╠═079658db-84ea-4ed5-9c61-210a0cddd491
# ╠═601bf560-1936-4916-98cb-834f61421f60
# ╠═68243c1a-1cde-4a2d-b2e2-0e4e4dda9d65
# ╠═36513931-2f8b-4d1c-affd-63a53413a5b4
# ╠═52392290-0e2e-4df7-adf9-de08a309e93b
# ╠═51fecca7-a686-446f-87dc-b0b7431b6275
# ╠═cc88460e-ce0d-4734-af5e-b552ad6ee726
# ╠═ebc32bf3-b7a3-4e63-95e8-ec08cb72d8b4
# ╠═501dce00-8225-49f4-9cd4-eac66a163945
# ╠═9f97fc9b-6d36-4ec4-9b14-b5cf968ca5c8
# ╠═bfe21c24-5031-4384-88ab-cf1425e7d792
# ╠═1d704b5d-b11c-429e-b2cc-509d75460353
# ╠═3fd870c5-2b1d-4d23-9a11-acaf22b712ff
# ╠═6268d028-2885-4c2b-bc13-78b0734c986a