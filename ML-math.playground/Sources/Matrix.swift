import Foundation
import Accelerate

public typealias MatrixSize = (rows: Int, columns: Int)

//infix operator ≈ : ComparisonPrecedence
public func ≈(left: Matrix, right: Matrix) -> Bool {
    guard left.size == right.size else { return false }
    for i in 0..<left.grid.count {
        if left.grid[i] !≈ right.grid[i] {
            return false
        }
    }
    return true
}

public struct Matrix {
    // MARK: Variables
    public let size: MatrixSize
    public var isVector: Bool {
        return size.columns == 1
    }
    public var isSquare:Bool {
        return size.columns == size.rows
    }
    fileprivate var grid: [Double]
    
    // MARK: - String representation
    public var description: String {
        var description = ""
        
        for i in 0..<size.rows {
            let contents = (0..<size.columns).map({ "\(self[i, $0])" }).joined(separator: "\t")
            
            switch (i, size.rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (size.rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }
            
            description += "\n"
        }
        
        return description
    }
    
    //MARK: Inverse
    //No description in cource so i used accelerate framework
    //https://stackoverflow.com/questions/26811843/matrix-inversion-in-swift-using-accelerate-framework
    public var inverse: Matrix {
        assert(size.rows == size.columns, "Matrix must be square")
        
        var inMatrix = grid
        var N = __CLPK_integer(sqrt(Double(grid.count)))
        var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace = [Double](repeating: 0.0, count: Int(N))
        var error : __CLPK_integer = 0

        withUnsafeMutablePointer(to: &N) {
            dgetrf_($0, $0, &inMatrix, $0, &pivots, &error)
            dgetri_($0, &inMatrix, $0, &pivots, &workspace, $0, &error)
        }

        return Matrix(elements: inMatrix, rows: size.rows)
    }
    
    public var transpose: Matrix {
        
        let resultGrid = [Double](repeating: 0, count: size.rows * size.columns)
        var result = Matrix(elements: resultGrid, rows: size.columns)
        
        for row in 0..<size.rows {
            for column in 0..<size.columns {
                result[column, row] = self[row, column]
            }
        }
        
        return result
    }
    
    // MARK: - Init
    public init(array: [Double]) {
        size = MatrixSize(rows: 1, columns: array.count)
        grid = array
    }
    
   public init(vectorArray: [Double]){
        size = MatrixSize(rows: vectorArray.count, columns: 1)
        grid = vectorArray
    }
    
    public init(grid elementsGrid: [[Double]]){
        size = MatrixSize(rows: elementsGrid.count, columns: elementsGrid.first!.count)
        grid = [Double]()
        for row in elementsGrid {
            assert(row.count == size.columns, "Invalid row \(row) size")
            grid.append(contentsOf: row)
        }
    }
    
    public init(elements: [Double], rows: Int) {
        assert(elements.count % rows == 0, "Invalid elements size")
        size = MatrixSize(rows: rows, columns: elements.count/rows)
        grid = elements
    }
    
    public init(rows: Int, columns: Int, element: Double = 0) {
        size = MatrixSize(rows: rows, columns: columns)
        grid = Array(repeating: element, count: rows * columns)
    }

    public static func eye(_ size: Int) -> Matrix {
        return identity(size)
    }
    
    public static func identity(_ size: Int) -> Matrix {
        assert(size > 0, "Size should be bigger than zero")
        var elements = [Double](repeating: 0, count: size*size)
        for i in 0..<size {
            elements[i + i*size] = 1.0
        }
        return Matrix(elements: elements, rows: size)
    }
    
    // MARK: - Overloading operators
    public subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * size.columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * size.columns) + column] = newValue
        }
    }
    
    public static func ==(left: Matrix, right: Matrix) -> Bool {
        return left.size == right.size && left.grid == right.grid
    }
    
    public static func !=(left: Matrix, right: Matrix) -> Bool {
        return !(left == right)
    }
    // MARK: Matrix sum
    public static func +(left: Matrix, right: Matrix) -> Matrix {
        assert(left.size == right.size, "Matrices should be the same size")

        var sum = left.grid
        for i in 0..<left.grid.count {
            sum[i] = sum[i] + right.grid[i]
        }
        
        return Matrix(elements: sum, rows: left.size.rows)
    }
    
    public static func -(left: Matrix, right: Matrix) -> Matrix {
        assert(left.size == right.size, "Matrices should be the same size")
        
        var sum = left.grid
        for i in 0..<left.grid.count {
            sum[i] = sum[i] - right.grid[i]
        }
        
        return Matrix(elements: sum, rows: left.size.rows)
    }
    
    //MARK: Double multiplication
    public static func *(left: Matrix, right: Double) -> Matrix {
        let sum = left.grid.map({ $0 * right })
        return Matrix(elements: sum, rows: left.size.rows)
    }
    
    public static func *(left: Double, right: Matrix) -> Matrix {
        return right*left
    }
    
    public static func /(left: Matrix, right: Double) -> Matrix {
        let sum = left.grid.map({ $0 / right })
        return Matrix(elements: sum, rows: left.size.rows)
    }
    
    //MARK: Matrix multiplication
    public static func *(left: Matrix, right: Matrix) -> Matrix {
        assert(left.size.columns == right.size.rows, "Left operand colums amount should be the same as right operant rows amount")
        let resultSize = MatrixSize(rows: left.size.rows, columns: right.size.columns)
        
        var resultGrid = [Double]()
        
        for i in 0..<(resultSize.columns * resultSize.rows) {
            let element: Double = {
                let row = i/resultSize.columns
                let column = i - row * resultSize.columns

                var element: Double = 0
                for c in 0..<left.size.columns {//left.size.columns == right.size.rows
                    let leftElement = left[row, c]
                    let rightElement = right[c, column]
                    element += leftElement*rightElement
                }
                return element
            }()
            resultGrid.append(element)
        }
        
        return Matrix(elements: resultGrid, rows: resultSize.rows)
    }

    // MARK: - Helper
    fileprivate func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < size.rows && column >= 0 && column < size.columns
    }
}
