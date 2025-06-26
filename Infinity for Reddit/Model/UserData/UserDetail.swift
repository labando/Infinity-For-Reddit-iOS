//
//  UserDetail.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-02.
//

import Foundation
import SwiftyJSON
import GRDB

class UserDetailRootClass : NSObject, NSCoding{
    
    var data : User!
    var kind : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty{
            data = User(fromJson: dataJson)
        }
        kind = json["kind"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if kind != nil{
            dictionary["kind"] = kind
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObject(forKey: "data") as? User
        kind = aDecoder.decodeObject(forKey: "kind") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if kind != nil{
            aCoder.encode(kind, forKey: "kind")
        }
        
    }
    
    public func toUserData() -> UserData {
        return UserData(
            id: data.id,
            name: data.name,
            iconUrl: data.iconImg,
            banner: data.subreddit?.bannerImg,
            commentKarma: data.commentKarma,
            linkKarma: data.linkKarma,
            awarderKarma: data.awarderKarma,
            awardeeKarma: data.awardeeKarma,
            totalKarma : data.totalKarma,
            cakeday : data.createdUtc,
            isGold : data.isGold,
            canBeFollowed : data.acceptFollowers,
            isNSFW : data.subreddit?.over18,
            description : data.subreddit?.publicDescription,
            title : data.subreddit?.title
        )
    }
}
