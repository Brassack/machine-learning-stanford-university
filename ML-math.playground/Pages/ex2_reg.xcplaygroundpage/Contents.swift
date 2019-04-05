//: [Previous](@previous)

import Foundation

let data2Path = Bundle.main.path(forResource:"ex2data2", ofType: "txt")!

let ex2data2 = try! Matrix(path: data2Path)
//print("Loaded data: \n", ex2data2.description)

let data1X: Matrix = {
    return mapFeature(x1: ex2data2.column(0), x2: ex2data2.column(1))
}()

let data1Y = ex2data2.column(2)

var theta = Matrix.zeros(size: MatrixSize(rows: data1X.size.columns, columns: 1))

let lambda = Double(1)

var costTest = LogisticRegression.costFunctionReg(theta: theta, x: data1X, y: data1Y, lambda: lambda)

print("Cost at initial theta (zeros): ", costTest.J)
print("Expected cost (approx): 0.693")
var first5 = costTest.grad.row(0)
                        .appending(rows: costTest.grad.row(1))
                        .appending(rows: costTest.grad.row(2))
                        .appending(rows: costTest.grad.row(3))
                        .appending(rows: costTest.grad.row(4))
print("Gradient at initial theta (zeros): \n", first5.description)
print("Expected gradients (approx) - first five values only:\n 0.0085\n 0.0188\n 0.0001\n 0.0503\n 0.0115\n")



theta = Matrix.ones(size: MatrixSize(rows: data1X.size.columns, columns: 1))

costTest = LogisticRegression.costFunctionReg(theta: theta, x: data1X, y: data1Y, lambda: 10)

print("Cost at test theta (with lambda = 10): ", costTest.J)
print("Expected cost (approx): 3.16")
first5 = costTest.grad.row(0)
    .appending(rows: costTest.grad.row(1))
    .appending(rows: costTest.grad.row(2))
    .appending(rows: costTest.grad.row(3))
    .appending(rows: costTest.grad.row(4))
print("Gradient at test theta - first five values only: \n", first5.description)
print("Expected gradients (approx) - first five values only:\n 0.3460\n 0.1614\n 0.1948\n 0.2269\n 0.0922\n")


let precalculatedTheta = [1.273005, 0.624876, 1.177376,-2.020142,-0.912616,-1.429907, 0.125668,-0.368551,-0.360033,-0.171068,-1.460894,-0.052499,-0.618889,-0.273745,-1.192301,-0.240993,-0.207934,-0.047224,-0.278327,-0.296602,-0.453957,-1.045511, 0.026463,-0.294330, 0.014381,-0.328703,-0.143796,-0.924883]

theta = Matrix(elements: precalculatedTheta, rows: precalculatedTheta.count)

let p = LogisticRegression.predict(x: data1X, theta: theta)

var accuracy = Matrix.zeros(size: MatrixSize(rows: p.size.rows, columns: 1))

for i in 0..<p.size.rows {
    accuracy[i, 0] = (p[i, 0] == data1Y[i, 0]) ? 1.0 : 0.0
    
}

print("Train Accuracy: ", accuracy.mean * 100)
print("Expected accuracy (with lambda = 1): 83.1")
