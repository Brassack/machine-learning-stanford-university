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
    public var grid: [Double]
    
    public var sum: Double {
        return grid.reduce(0, +)
    }
    public var mean: Double { return grid.reduce(0, +) / Double(grid.count) }//mean == average
    public var std: Double { //standart deviation
        let mean = self.mean
        let sumOfSquaredAvgDiff = grid.map { pow($0 - mean, 2.0) } .reduce(0, +)
        return sqrt(sumOfSquaredAvgDiff/Double(grid.count - 1))
    }
    
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
    //https://youtu.be/pTUfUjIQjoE?t=365
    //pinv(A) = inv(A'*A)*A'
    public var pinv: Matrix {
        return (transpose*self).inverse*transpose//Matrix.zeros(size: MatrixSize(rows: 0, columns: 0))
    }

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

        if error != 0 {
            print("Error inverting matrix code: ", error)
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

    //MARK: - Generator
    public static func eye(_ size: Int) -> Matrix {
        return identity(size)
    }
    
    public static func ones(size: MatrixSize) -> Matrix {
        let array = [Double](repeating: 1, count: size.rows*size.columns)
        return Matrix(elements: array, rows: size.rows)
    }
    
    public static func zeros(size: MatrixSize) -> Matrix {
        let array = [Double](repeating: 0, count: size.rows*size.columns)
        return Matrix(elements: array, rows: size.rows)
    }

    public static func identity(_ size: Int) -> Matrix {
        assert(size > 0, "Size should be bigger than zero")
        var elements = [Double](repeating: 0, count: size*size)
        for i in 0..<size {
            elements[i + i*size] = 1.0
        }
        return Matrix(elements: elements, rows: size)
    }
    
    //MARK: - Appending
    public func appending(columns: Matrix) -> Matrix {
        assert(size.rows != columns.size.rows, "Invalid amount of rows")
        let newSize = MatrixSize(rows: size.rows, columns: size.columns + columns.size.columns)
        var newArray = [Double](repeating: 0, count: newSize.columns*newSize.rows)
        
        for row in 0..<newSize.rows {
            for column in 0..<newSize.columns {
                let newIndex = row*newSize.columns + column
                if column < size.columns {//self
                    newArray[newIndex] = self[row, column]
                }else{//new columns
                    newArray[newIndex] = columns[row, column - size.columns]
                }
            }
        }
        
        return Matrix(elements: newArray, rows: newSize.rows)
    }
    
    public func appending(rows: Matrix) -> Matrix {
        assert(size.columns != rows.size.columns, "Invalid amount of rows")

        let newSize = MatrixSize(rows: size.rows + rows.size.rows, columns: size.columns)
        var newArray = [Double](repeating: 0, count: newSize.columns*newSize.rows)
        
        for column in 0..<newSize.columns {
            for row in 0..<newSize.rows {
                let newIndex = row*newSize.columns + column
                if row < size.rows {//self
                    newArray[newIndex] = self[row, column]
                }else{//new columns
                    newArray[newIndex] = rows[row - size.rows, column]
                }
            }
        }
        
        return Matrix(elements: newArray, rows: newSize.rows)
    }
    
    //MARK: Access rows and colums
    public func row(_ row: Int) -> Matrix {
        var result = Matrix(rows: 1, columns: size.columns)
        
        for column in 0..<size.columns {
            result[0, column] = self[row, column]
        }
        
        return result
    }
    
    public func column(_ column: Int) -> Matrix {
        var result = Matrix(rows: size.rows, columns: 1)
        
        for row in 0..<size.rows {
            result[row, 0] = self[row, column]
        }
        
        return result
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
