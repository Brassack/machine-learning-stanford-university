import Foundation

enum MatrixError: Error {
    case emptyFile
}

extension Matrix{
    public init(path: String) throws {
        
        guard let data = FileManager.default.contents(atPath: path),
            let content = String(data:data, encoding:.utf8) else {
                throw MatrixError.emptyFile
        }
        
        var rows = content.components(separatedBy: .newlines)
        
        
        guard rows.count > 0 else {
            throw MatrixError.emptyFile
        }
        
        let isExistLatestRow = (rows.last!.components(separatedBy: ",").first?.count ?? 0) > 0
        if !isExistLatestRow {
            rows.remove(at: rows.count - 1)
        }
        
        guard rows.count > 0 else {
            throw MatrixError.emptyFile
        }
        
        
        size = MatrixSize(rows: rows.count,
                          columns: rows.first!.components(separatedBy: ",").count)
        
        var array = [Double](repeating: 0, count: size.columns*size.rows)
        
        for row in 0..<size.rows {
            let columns = rows[row].components(separatedBy: ",")
            for column in 0..<size.columns {
                guard columns.count == size.columns,
                    let value = Double(columns[column]) else { continue }
                
                array[row*size.columns + column] = value
            }
        }
        grid = array
    }
}
