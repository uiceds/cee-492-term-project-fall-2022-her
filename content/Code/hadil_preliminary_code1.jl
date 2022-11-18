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
		import Pkg; Pkg.add("GLM")
	end
	
	using PlutoUI
	using CSV
	using DataFrames
	using StatsPlots
	using Plots
	using Statistics
	using GLM
	using Random
end

# ╔═╡ 530b993b-91fd-4df3-8e22-24b1a4dcb1b3
md"""
You can load a CSV file below by clicking "Choose file" and uploading a CSV file. The file will be saved to the current directory so you don't have to re-upload it every time you start the workspace.
"""

# ╔═╡ d395f941-8e03-45bd-86f3-2b62c9b1cfb7
@bind f PlutoUI.FilePicker() # pick a csv file

# ╔═╡ 34eff784-5cb0-4b18-ae3f-ff06e4d411a3
let
	file = UInt8.(f["data"]) |> IOBuffer |> CSV.File
	CSV.write(f["name"], file)
end

# ╔═╡ b2cc41e2-a16d-4021-bedd-1fd6ee1deeb7
md"""
The next cell shows the files in the current directory. Any files you have uploaded should be included there.
"""

# ╔═╡ c47eb91b-bad1-48e8-9a75-47bc000b22f2
readdir()

# ╔═╡ 5c9b255d-5fa3-4fdf-b5e1-c079494ea240
md"""
This next cell loads the previously saved file. You can replace `f["name"]` with the actual name of the file to avoid having to upload the file again.
"""

# ╔═╡ 90da7931-3477-4c8f-9bef-2d8b861f49d1
df = CSV.read(f["name"], DataFrame)

# ╔═╡ d4b36280-333a-44a7-bdeb-399565c05d65
f1= filter(x -> (x.TreeHt !=-1) && (x.Age !=-1) && (x.DBH !=-1), df)

# ╔═╡ 04a630b5-4d57-4cb9-a8a6-7816f1413a8e
g1= groupby(f1,:Age)

# ╔═╡ 85871ea7-fcb7-4d0f-a3c7-9e679a66a2a0
c1= combine(g1,:DBH=>mean)

