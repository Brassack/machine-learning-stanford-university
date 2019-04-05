//: [Previous](@previous)

import Foundation

let data2Path = Bundle.main.path(forResource:"ex2data1", ofType: "txt")!

let ex2data1 = try! Matrix(path: data2Path)
print("Loaded data: \n", ex2data1.description)

let data1X: Matrix = {
    
    return Matrix.ones(size: MatrixSize(rows: ex2data1.size.rows, columns: 1))
        .appending(columns: ex2data1.column(0))
        .appending(columns: ex2data1.column(1))
}()

let data1Y = ex2data1.column(2)

var theta = Matrix.zeros(size: MatrixSize(rows: data1X.size.columns, columns: 1))

var costTest = LogisticRegression.costFunction(theta: theta, x: data1X, y: data1Y)

print("Cost at initial theta (zeros): ", costTest.J)
print("Expected cost (approx): 0.693")
print("Gradient at initial theta (zeros): \n", costTest.grad.description)
print("Expected gradients (approx):\n -0.1000\n -12.0092\n -11.2628\n")



theta = Matrix(elements: [-24, 0.2, 0.2], rows: 3)
costTest = LogisticRegression.costFunction(theta: theta, x: data1X, y: data1Y)

print("Cost at test theta: ", costTest.J)
print("Expected cost (approx): 0.218")
print("Gradient at test theta: \n", costTest.grad.description)
print("Expected gradients (approx):\n 0.043\n 2.566\n 2.647\n")


theta = Matrix(elements: [-25.16127, 0.20623, 0.20147], rows: 3)
let testX = Matrix(elements: [1, 45, 85], rows: 1)

let prob = LogisticRegression.sigmoid((testX*theta).sum);

print("For a student with scores 45 and 85, we predict an admission probability of ", prob)
print("Expected value: 0.775 +/- 0.002\n\n")

let p = LogisticRegression.predict(x: data1X, theta: theta)
//print(p.description)
var accuracy = Matrix.zeros(size: MatrixSize(rows: p.size.rows, columns: 1))

for i in 0..<p.size.rows {
    accuracy[i, 0] = (p[i, 0] == data1Y[i, 0]) ? 1.0 : 0.0

}

print("Train Accuracy: ", accuracy.mean * 100)
print("Expected accuracy (approx): 89.0\n")
