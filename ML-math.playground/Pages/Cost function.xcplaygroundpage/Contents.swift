import Foundation

example("Derivative") {
    let x = Double(10)
    let square: (Double) -> Double = { (x) in return x*x }//(x^2)' = 2*x
    print("Derivative of square for ", x, " is ", square➚x, " ≈ ", 2*x)
    
    let degree:Double = 60
    let sinus: (Double) -> Double = { (x) in return sin(x) }//(sinX)' = cosX
    print("Derivative of sinus for ", degree, " is ", sinus➚(degree * Double.pi/180), " ≈ ", cos(degree * Double.pi/180))
}
