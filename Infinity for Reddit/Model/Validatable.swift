//
//  Validatable.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import SwiftyJSON

protocol Validatable {
    static func validate(json: JSON) throws
}

extension Validatable {
    static func validate(json: JSON) throws {
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            guard let fieldName = child.label else { continue }

            let expectedType = type(of: child.value)

            // Check if the JSON contains the key
            if json[fieldName].type == .null {
                throw ParsingError.missingField(fieldName, expectedType: "\(expectedType)")
            }
        }
    }
}
