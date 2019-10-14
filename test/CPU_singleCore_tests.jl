println("-----------------------Testing CPU Single Core-------------------------------------")
println("Testing numerical gradient vs backpropagation")
println("---------------------------------------------")
println("Lambda = 0, no hidden layers")
err = checkNumGrad(0.0f0, hidden_layers=Vector{Int64}())
@test (err < 0.015)

println("Lambda = 0")
err = checkNumGrad(0.0f0)
@test (err < 0.015)

println("Lambda = 0.1")
err = checkNumGrad(0.1f0)
@test(err < 0.015)

println("Lambda = 1.0")
err = checkNumGrad(1.0f0)
@test(err < 0.015)
println("TEST PASSED")
println()

println("Squared Error Cost Function")
err = checkNumGrad(0.0f0, costFunc = "sqErr")
@test(err < 0.015)
println("TEST PASSED")
println()

println("Normal Log Likelihood Error Cost Function")
err = checkNumGrad(0.0f0, costFunc = "normLogErr")
@test(err < 0.015)
println("TEST PASSED")
println()

println("Cauchy Log Likelihood Error Cost Function")
err = checkNumGrad(0.0f0, costFunc = "cauchyLogErr")
@test(err < 0.015)
println("TEST PASSED")
println()

#basic test train with 1 input, 1 output, 1 neuron
println("Testing simple ANN training version 1")
println("-------------------------------------")
M = 1
hidden = [1]
O = 1
batchSize = 1024
N = 150
testTrain(M, hidden, O, batchSize, N; writeFile = false, numThreads = 0, printProg = true)
println("TEST PASSED")
println()

#full train test with data read and output
function writeTestData(name, M, O)
    X = randn(Float32, 100000, M)
    Y = randn(Float32, 100000, O)
    Xtest = randn(Float32, 10000, M)
    Ytest = randn(Float32, 10000, O)
    writedlm(string("Xtrain_", name, ".csv"), X)
    writedlm(string("Xtest_", name, ".csv"), Xtest)
    writedlm(string("ytrain_", name, ".csv"), Y)
    writedlm(string("ytest_", name, ".csv"), Ytest)
end

function writeBinData(name, M, O)
    X = randn(Float32, 100000, M)
    Y = randn(Float32, 100000, O)
    Xtest = randn(Float32, 10000, M)
    Ytest = randn(Float32, 10000, O)
    writeArray(X, string("Xtrain_", name, ".bin"))
    writeArray(Xtest, string("Xtest_", name, ".bin"))
    writeArray(Y, string("ytrain_", name, ".bin"))
    writeArray(Ytest, string("ytest_", name, ".bin"))
end
println("Testing full ANN train with test data")
println("--------------------------------------")
name = "test"
M = 10
O = 2
Random.seed!(1234)
writeTestData(name, M, O)
writeBinData(name, M, O)

println("Training with 0 hidden layers")
record, T, B = fullTrain(name, 150, 1024, Vector{Int64}(), 0.0f0, Inf, 0.002f0, 0.1f0, 1, writeFiles=false)
@test(record[end] < record[1])
println("TEST PASSED")
println()

println("Training with 0 hidden layers and binary input read")
record, T, B = fullTrain(name, 150, 1024, Vector{Int64}(), 0.0f0, Inf, 0.002f0, 0.1f0, 1, writeFiles=false, binInput = true)
@test(record[end] < record[1])
println("TEST PASSED")
println()

println("Training with 2 hidden layers")
record, T, B = fullTrain(name, 10, 1024, [2, 2], 0.0f0, Inf, 0.002f0, 0.1f0, 1)
@test(record[end] < record[1])
println("TEST PASSED")
println()

println("Training with 2 hidden layers from previous endpoint")
record, T, B = fullTrain(name, 150, 1024, [2, 2], 0.0f0, Inf, 0.002f0, 0.1f0, 2, startID = 1, writeFiles=false)
@test(record[end] < record[1])
println("TEST PASSED")
println()