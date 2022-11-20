import Pkg; 
Pkg.add("GLM")

using DataFrames
using Plots
using CSV
using Random
using Flux
using Flux: train!
using GLM


data = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
df = select(data,["DBH", "TreeHt", "Age", "CrnBase"])
dff = filter(x -> (x.DBH != -1) && (x.Age != -1) && (x.TreeHt != -1) && (x.CrnBase != -1), df)
dff = shuffle(dff)

#########################################################################################
# Method 1: one input variable one output variable

# Change x to test prediction accuracy of different variables of interest (i.e., DBH, tree height)
x = Vector(dff.DBH)
y = Vector(dff.TreeHt)

# GOAL: TRY USING MULTIPLE INDEPENDENT INPUT VARIABLES IN NEURAL NET

#= function partitionTrainTest(data, at = 0.5)
    n = nrow(data)
    idx = shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, at*n))
    test_idx = view(idx, (floor(Int, at*n)+1):n)
    data[train_idx,:], data[test_idx,:]
end

using RDatasets
# dff = dataset("datasets", "iris")
x_train,x_test = partitionTrainTest(dff.DBH, 0.5) # 50% train
y_train,y_test = partitionTrainTest(dff.Age, 0.5) # 50% train
 =#

x_train, x_test = x[1:6276], x[6277:end] # 50% of data as training, 50% as test, start with just one input
y_train, y_test = rand(length(x_train)), y[6277:end] # set training y data as dummy, but testing y data as actual

#println(x_train)
#println(y_train)

#plot(x_train, y_train, title="Simple linear regression model", label="Train data", seriestype = :scatter)
#plot!(x_test, y_test, label="Test data", seriestype = :scatter)

reduce(hcat, x_train)

function reshape_data(X, y) # Flux expects the data as a 1x#elements array. Use the hcat (horizontal concatenation) and the reduce (high order function) functions to obtain the correct shape.
    X = reduce(hcat, X)
    y = reduce(hcat, y)
    return X, y    
end 

x_train, y_train = reshape_data(x_train, y_train)
x_test, y_test = reshape_data(x_test, y_test)


# Create a simple linear regression model m(x) = W*x + b. 
model = Dense(size(x_train,1), 1, σ) # Implements the function σ(Wx+b) where W and b are the weights and biases. σ is an activation function
println(model)

# Before we move on, we need to collect all of the parameters so we can access and update them during the training steps. We do this with the params function.
ps = Flux.params(model)

# Measure the predictions that our model makes so we can determine how good they are.
loss(x, y) = Flux.Losses.mse(model(x), y)

# Set the optimisation routine (optimiser) that we’ll use to train our model. This optimiser will optimise the loss function by updating parameters in our model.
opt = Descent()

# Before we train our model, we compute the predictions and the current loss to compare with the final results
pred_0 = model(x_train)
println(pred_0)

loss_0 = loss(model(x_train), y_train)
println(loss_0)


# Train the Model
data = [(x_train, y_train)]

# Execute the train steps (epochs) until the W and b parameters minimize the loss function.
n_epochs = 12

for epoch in 1:n_epochs
    train!(loss, ps, data, opt)
    println(loss(model(x_test), y_test))
end


pred_1 = model(x_test)
println(pred_1)

RSME = (round((sum(((y_test) .- model(x_test)).^2) / length((y_test)))^0.5, digits=1) )
#~ RSME = 38 for CrnBase --> Age... because of model structure or poor correlation between variables?
#~ RSME = 13.2 for DBH --> TreeHt... because of model structure or poor correlation between variables?

Accuracy = sum(abs.(pred_1 .- y_test) ./ y_test)/length(y_test)
#~ Acc = 0.88 for DBH --> TreeHt

#Rsq = r2(model)

#=plot(x_train, y_train, title="Simple linear regression model using Flux", label="Train data", seriestype = :scatter)
plot!(x_test, y_test, label="Test data", seriestype = :scatter)
plot!(x_test, pred_0, label="Initial predictions")
plot!(x_test, pred_1, label="Final predictions")
=#



############################################################################################
# RUN SEPARATELY, REFRESH WORKSPACE
# Method 2: multiple input variables, one output variable

data = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
df = select(data,["DBH", "TreeHt", "Age", "CrnBase", "CrnHt", "AvgCdia", "Leaf"])
dff = filter(x -> (x.DBH != -1) && (x.Age != -1) && (x.TreeHt != -1) && (x.CrnBase != -1) && (x.CrnHt != -1) && (x.AvgCdia != -1) && (x.Leaf != -1), df)
dff = shuffle(dff)


x = Matrix(select(data,["TreeHt", "Age", "CrnBase", "CrnHt", "AvgCdia", "Leaf"]))
y = Vector(dff.DBH)
typeof(x)

# GOAL: TRY USING MULTIPLE INDEPENDENT INPUT VARIABLES IN NEURAL NET

#= function partitionTrainTest(data, at = 0.5)
    n = nrow(data)
    idx = shuffle(1:n)
    train_idx = view(idx, 1:floor(Int, at*n))
    test_idx = view(idx, (floor(Int, at*n)+1):n)
    data[train_idx,:], data[test_idx,:]
end

using RDatasets
# dff = dataset("datasets", "iris")
x_train,x_test = partitionTrainTest(dff.DBH, 0.5) # 50% train
y_train,y_test = partitionTrainTest(dff.Age, 0.5) # 50% train
 =#

x_train, x_test = x[1:5624,:], x[5625:end,:] # 50% of data as training, 50% as test, start with just one input
y_train, y_test = rand(size(x_train,1)), y[5625:end] # set training y data as dummy, but testing y data as actual

#println(x_train)
#println(y_train)

#plot(x_train, y_train, title="Simple linear regression model", label="Train data", seriestype = :scatter)
#plot!(x_test, y_test, label="Test data", seriestype = :scatter)

reduce(hcat, x_train)

function reshape_data(X, y) # Flux expects the data as a 1x#elements array. Use the hcat (horizontal concatenation) and the reduce (high order function) functions to obtain the correct shape.
    X = reduce(hcat, X)
    y = reduce(hcat, y)
    return X, y    
end 

x_train, y_train = reshape_data(x_train, y_train)
x_test, y_test = reshape_data(x_test, y_test)


# Create a simple linear regression model m(x) = W*x + b. 
model = Dense(size(x_train,1), 1, σ) # Implements the function σ(Wx+b) where W and b are the weights and biases. σ is an activation function
println(model)

# Before we move on, we need to collect all of the parameters so we can access and update them during the training steps. We do this with the params function.
ps = Flux.params(model)

# Measure the predictions that our model makes so we can determine how good they are.
loss(x, y) = Flux.Losses.mse(model(x), y)

# Set the optimisation routine (optimiser) that we’ll use to train our model. This optimiser will optimise the loss function by updating parameters in our model.
opt = Descent()

# Before we train our model, we compute the predictions and the current loss to compare with the final results
pred_0 = model(x_train)
println(pred_0)

loss_0 = loss(model(x_train), y_train)
println(loss_0)


# Train the Model
data = [(x_train, y_train)]

# Execute the train steps (epochs) until the W and b parameters minimize the loss function.
n_epochs = 12

for epoch in 1:n_epochs
    train!(loss, ps, data, opt)
    println(loss(model(x_test), y_test))
end


pred_1 = model(x_test)
println(pred_1)

RSME = (round((sum(((y_test) .- model(x_test)).^2) / length((y_test)))^0.5, digits=1) )
#~ RSME = 38 for CrnBase --> Age... because of model structure or poor correlation between variables?
#~ RSME = 13.2 for DBH --> TreeHt... because of model structure or poor correlation between variables?

Accuracy = sum(abs.(pred_1 .- y_test) ./ y_test)/length(y_test)
#~ Acc = 0.88 for DBH --> TreeHt

#Rsq = r2(model)

#=plot(x_train, y_train, title="Simple linear regression model using Flux", label="Train data", seriestype = :scatter)
plot!(x_test, y_test, label="Test data", seriestype = :scatter)
plot!(x_test, pred_0, label="Initial predictions")
plot!(x_test, pred_1, label="Final predictions")
=#





############################################################################################
# RUN SEPARATELY, REFRESH WORKSPACE
# Method 3: multiple input variables, one output variable: logistic regression and softmax (classification)