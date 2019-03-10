import Foundation


public func normalEquations(x: Matrix, y: Matrix) -> Matrix {
    //theta = pinv(X'*X)*X'*y;
    let theta = (x*x.transpose).pinv*x*y.transpose////*x.transpose*y//Matrix.init(array: [])
    return theta.transpose
}
