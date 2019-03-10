//: [Previous](@previous)

import Foundation

let data2Path = Bundle.main.path(forResource:"ex1data2", ofType: "txt")!

let ex1data2 = try! Matrix(path: data2Path)

print("Loaded data: \n", ex1data2.description)

var data2X: Matrix = {
    
    var result = ex1data2.column(0)
    for i in 1..<ex1data2.size.columns - 1 {
        result = result.appending(columns: ex1data2.column(i))
    }
    return result.transpose
}()

let data2Y = ex1data2.column(ex1data2.size.columns - 1).transpose

let alpha2 = 0.01;
let iterations2 = 400;

let normalisation = featureNormalisation(data2X)
print("mu\n", normalisation.mu.description, "\n sigma\n", normalisation.sigma.description)

let gradientDescentX2 = Matrix.ones(size: MatrixSize(rows: 1, columns: data2X.size.columns)).appending(rows: normalisation.x_norm)

var theta = Matrix.zeros(size: MatrixSize(rows: 1, columns: gradientDescentX2.size.rows))

theta = gradientDescent(withAlpha: alpha2, iterations: iterations2, x: gradientDescentX2, y: data2Y, theta: theta)
print("Theta computed from gradient descent: \n", theta.description)

var predictedHouse = Matrix(elements: [1650, 3], rows: 2)

for i in 0..<predictedHouse.size.rows {
    predictedHouse[i , 0] = (predictedHouse[i, 0] - normalisation.mu[i, 0])/normalisation.sigma[i, 0]
}

predictedHouse = Matrix.ones(size: MatrixSize(rows: 1, columns: predictedHouse.size.columns)).appending(rows: predictedHouse)
let price = (predictedHouse.transpose*theta.transpose).sum

print("Predicted price of a 1650 sq-ft, 3 br house (using gradient descent): ", price, " should be ~ $289314.620338")


let neX2 = Matrix.ones(size: MatrixSize(rows: 1, columns: data2X.size.columns)).appending(rows: data2X)

var neTheta = normalEquations(x: neX2, y: data2Y)
print("Theta computed from the normal equations: \n", neTheta.description)

let price2 = (Matrix(elements: [1, 1650, 3], rows: 1)*neTheta.transpose).sum;
print("Predicted price of a 1650 sq-ft, 3 br house (using normal equations): $", price2, " should be ~ $293081.464335")
