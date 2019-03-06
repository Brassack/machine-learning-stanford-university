import Foundation

public func hypothesys(x: Matrix, theta: Matrix) -> Double {
    return (theta * x).sum
}

public func computeCost(x: Matrix, y: Matrix, theta: Matrix) -> Double {
    let m = x.size.columns
    
    return 1/(2*Double(m))
            * (0..<m).map {
                    pow((hypothesys(x: x.column($0), theta: theta) - y[0, $0]), 2)
                } .reduce(0, +)
}

public func updatedTheta(withAlpha alpha: Double, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
    var result = theta
    
    let m = x.size.columns//trainig examples
    let n = theta.size.columns//number of feature

    for j in 0..<n {
        let sum = (0..<m).map { (i) -> Double in
                        let h = hypothesys(x: x.column(i), theta: theta)
                        return (h - y[0, i]) * x[j, i]
                    }
                    .reduce(0, +)
        result[0, j] = theta[0, j] - alpha * (1/Double(m)) * sum
    }
    
    return result
}

public func gradientDescent(withAlpha alpha: Double, iterations: Int, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
    
    var result = theta
    
    for _ in 0..<iterations {
        result = updatedTheta(withAlpha: alpha, x: x, y: y, theta: result)
    }
    
    return result
}
