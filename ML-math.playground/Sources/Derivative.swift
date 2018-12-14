import Foundation

//https://www.mathsisfun.com/calculus/derivatives-introduction.html
postfix operator ➚
public postfix func ➚(f:@escaping (Double) -> Double) -> ((Double) -> Double) {
    func d(input: Double) -> Double {
        return (f(input + Constant.epsilon) - f(input)) / Constant.epsilon
    }
    return d
}

infix operator ➚
public func ➚(f:@escaping (Double) -> Double, x: Double) -> Double {
    return (f(x + Constant.epsilon) - f(x)) / Constant.epsilon
}
