//
//  ParsingError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

enum ParsingError: Error, CustomStringConvertible {
    case missingField(String, expectedType: String)

    var description: String {
        switch self {
        case .missingField(let field, let expectedType):
            return "Missing required field: \(field) (Expected type: \(expectedType))"
        }
    }
}
