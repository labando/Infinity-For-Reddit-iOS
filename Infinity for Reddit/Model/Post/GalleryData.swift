//
//  GalleryData.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-01.
//

import Foundation
import SwiftyJSON

class GalleryData : NSObject, NSCoding, ObservableObject, Identifiable {
    
    var items : [GalleryItem]!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        items = [GalleryItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = GalleryItem(fromJson: itemsJson)
            items.append(value)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if items != nil{
            var dictionaryElements = [[String:Any]]()
            for itemsElement in items {
                dictionaryElements.append(itemsElement.toDictionary())
            }
            dictionary["items"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        items = aDecoder.decodeObject(forKey: "items") as? [GalleryItem]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if items != nil{
            aCoder.encode(items, forKey: "items")
        }
        
    }
    
}


class GalleryItem : NSObject, NSCoding{
    
    var caption : String!
    var id : Int!
    var mediaId : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        caption = json["caption"].stringValue
        id = json["id"].intValue
        mediaId = json["media_id"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if caption != nil{
            dictionary["caption"] = caption
        }
        if id != nil{
            dictionary["id"] = id
        }
        if mediaId != nil{
            dictionary["media_id"] = mediaId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        caption = aDecoder.decodeObject(forKey: "caption") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        mediaId = aDecoder.decodeObject(forKey: "media_id") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if caption != nil{
            aCoder.encode(caption, forKey: "caption")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if mediaId != nil{
            aCoder.encode(mediaId, forKey: "media_id")
        }
        
    }
    
}
