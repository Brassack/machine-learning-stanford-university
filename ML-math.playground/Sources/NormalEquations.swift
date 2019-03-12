import Foundation


public func normalEquations(x: Matrix, y: Matrix) -> Matrix {
    //theta = pinv(X'*X)*X'*y;
    let theta = (x.transpose*x).pinv*x.transpose*y
    return theta.transpose
}
