//: [Previous](@previous)

import Foundation

//%% ==================== Part 1: Basic Function ====================
//
//fprintf('Running warmUpExercise ... \n');
//fprintf('5x5 Identity Matrix: \n');
//warmUpExercise()
print("5x5 Identity Matrix: \n", Matrix.eye(5).description)

let data1Path = Bundle.main.path(forResource:"ex1data1", ofType: "txt")!

let ex1data1 = try! Matrix(path: data1Path)
print("Loaded data: \n", ex1data1.description)


let data1X: Matrix = {
    let data = ex1data1.column(0)
    return Matrix.ones(size: MatrixSize(rows: data.size.rows, columns: 1)).appending(columns: data)
}()

let data1Y = ex1data1.column(1)

var theta = Matrix.zeros(size: MatrixSize(rows: data1X.size.columns, columns: 1))


let iterations = 1500
let alpha = 0.01

let J = computeCost(x: data1X, y: data1Y,  theta: theta)
print("With theta\n \(theta.description)\nCost computed =", J)
print("Expected cost value (approx) 32.07")

let J2 = computeCost(x: data1X, y: data1Y, theta: Matrix(elements: [-1, 2], rows: 2))
print("\nWith theta = [-1 ; 2]\nCost computed = ", J2);
print("Expected cost value (approx) 54.24");

print("\nRunning Gradient Descent ...")

theta = gradientDescent(withAlpha: alpha, iterations: iterations, x: data1X, y: data1Y, theta: theta)

print("Theta found by gradient descent:\n", theta.description)
print("Expected theta values (approx) \n-3.6303\n1.1664");

print("\nResult cost: ", computeCost(x: data1X, y: data1Y,  theta: theta))
