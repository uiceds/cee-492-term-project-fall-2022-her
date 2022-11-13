#import Pkg; 
#Pkg.add("Flux")
# Pkg.add("LinearAlgebra")
# Pkg.add("Random")
# Pkg.add("Zygote")
#Pkg.add("StatsAPI")

#using PlutoUI
using DataFrames
using Plots
#using RDatasets
#using Statistics
#using StatsPlots
using CSV
using Random
using Flux
using Flux: train!
#using StatsAPI


data = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
df = select(data,["DBH", "TreeHt", "Age"])
dff = filter(x -> (x.DBH != -1) && (x.Age != -1) && (x.TreeHt != -1), df)
dff = shuffle(dff)

x = Matrix([dff.DBH dff.TreeHt])
y = Vector(dff.Age)

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

x_train, x_test = (x[1:6319,1:2]), x[6319:size(x,1),1:2] # 50% of data as training, 50% as test
y_train, y_test = y[1:6319], y[6319:length(y)]

plot(x_train, y_train, title="Simple linear regression model", label="Train data", seriestype = :scatter)
plot!(x_test, y_test, label="Test data", seriestype = :scatter)



# METHOD 1 # Simple Linear Regression NN Model

reduce(hcat, x_train)

function reshape_data(X, y) # Flux expects the data as a 1x#elements array. use the hcat (horizontal concatenation) and the reduce (high order function) functions to obtain the correct shape.
    X = reduce(hcat, X)
    y = reduce(hcat, y)
    return X, y    
end 


x_train, y_train = reshape_data(x_train, y_train)
x_test, y_test = reshape_data(x_test, y_test)

println(size(x_train))
println(size(x_test))


# Create a simple linear regression model m(x) = W*x + b. To define this type of model, we set a single neuron with no activation function. In Flux, we can use the Dense function to define this model
model = Dense(1, 1) #Implements the function σ(Wx+b) where W and b are the weights and biases. σ is an activation function
# We'll need to train our model so we can find better values for W and b, which are currently randomly defined in Dense.

# Before we move on, we need to collect all of the parameters so we can access and update them during the training steps. We do this with the params function.
ps = Flux.params(model)

# Measure the predictions that our model makes so we can determine how good they are.
loss(x, y) = Flux.Losses.mse(model(x), y)

# Set the optimisation routine (optimiser) that we’ll use to train our model. This optimiser will optimise the loss function
opt = Descent()

predict(x) = model(x)

# Before we train our model, we compute the predictions and the current loss to compare with the final results
pred_0 = predict(x_test)

loss_0 = loss(predict(x_test), y_test)
######################################## Error here. Size of y and yhat are different. What are they supposed to be?

# Train the Model
data = [(x_train, y_train)]
train!(loss, ps, data, opt)

# Execute the train steps (epochs) until the W and b parameters minimize the loss function.
# Set the number of iterations (epochs)
n_epochs = 12

# Run the train routine and output the loss
for epoch in 1:n_epochs
    train!(loss, ps, data, opt)
    println(loss(model(x_test), y_test))
end


pred_1 = model(x_test)

plot(x_train', y_train', title="Simple linear regression model using Flux", label="Train data", seriestype = :scatter)
plot!(x_test', y_test', label="Test data", seriestype = :scatter)
plot!(x_test', pred_0', label="Initial predictions")
plot!(x_test', pred_1', label="Final predictions")





#= # METHOD 2 #

#Error Metric
function mse(ŷ::Vector, y::Vector)
    mean((ŷ .- y).^2)
    end

    function relu(x)
        max(zero(x),x)
        end

        function threelayer_logistic(x, p::Vector) 
        w1, b1, w2, b2, w3, b3 = p
        output1 = relu.(w1*x .+ b1)
        output2 = relu.(w2*output1 .+ b2)
        output3 = w3*output2 .+ b3
        end

        function train!(modelf, errf, p, x, y::Vector,η, nsteps::Int)
            function er(p)
            errf(modelf(x,p)[:],y)
            end
            for i in 1:nsteps
            p -= er'(p) * η
            end
            p
            end

            begin
                inputsize = length(x_train) # number of rows!!!
                hiddensize = 1
                nlabels = 1 # This is the number of dependent variables we want to predict.
                # Initialize weights and biases with random values.
                w1 = rand(hiddensize, inputsize) .- 0.5
                b1 = rand(hiddensize) .- 0.5
                w2 = rand(hiddensize, hiddensize) .- 0.5
                b2 = rand(hiddensize) .- 0.5
                w3 = rand(nlabels, hiddensize) .- 0.5
                b3 = rand(nlabels) .- 0.5
                p = [w1, b1, w2, b2, w3, b3] # Create our vector of parameter objects.
                η = .001 #Learning rate is between 0 to 1
                nsteps = 10000
                p = train!(threelayer_logistic, mse, p, x_train, y_train, η, nsteps)
            end

                function predict_transmission(x::Vector)
                    input = threelayer_logistic(x,p)
                    return vec(input)
                end

                RSME = (round((sum((Vector(y_test) .- predict_transmission(x_test)).^2) / length(Vector(y_test)))^0.5, digits=1) )

 =#


#= # METHOD 3 #

W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
  ŷ = predict(x)
  sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

gs = gradient(() -> loss(x, y), Flux.params(W, b))

W̄ = gs[W]

W .-= 0.1 .* W̄

loss(x, y) # ~ 2.5

function linear(in, out)
    W = randn(out, in)
    b = randn(out)
    x -> W * x .+ b
  end
  
  linear1 = linear(5, 3) # we can access linear1.W etc
  linear2 = linear(3, 2)
  
  model(x) = linear2(σ.(linear1(x)))
  
  model(rand(5)) # => 2-element vector =#