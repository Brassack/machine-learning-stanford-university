import Foundation

infix operator ≈ : ComparisonPrecedence
public func ≈(left: Double, right: Double) -> Bool {
    if abs(left - right) > Constant.epsilon {
        return false
    }
    return true
}

infix operator !≈ : ComparisonPrecedence
public func !≈(left: Double, right: Double) -> Bool {

    return !(left ≈ right)
}
