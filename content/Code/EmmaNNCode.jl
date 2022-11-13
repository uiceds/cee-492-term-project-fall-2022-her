#import Pkg; 
#Pkg.add("Flux")
# Pkg.add("LinearAlgebra")
# Pkg.add("Random")
# Pkg.add("Zygote")
#Pkg.add("StatsAPI")


using PlutoUI
using DataFrames
using Plots
using RDatasets
using Statistics
using StatsPlots
using CSV
using LinearAlgebra
using Random
using StatsBase
using Zygote
using Flux
using StatsAPI


data = CSV.read("C:/Users/emmag/OneDrive/EMMA_user/Docs/Academics/UIUC/2022-2023/CEE 492 Data Science/Project/TreeData/Data/TS3_Raw_tree_data.csv", DataFrame)
df = select(data,["DBH", "Age"])
dff = filter(x -> (x.DBH != -1) && (x.Age != -1), df)
dff = shuffle(dff)

x = Vector(dff.DBH)
y = Vector(dff.Age)

function normalize(x::Vector)
    (x .- mean(x)) / std(x)
end


x_train, x_test = normalize(x[1:8880]), x[8881:length(x)] # 70% of data as training, 30% as test
#y_train, y_test = actual.(x_train), actual.(x_test) # <-- From example in Flux workbook that applies a linear function "actual" to create y data
# ******* ^^ But in the homework, we didn't set aside training or test y data...
y_train, y_test = y[1:8880], y[8881:length(y)]




# METHOD 1 #


#= function pree(x)
    Dense(1 => 1) #Implements the function σ(Wx+b) where W and b are the weights and biases. σ is an activation function
end

loss(x, y) = Flux.mse(pree(x), y) # provide a loss function to tell Flux how to objectively evaluate the quality of a prediction. Loss functions compute the cumulative distance between actual values and predictions.
# ^ Changed Flux.mse from Flux.Losses.mse... why?

###################
loss(x_train, y_train) # GOING WRONG HERE HELPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
####################

#use a loss function and training data to improve the parameters of your model based on a pluggable optimiser:

using Flux: train!
opt = Descent()

data = [(x_train, y_train)]

parameters = Flux.params(pree) #these are the parameters Flux will change, one step at a time, to improve predictions.
pree.weight in parameters, pree.bias in parameters


# Run over multiple epochs
for epoch in 1:200
    train!(loss, parameters, data, opt) #improve the parameters of the model with a call to Flux.train!

  end

println(loss(x_train, y_train))

println(parameters)


# Verify predictions
pree(x_test)

pree(y_test) =#



# METHOD 2 #
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