# ╔═╡ a2534ef1-2a66-4ea8-ac4e-f7537a472b7a
p0= plot(c1.Age, c1.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")

# ╔═╡ a70f19f6-da01-435e-b1c4-f871d8be23d5
cor_age_avgdbh= round.(cor(c1.Age, c1.DBH_mean), digits=3)

# ╔═╡ c06c2970-2373-4484-9870-b87ce4f6c40c
model1 = lm(@formula(DBH_mean ~ Age), c1)	

# ╔═╡ 7dc9e931-1db3-415a-a84e-540ae2b6fc61
predict1= round.(predict(model1), digits=2)

# ╔═╡ cc223465-5ee2-4093-8858-4031a44e137d
function rmse(ŷ::Vector{T}, y::Vector{T})::T where T<:AbstractFloat
	n = length(y)
	a= (sum((ŷ .-y).^2)/ n)^0.5	
end

# ╔═╡ fcbb2eff-eb18-4c56-9771-4397039471d5
R2_1= round.(r2(model1),digits=2) 

# ╔═╡ 6e6aa025-94e2-4e92-8fed-4e4850edd243
rmse(predict1, c1.DBH_mean)

# ╔═╡ d5ac3963-650f-4570-90e1-d5c0bd748650

let
p1= plot(c1.Age, c1.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH")
p11= plot!(c1.Age, predict1, st= [:scatter])
end

# ╔═╡ 9b2474e6-549a-43fe-b448-a14923e04c0e
ff= filter(x-> (x.Age < 200),c1)

# ╔═╡ 78bfcfe5-0d40-4d03-bf25-b9862a5c86b7
model2 = lm(@formula(DBH_mean ~ Age), ff)

# ╔═╡ c7ea9f86-7daf-4dc5-a68e-ee8d09465b0d
predict2= round.(predict(model2), digits=2)

# ╔═╡ 384b24cf-bccf-4dd0-b334-12de5fe32f9f
rmse(predict2, ff.DBH_mean)

# ╔═╡ 442775e6-cb57-4f86-ab77-2c486f8071be
R2_2= round.(r2(model2),digits=2) 

# ╔═╡ 632169be-4e46-4fdb-aa04-20737add6916
let
p1= plot(ff.Age, ff.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH",label= "Actual",legend = :topleft)
p11= plot!(ff.Age, predict2, st= [:scatter], label= "Predicted",legend = :topleft)
end

# ╔═╡ bccfeff6-dae8-45c6-af2d-731a50dcfc91
function splitdf(df, pct)
           @assert 0 <= pct <= 1
           ids = collect(axes(df, 1))
           shuffle!(ids)
           sel = ids .<= nrow(df) .* pct
           return view(df, sel, :), view(df, .!sel, :)
       end

# ╔═╡ b5c41a82-2629-4686-b217-dc24687edda4
(train,test) = splitdf(ff,0.7)

# ╔═╡ d7655935-c486-49d3-b632-57552a761981
model3= lm(@formula(DBH_mean ~ Age), train)

# ╔═╡ dbab37e5-9a29-4658-8019-e3535bcb92c4
model4= lm(@formula(DBH_mean ~ Age), test)

# ╔═╡ caa8dd93-33c5-4a3a-9d06-ce4494da02da
predict3= round.(predict(model3), digits=2)

# ╔═╡ 092be761-1cb3-46ed-953b-f622b77e1163
R2_3 = round.(r2(model3),digits=2) 

# ╔═╡ 3d85f0dd-ba3f-4c6b-901b-8ccfaf077f63
# Model 2 with 2 independent variables

# ╔═╡ ab47303f-0bc3-4853-8598-730ac454c719
c2= combine(g1,:TreeHt=>mean)

# ╔═╡ 13893e5d-e516-49d3-a411-515f706df5c9
f2= filter(x-> (x.Age < 200),c2)

# ╔═╡ bb97f715-36d4-42fb-bbe9-4f3db4373c00
ff.TreeHt_mean= f2.TreeHt_mean

# ╔═╡ 9ce58f79-62c5-4f20-83bf-357c1455ee56
ff

# ╔═╡ 6f93ec05-ce72-4a86-88d5-5fe8b50e4029
model5= lm(@formula(DBH_mean ~ Age+TreeHt_mean), ff)

# ╔═╡ 32bff0ea-e642-4c66-99bd-99860cbda5e1
predict5 = round.(predict(model5), digits=2)

# ╔═╡ 5e13fc27-22e2-47e5-a23a-99d87747f60e
rmse(predict5, ff.DBH_mean)

# ╔═╡ 9b923eac-ed67-4481-9103-5994f46847c5
R2_5= round.(r2(model5),digits=2) 

# ╔═╡ 55924f61-17bb-432e-9210-6dc8ed607f24
# Model 3, try 3 independent variables (age, average height, leaf area)

# ╔═╡ 3afe3b68-1ab9-4fc5-88ed-eba13a93d442
let
p1= plot(ff.Age, ff.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH", label= "Actual",legend = :topleft)
p11= plot!(ff.Age, predict5, st= [:scatter], label= "Predicted",legend = :topleft)
end

# ╔═╡ 7fee3932-005f-4f8d-83a6-674617c4ea50
c3= combine(g1,:Leaf=>mean)

# ╔═╡ 234bf474-5093-4e03-ad20-0ca568e1d059
f3= filter(x-> (x.Age < 200),c3)

# ╔═╡ f9e552af-c628-48c1-81d0-569dc18e1fd3
ff.Leaf_mean= f3.Leaf_mean

# ╔═╡ 20311a3d-2127-45fe-b78b-d88318bd6666
ff

# ╔═╡ 2dbd0775-1004-45e6-9464-0c0486f24c43
model6= lm(@formula(DBH_mean ~ Age+TreeHt_mean+Leaf_mean), ff)

# ╔═╡ 9a1f4582-b213-4895-a0f7-faecee5d7561
predict6 = round.(predict(model6), digits=2)

# ╔═╡ e65d9a54-35bd-4f9b-80fa-db86df8757fe
rmse(predict6, ff.DBH_mean)

# ╔═╡ 1aca3aa7-8322-42b4-8faf-3b2c06f72d85
R2_6= round.(r2(model6),digits=2) 

# ╔═╡ 3b46d767-5486-4240-9259-ddb04f328729
let
p1= plot(ff.Age, ff.DBH_mean, st= [:scatter],xlabel= "Tree Age", ylabel= "Average DBH", label= "Actual",legend = :topleft)
p11= plot!(ff.Age, predict6, st= [:scatter], label= "Predicted",legend = :topleft)
end

# ╔═╡ Cell order:
# ╠═8094d2de-2b98-11ec-168c-ad337353816e
# ╟─530b993b-91fd-4df3-8e22-24b1a4dcb1b3
# ╠═d395f941-8e03-45bd-86f3-2b62c9b1cfb7
# ╠═34eff784-5cb0-4b18-ae3f-ff06e4d411a3
# ╟─b2cc41e2-a16d-4021-bedd-1fd6ee1deeb7
# ╠═c47eb91b-bad1-48e8-9a75-47bc000b22f2
# ╟─5c9b255d-5fa3-4fdf-b5e1-c079494ea240
# ╠═90da7931-3477-4c8f-9bef-2d8b861f49d1
# ╠═d4b36280-333a-44a7-bdeb-399565c05d65
# ╠═04a630b5-4d57-4cb9-a8a6-7816f1413a8e
# ╠═85871ea7-fcb7-4d0f-a3c7-9e679a66a2a0
# ╠═a2534ef1-2a66-4ea8-ac4e-f7537a472b7a
# ╠═a70f19f6-da01-435e-b1c4-f871d8be23d5
# ╠═c06c2970-2373-4484-9870-b87ce4f6c40c
# ╠═7dc9e931-1db3-415a-a84e-540ae2b6fc61
# ╠═cc223465-5ee2-4093-8858-4031a44e137d
# ╠═fcbb2eff-eb18-4c56-9771-4397039471d5
# ╠═6e6aa025-94e2-4e92-8fed-4e4850edd243
# ╠═d5ac3963-650f-4570-90e1-d5c0bd748650
# ╠═9b2474e6-549a-43fe-b448-a14923e04c0e
# ╠═78bfcfe5-0d40-4d03-bf25-b9862a5c86b7
# ╠═c7ea9f86-7daf-4dc5-a68e-ee8d09465b0d
# ╠═384b24cf-bccf-4dd0-b334-12de5fe32f9f
# ╠═442775e6-cb57-4f86-ab77-2c486f8071be
# ╠═632169be-4e46-4fdb-aa04-20737add6916
# ╠═bccfeff6-dae8-45c6-af2d-731a50dcfc91
# ╠═b5c41a82-2629-4686-b217-dc24687edda4
# ╠═d7655935-c486-49d3-b632-57552a761981
# ╠═dbab37e5-9a29-4658-8019-e3535bcb92c4
# ╠═caa8dd93-33c5-4a3a-9d06-ce4494da02da
# ╠═092be761-1cb3-46ed-953b-f622b77e1163
# ╠═3d85f0dd-ba3f-4c6b-901b-8ccfaf077f63
# ╠═ab47303f-0bc3-4853-8598-730ac454c719
# ╠═13893e5d-e516-49d3-a411-515f706df5c9
# ╠═bb97f715-36d4-42fb-bbe9-4f3db4373c00
# ╠═9ce58f79-62c5-4f20-83bf-357c1455ee56
# ╠═6f93ec05-ce72-4a86-88d5-5fe8b50e4029
# ╠═32bff0ea-e642-4c66-99bd-99860cbda5e1
# ╠═5e13fc27-22e2-47e5-a23a-99d87747f60e
# ╠═9b923eac-ed67-4481-9103-5994f46847c5
# ╠═55924f61-17bb-432e-9210-6dc8ed607f24
# ╠═3afe3b68-1ab9-4fc5-88ed-eba13a93d442
# ╠═7fee3932-005f-4f8d-83a6-674617c4ea50
# ╠═234bf474-5093-4e03-ad20-0ca568e1d059
# ╠═f9e552af-c628-48c1-81d0-569dc18e1fd3
# ╠═20311a3d-2127-45fe-b78b-d88318bd6666
# ╠═2dbd0775-1004-45e6-9464-0c0486f24c43
# ╠═9a1f4582-b213-4895-a0f7-faecee5d7561
# ╠═e65d9a54-35bd-4f9b-80fa-db86df8757fe
# ╠═1aca3aa7-8322-42b4-8faf-3b2c06f72d85
# ╠═3b46d767-5486-4240-9259-ddb04f328729
