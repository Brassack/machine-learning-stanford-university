import Foundation

example("Derivative") {
    let x = Double(10)
    let square: (Double) -> Double = { (x) in return x*x }//(x^2)' = 2*x
    print("Derivative of square for ", x, " is ", square➚x, " ≈ ", 2*x)
    
    let degree:Double = 60
    let sinus: (Double) -> Double = { (x) in return sin(x) }//(sinX)' = cosX
    print("Derivative of sinus for ", degree, " is ", sinus➚(degree * Double.pi/180), " ≈ ", cos(degree * Double.pi/180))
}

example("Hypothesys") {
    let theta = Matrix(elements: [1, 2, 3], rows: 1)
    
    let features = Matrix(elements: [4, 5, 6], rows: 3)
    
    let h = hypothesys(x: features, theta: theta)
    
    print("Hypothesys for features: \n", features.description, "\nwith theta: \n", theta.description, "\nIs equal to: ", h, ", is correct: ", h == 32)
}

example("Gradient descent") {
    
    var theta = Matrix(elements: [0, 0, 0], rows: 1)

    let features = Matrix.ones(size: MatrixSize(rows:1, columns: 3)).appending(rows: Matrix(elements: [4, 5, 6, 7, 8, 9], rows: 2))

    let y = Matrix(elements: [11, 13, 16], rows: 1)
    
    let alpha = 0.01
    let iterations = 1500

    print("Initial cost: ", computeCost(x: features, y: y, theta: theta))

    theta = gradientDescent(withAlpha: alpha, iterations: iterations, x: features, y: y, theta: theta)
    
    print("Result theta: \n", theta.description)
    print("Result Cost: ", computeCost(x: features, y: y, theta: theta))

}
