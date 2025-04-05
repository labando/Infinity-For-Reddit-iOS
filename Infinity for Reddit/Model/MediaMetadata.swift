//
//  MediaMetadata.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-01-10.
//

import Foundation
import SwiftyJSON

class MediaMetadata : NSObject, NSCoding{
    
    static let imageType = "Image"
    static let gifType = "AnimatedImage"
    
    // Type (image: Image, gif: AnimatedImage)
    var e : String!
    var id : String!
    //MIME Type
    var m : String!
    // Preview, only images
    var p : [MediaMetadataPreview]! = [MediaMetadataPreview]()
    // Source, may contain gif and image
    var s : MediaMetadataSource!
    //E.g. "Valid"
    var status : String!
    var caption: String?
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty{
            return
        }
        e = json["e"].stringValue
        id = json["id"].stringValue
        m = json["m"].stringValue
        let pArray = json["p"].arrayValue
        for pJson in pArray {
            let value = MediaMetadataPreview(fromJson: pJson)
            p.append(value)
        }
        let sJson = json["s"]
        if !sJson.isEmpty {
            s = MediaMetadataSource(fromJson: sJson)
        }
        status = json["status"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if e != nil{
            dictionary["e"] = e
        }
        if id != nil{
            dictionary["id"] = id
        }
        if m != nil{
            dictionary["m"] = m
        }
        if p != nil{
            var dictionaryElements = [[String:Any]]()
            for pElement in p {
                dictionaryElements.append(pElement.toDictionary())
            }
            dictionary["p"] = dictionaryElements
        }
        if s != nil{
            dictionary["s"] = s.toDictionary()
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        e = aDecoder.decodeObject(forKey: "e") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        m = aDecoder.decodeObject(forKey: "m") as? String
        p = aDecoder.decodeObject(forKey: "p") as? [MediaMetadataPreview]
        s = aDecoder.decodeObject(forKey: "s") as? MediaMetadataSource
        status = aDecoder.decodeObject(forKey: "status") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if e != nil{
            aCoder.encode(e, forKey: "e")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if m != nil{
            aCoder.encode(m, forKey: "m")
        }
        if p != nil{
            aCoder.encode(p, forKey: "p")
        }
        if s != nil{
            aCoder.encode(s, forKey: "s")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}

class MediaMetadataPreview : NSObject, NSCoding{
    
    //URL
    var u : String!
    //Width
    var x : Int!
    //Height
    var y : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        u = json["u"].stringValue
        x = json["x"].intValue
        y = json["y"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if u != nil{
            dictionary["u"] = u
        }
        if x != nil{
            dictionary["x"] = x
        }
        if y != nil{
            dictionary["y"] = y
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        u = aDecoder.decodeObject(forKey: "u") as? String
        x = aDecoder.decodeObject(forKey: "x") as? Int
        y = aDecoder.decodeObject(forKey: "y") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if u != nil{
            aCoder.encode(u, forKey: "u")
        }
        if x != nil{
            aCoder.encode(x, forKey: "x")
        }
        if y != nil{
            aCoder.encode(y, forKey: "y")
        }
        
    }
    
}

class MediaMetadataSource : NSObject, NSCoding{
    
    // Image URL
    var u : String?
    var gif: String?
    var mp4: String?
    // Width
    var x : Int!
    // Height
    var y : Int!
    var aspectRatio : CGSize {
        return CGSize(width: x, height: y)
    }
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        u = json["u"].stringValue
        gif = json["gif"].stringValue
        mp4 = json["mp4"].stringValue
        x = json["x"].intValue
        y = json["y"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if u != nil{
            dictionary["u"] = u
        }
        if gif != nil{
            dictionary["gif"] = gif
        }
        if mp4 != nil{
            dictionary["mp4"] = mp4
        }
        if x != nil{
            dictionary["x"] = x
        }
        if y != nil{
            dictionary["y"] = y
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        u = aDecoder.decodeObject(forKey: "u") as? String
        gif = aDecoder.decodeObject(forKey: "gif") as? String
        mp4 = aDecoder.decodeObject(forKey: "mp4") as? String
        x = aDecoder.decodeObject(forKey: "x") as? Int
        y = aDecoder.decodeObject(forKey: "y") as? Int
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if u != nil{
            aCoder.encode(u, forKey: "u")
        }
        if gif != nil{
            aCoder.encode(gif, forKey: "gif")
        }
        if mp4 != nil{
            aCoder.encode(mp4, forKey: "mp4")
        }
        if x != nil{
            aCoder.encode(x, forKey: "x")
        }
        if y != nil{
            aCoder.encode(y, forKey: "y")
        }
    }
}
