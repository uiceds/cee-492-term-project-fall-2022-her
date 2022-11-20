#import Pkg; 
#Pkg.add("ProgressLogging")
#Pkg.add("MLUtils")
#Pkg.add("LinearAlgebra")

using PlutoUI
using CSV
using DataFrames
using Plots
using Statistics
using LinearAlgebra
using ProgressLogging
using Flux
using MLUtils



	x0 = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
    x1 = select(x0,["CommonName", "Age", "DBH", "TreeHt", "CrnBase", "CrnHt", "CdiaPar", "CDiaPerp", "AvgCdia", "Leaf"])
    x2 = filter(x1 -> (x1.Age != -1) && (x1.DBH != -1) && (x1.TreeHt != -1) && (x1.CrnBase != -1) && (x1.CrnHt != -1) && (x1.CdiaPar != -1) && (x1.CDiaPerp != -1) && (x1.AvgCdia != -1) && (x1.Leaf != -1), x1)
    x3 = select(x2, Not(["CommonName"]))
    x4 = transpose(Matrix(x3))
    x = reshape(x4, size(x4, 1), 1, size(x4,2))

#println(x)

    y1 = select(x2,["CommonName"])
    #println(y1)
    y2 = unique(y1)
    #println(y2)
    y2 = DataFrame(ID = 1:157, CommonName = y2.CommonName) #create new row of IDs

    id_to_names = Dict(Pair.(y2.ID, y2.CommonName))
    names_to_id = Dict(v => k for (k, v) in id_to_names)
    id_to_names[3] #test it works
    names_to_id["sweetgum"] #test it works

    #y_test = (keys(names_to_id[name]) for name in y1) #not working, trying to write each species name in the original dataframe of species y1 to an ID
    
    for (name, row) in enumerate(eachrow(y1))
        collect(keys(names_to_id[name]))    
    end
    #yID = collect(keys(d)) # d needs to be a dictionary, trying to create one from y_test data frame, but Base.Generator data frame type is prohibiting.

    y1 = transpose((y1))
	y = Flux.onehotbatch(y1, 0:9)


let
	plots = []
	for i in 1:16
		# We can convert the one-hot labels back into the category numbers using the 
		# 'onecold' command.
		p = plot(x[:, 1, i],1:size(x,1), title=Flux.onecold(y[:, i])-1, 
			label=:none, titlefontsize=9)
		push!(plots, p)
	end
	plot(plots..., size=(650, 650))
end

# Neural Network Model
model = Chain(
   	Conv((5,), 1 => 5, pad=(1,), relu),
	Conv((3,), 5 => 7, pad=(1,), relu),
	Conv((7,), 7 => 15, pad=(1,), relu), 
	Conv((5,), 15 => 7, pad=(1,), relu),
	Conv((3,), 7 => 5, pad=(1,), relu),
	x -> reshape(x, :, size(x,3)),
	#x -> maxpool(x, (2,2)),
	Dense(160, 80),
	Dense(80, 10),
	softmax,
)

accuracy(ŷ, y) = mean(Flux.onecold(ŷ) .== Flux.onecold(y))
# Accuracy before training
accuracy(model(x), y)

function loss(x, y) 
	Flux.Losses.crossentropy(model(x),y)
end


begin
	batchsize = 100
	epochs = 125
	η = 0.001
end;

begin
	data = Flux.DataLoader((x, y), batchsize=batchsize);
	loss_hist=zeros(epochs)
	accuracy_hist=zeros(epochs)
	for epoch ∈ 1:epochs
		Flux.train!(loss, Flux.params(model), data, Adam(η))
		a = accuracy(model(x), y)
		l = loss(x, y)
		@info "epoch $(epoch); acc=$(round(a, digits=2))"
		loss_hist[epoch] = l
		accuracy_hist[epoch] = a
	end
end

# Accuracy after training
accuracy(model(x), y)


let
	p1 = plot(loss_hist, title="Loss", label=:none, xlabel="Training step × 1000")
	p2 = plot(accuracy_hist, title="Accuracy", label=:none)
	p3 = confusion_plot(Flux.onecold(model(x)), Flux.onecold(y))
	plot(p1, p2, p3, layout=(2,2), size=(800, 700))
end

confusion_plot(ŷ, y; kwargs...) = heatmap(sort(unique(y)), sort(unique(y)), 
	[sum((ŷ .== i) .& (y .== j)) for i=unique(y), j=unique(y)],
	xlabel="y", ylabel="ŷ", size=(400, 300), colorbartitle="Count"; kwargs...)