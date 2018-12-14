//: [Previous](@previous)

import Foundation

example("Init matrix") {
    let matrix = Matrix(elements: [1, 2, 3, 4, 5, 6], rows: 2)
    print(matrix.description)
}

example("Matrix sum") {
    let A = Matrix(elements: [1, 0, 2, 5, 3, 1], rows: 3)
    let B = Matrix(elements: [4, 0.5, 2, 5, 0, 1], rows: 3)
    let C = A+B
    
    print(A.description, "+\n", B.description, "=\n", C.description)
    let P = Matrix(elements: [5, 0.5, 4, 10, 3, 2], rows: 3)
    print("Is correct? ", C == P)
}

example("Matrix multiplications") {
    let A = Matrix(elements: [1, 3, 2, 4, 0, 5], rows: 3)
    let B = Matrix(elements: [1, 0, 2, 3], rows: 2)
    
    let C = A*B
    print(A.description, "*\n", B.description, "=\n", C.description)
    let P = Matrix(elements: [7, 9, 10, 12, 10, 15], rows: 3)
    print("Is correct? ", C == P)
}

example("Matrix commutative") {
    let A = Matrix(elements: [1, 3, 2, 4], rows: 2)
    let B = Matrix(elements: [1, 0, 2, 3], rows: 2)
    
    let C = A*B
    let D = B*A
    print("Is commutative: (A*B == B*A)?", C == D)
}

example("Matrix associative") {
    let A = Matrix(elements: [1, 3, 2, 4], rows: 2)
    let B = Matrix(elements: [1, 0, 2, 3], rows: 2)
    let C = Matrix(elements: [6, 2, 5, 7], rows: 2)
    
    let D = A*(B*C)
    let E = (A*B)*C
    
    print("Is associative: (A*(B*C) == (A*B)*C)?", D == E)
}

example("Identity matrix") {
    let I = Matrix.identity(3)
    print(I.description)
    let P = Matrix(elements: [1, 0, 0, 0, 1, 0, 0, 0, 1], rows: 3)
    print("Is correct? ", I == P)
    
    let A = Matrix(elements: [1, 3, 2, 4, 0, 5], rows: 3)
    
    let B = A * Matrix.identity(A.size.columns)
    let C = Matrix.identity(A.size.rows) * A
    
    print("is A*I == I*A == A", B == C && C == A)
}

example("Matrix inverse") {
    let A = Matrix(elements: [3, 4, 2, 16], rows: 2)
    let B = A.inverse
    let P = Matrix(elements: [0.4, -0.1, -0.05, 0.075], rows: 2)
    print("Calculated inverse \n", B.description)
    print("Is correct?", B≈P)
    let I = Matrix.identity(2)
    print("Is A*(A^-1) ≈ (A^-1)*A ≈ identity?", I ≈ (A*B) && (A*B) ≈ I)
}

example("Matrix transpose") {
    let A = Matrix(elements: [1, 2, 0, 3, 5, 9], rows: 2)
    let B = A.transpose
    let P = Matrix(elements: [1, 3, 2, 5, 0, 9], rows: 3)
    print("Is correct?", B == P)
}
