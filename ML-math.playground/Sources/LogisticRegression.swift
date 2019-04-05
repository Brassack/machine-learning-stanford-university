import Foundation

public struct LogisticRegression {
    
    public static func hypothesys(x: Matrix, theta: Matrix) -> Double {
        return LinearRegression.hypothesys(x: x, theta: theta)
    }
    
    public static func sigmoid(_ value: Double) -> Double {
        return 1.0/(1 + exp(-value))
    }
    
    public static func costFunction(theta: Matrix, x: Matrix, y: Matrix) -> (J: Double, grad: Matrix){
        
        let m = x.size.rows//number of trainig examples
        let n = theta.size.rows//number of features

        var sum = Double(0)
        
        for i in 0..<m {
            
            let yValue = y[i, 0]
            let h = sigmoid(hypothesys(x: x.row(i), theta: theta))
            
            sum += -yValue * log(h) - (1 - yValue) * log(1 - h)
        }
        
        let cost = 1.0/Double(m) * sum
        
        var grad = Matrix.zeros(size: MatrixSize(rows: n, columns: 1))
        for j in 0..<n {
            
            var gradSum = Double(0);
            
            for i in 0..<m {
                let yValue = y[i, 0]
                let h = sigmoid(hypothesys(x: x.row(i), theta: theta))
                gradSum += (h - yValue) * x[i, j]
            }
            
            grad[j, 0] = 1.0/Double(m) * gradSum
        }
        
        return (J: cost, grad: grad)
    }
    
    public static func predict(x: Matrix, theta: Matrix) -> Matrix {
        
        let m = x.size.rows//number of trainig examples
        
        var p = Matrix.zeros(size: MatrixSize(rows: m, columns: 1))
        
        for i in 0..<m {
            
            if sigmoid(hypothesys(x: x.row(i), theta: theta)) >= 0.5 {
                p[i, 0] = 1
            }else{
                p[i, 0] = 0
            }
        }
        
        return p
    }
    
    
    public static func costFunctionReg(theta: Matrix, x: Matrix, y: Matrix, lambda: Double) -> (J: Double, grad: Matrix){
        
        let m = x.size.rows//number of trainig examples
        let n = theta.size.rows//number of features
        
        var sum = Double(0)
        
        for i in 0..<m {
            
            let yValue = y[i, 0]
            let h = sigmoid(hypothesys(x: x.row(i), theta: theta))
            
            sum += -yValue * log(h) - (1 - yValue) * log(1 - h)
        }
        
        var regSum = Double(0);
        for j in 1..<n {
            regSum += pow(theta[j, 0], 2.0)
        }
        
        let cost = 1.0/Double(m) * sum + lambda/(2.0 * Double(m)) * regSum
        
        var grad = Matrix.zeros(size: MatrixSize(rows: n, columns: 1))
//        print("1.0/Double(m) ", 1.0/Double(m))
//print("grad ", grad)
        for j in 0..<n {
            
            var gradSum = Double(0);
            
            for i in 0..<m {
                let yValue = y[i, 0]
                let h = sigmoid(hypothesys(x: x.row(i), theta: theta))
                gradSum += (h - yValue) * x[i, j]
//                print("gradSum ", gradSum)
//                print("h ", h)
//                print("y[i, 0] ", y[i, 0])
            }
            
            grad[j, 0] = 1.0/Double(m) * gradSum

            if j > 0 {
                grad[j, 0] += lambda/Double(m) * theta[j, 0]
            }
//            print("grad[j, 0] ", grad[j, 0])
        }
        
        return (J: cost, grad: grad)
    }
    
    
//    public static func computeCost(x: Matrix, y: Matrix, theta: Matrix) -> Double {
//        let m = x.size.rows//number of trainig examples
//
//        return -1.0/(Double(m))
//            * (0..<m).map { i -> Double in
//
//                let h = hypothesys(x: x.row(i), theta: theta)
//                let s = sigmoid(h)
//                let expectedY = y[i, 0]
//
//                return expectedY*log(s) + (1 - expectedY)*log(1 - s)
//                } .reduce(0, +)
//    }
    
//    public static func computeCostRegularized(lambda: Double, x: Matrix, y: Matrix, theta: Matrix) -> Double {
//        let m = x.size.rows//number of trainig examples
//
//        let sum = (0..<m).map { i -> Double in
//
//                let h = hypothesys(x: x.row(i), theta: theta)
//                let s = sigmoid(h)
//                let expectedY = y[i, 0]
//                let result = expectedY*log(s) + (1 - expectedY)*log(1 - s)
//
//                return pow(result, 2)
//            } .reduce(0, +)
//
//        let lambdaSum = (1..<m).map { (j) -> Double in
//            pow(theta[j, 0], 2)
//        } .reduce(0, +)
//
//        return -1.0/(2*Double(m))*(sum + lambda*lambdaSum)
//    }
//
    
//    public static func gradientDescent(withAlpha alpha: Double, iterations: Int, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
//
//        var result = theta
//
//        for _ in 0..<iterations {
//            result = updatedTheta(withAlpha: alpha, x: x, y: y, theta: result)
//        }
//
//        return result
//    }
    
    
//    public static func updatedTheta(withAlpha alpha: Double, x: Matrix, y: Matrix, theta: Matrix) -> Matrix {
//        var result = theta
//
//        let m = x.size.rows//trainig examples
//        let n = theta.size.rows//number of feature
//
//        for j in 0..<n {
//
//            let sum = (0..<m).map { (i) -> Double in
//                let s = sigmoid(hypothesys(x: x.row(i), theta: theta))
//                return (s - y[i, 0]) * x[i, j]
//                }
//                .reduce(0, +)
//
//            result[j, 0] = theta[j, 0] - alpha * sum
//        }
//
//        return result
//    }

}
