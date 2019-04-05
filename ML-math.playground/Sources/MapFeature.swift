import Foundation

public func mapFeature(x1: Matrix, x2: Matrix) -> Matrix {
    
    let m = x1.size.rows
    let degree = 6
    var out = Matrix.ones(size: MatrixSize(rows: m, columns: 1))
    
    for i in 1..<degree+1 {
        for j in 0..<i+1 {
            
            var degrees = Matrix.zeros(size: MatrixSize(rows: m, columns: 1))
            
            for row in 0..<x1.size.rows {
                degrees[row, 0] = pow(x1[row, 0], Double(i - j)) * pow(x2[row, 0], Double(j))
            }
            
            out = out.appending(columns: degrees)
        }
    }

    return out
}
