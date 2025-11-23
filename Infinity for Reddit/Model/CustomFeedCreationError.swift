//
//  CustomFeedCreationError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import SwiftyJSON

class CustomFeedCreationError {
    var explanation : String!
    var fields : [String]!
    var message : String!
    var reason : String!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        explanation = json["explanation"].stringValue
        fields = [String]()
        let fieldsArray = json["fields"].arrayValue
        for fieldsJson in fieldsArray{
            fields.append(fieldsJson.stringValue)
        }
        message = json["message"].stringValue
        reason = json["reason"].stringValue
    }
}
