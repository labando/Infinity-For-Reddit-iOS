//
//  PartialUserDataListing.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-26.
//

import Foundation
import SwiftyJSON

struct PartialUserDataListing {
    var partialUserDataDictionary: [String: PartialUserData] = [:]

    init(fromJson json: JSON) {
        if json.isEmpty { return }
        
        json.dictionaryValue.forEach { key, value in
            partialUserDataDictionary[key] = PartialUserData(fromJson: value)
        }
    }
}

class PartialUserData: Decodable {

    var commentKarma : Int!
    var createdUtc : Float!
    var linkKarma : Int!
    var name : String!
    var profileColor : String!
    var profileImg : String!
    var profileOver18 : Bool!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        commentKarma = json["comment_karma"].intValue
        createdUtc = json["created_utc"].floatValue
        linkKarma = json["link_karma"].intValue
        name = json["name"].stringValue
        profileColor = json["profile_color"].stringValue
        profileImg = json["profile_img"].stringValue
        profileOver18 = json["profile_over_18"].boolValue
    }
}
