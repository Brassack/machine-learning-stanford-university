import Foundation

public struct LinearRegression {
    
    public static func hypothesys(x: Matrix, theta: Matrix) -> Double {
        return (x*theta).sum
    }
    
    public static func computeCost(x: Matrix, y: Matrix, theta: Matrix) -> Double {
        let m = x.size.rows//number of trainig examples
        
        return 1/(2*Double(m))
            * (0..<m).map {
                pow((hypothesys(x: x.row($0), theta: theta) - y[$0, 0]), 2)
                } .reduce(0, +)
    }
    
    public static func updatedTheta(withAlpha alpha: Double, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
        var result = theta
        
        let m = x.size.rows//trainig examples
        let n = theta.size.rows//number of feature
        
        for j in 0..<n {
            let sum = (0..<m).map { (i) -> Double in
                let h = hypothesys(x: x.row(i), theta: theta)
                return (h - y[i, 0]) * x[i, j]
                }
                .reduce(0, +)
            result[j, 0] = theta[j, 0] - alpha * (1/Double(m)) * sum
        }
        
        return result
    }
    
    public static func gradientDescent(withAlpha alpha: Double, iterations: Int, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
        
        var result = theta
        
        for _ in 0..<iterations {
            result = updatedTheta(withAlpha: alpha, x: x, y: y, theta: result)
        }
        
        return result
    }
    
    
    public static func featureNormalisation(_ x: Matrix) -> (x_norm: Matrix, mu: Matrix, sigma: Matrix) {
        
        let n = x.size.columns//number of features
        let m = x.size.rows//training examples
        
        var x_norm = x
        var mu = Matrix(rows: 1, columns: n)
        var sigma = Matrix(rows: 1, columns: n)
        
        
        for j in 0..<n {
            let feature = x.column(j)
            mu[0, j] = feature.mean
            sigma[0, j] = feature.std
            for i in 0..<m {
                x_norm[i, j] = (x[i, j] - mu[0, j])/sigma[0, j]
            }
        }
        
        return (x_norm: x_norm, mu: mu, sigma: sigma)
    }

    public static func normalEquations(x: Matrix, y: Matrix) -> Matrix {
        //theta = pinv(X'*X)*X'*y;
        let theta = (x.transpose*x).pinv*x.transpose*y
        return theta.transpose
    }
}
