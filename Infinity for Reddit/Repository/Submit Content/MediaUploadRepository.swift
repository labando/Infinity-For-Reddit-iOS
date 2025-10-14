//
//  MediaUploadRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-14.
//

import UIKit
import Alamofire
import SwiftyJSON

class MediaUploadRepository: MediaUploadRepositoryProtocol {
    enum MediaUploadRepositoryError: LocalizedError {
        case failedToExtractURL
        
        var errorDescription: String? {
            switch self {
            case .failedToExtractURL:
                return "Failed to extract URL from response"
            }
        }
    }
    
    private let session: Session
    
    init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self, name: "plain") else {
            fatalError("Failed to resolve plain Session in MediaUploadRepository")
        }
        self.session = resolvedSession
    }
    
    func uploadImage(account: Account, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data")
            return ""
        }
        
        let params = [
            "filepath": "post_image.jpg",
            "mimetype": "image/jpeg"
        ]
        
        let interceptor = await TokenCenter.shared.getRedditPerAccountInterceptor(account: account)
        let metadataResponseData = try await self.session.request(RedditOAuthAPI.uploadMediaMetadata(params: params), interceptor: interceptor)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        let json = JSON(metadataResponseData)
        if let error = json.error {
            throw APIError.jsonDecodingError(error.localizedDescription)
        }
        
        let dataDictionary = try self.getDataDictionary(from: json)
        
        let uploadImageResponseData = try await self.session.upload(
            multipartFormData: { formData in
                for (key, value) in dataDictionary {
                    formData.append(value, withName: key)
                }
                
                formData.append(
                    imageData,
                    withName: "file",
                    fileName: "post_image.jpg",
                    mimeType: "image/jpeg"
                )
            },
            with: MediaUploadAPI.uploadMedia
        )
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        if let imageUrlString = getImageURLString(uploadImageResponseData, getImageKey: false) {
            return imageUrlString
        }
        
        throw MediaUploadRepositoryError.failedToExtractURL
    }
    
    func uploadGIF(account: Account, gifData: Data) async throws -> String {
        let params = [
            "filepath": "post_gif.gif",
            "mimetype": "image/gif"
        ]
        
        let interceptor = await TokenCenter.shared.getRedditPerAccountInterceptor(account: account)
        let metadataResponseData = try await self.session.request(RedditOAuthAPI.uploadMediaMetadata(params: params), interceptor: interceptor)
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        let json = JSON(metadataResponseData)
        if let error = json.error {
            throw APIError.jsonDecodingError(error.localizedDescription)
        }
        
        let dataDictionary = try self.getDataDictionary(from: json)
        
        let uploadImageResponseData = try await self.session.upload(
            multipartFormData: { formData in
                for (key, value) in dataDictionary {
                    formData.append(value, withName: key)
                }
                
                formData.append(
                    gifData,
                    withName: "file",
                    fileName: "post_gif.gif",
                    mimeType: "image/gif"
                )
            },
            with: MediaUploadAPI.uploadMedia
        )
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        if let gifUrlString = getImageURLString(uploadImageResponseData, getImageKey: false) {
            return gifUrlString
        }
        
        throw MediaUploadRepositoryError.failedToExtractURL
    }
    
    private func getDataDictionary(from json: JSON) throws -> [String: Data] {
        let nameValuePairs = json["args"]["fields"].arrayValue
        
        var nameValuePairsMap: [String: Data] = [:]
        
        for pair in nameValuePairs {
            let name = pair["name"].stringValue
            let value = pair["value"].stringValue
            nameValuePairsMap[name] = Data(value.utf8)
        }
        
        return nameValuePairsMap
    }
    
    private func getImageURLString(_ responseData: Data, getImageKey: Bool) -> String? {
        
        class ParserDelegate: NSObject, XMLParserDelegate {
            var result: String?
            var getImageKey: Bool
            var isTargetTag = false
            
            init(getImageKey: Bool) {
                self.getImageKey = getImageKey
            }
            
            func parser(_ parser: XMLParser, didStartElement elementName: String,
                        namespaceURI: String?, qualifiedName qName: String?,
                        attributes attributeDict: [String : String] = [:]) {
                if (elementName == "Key" && getImageKey) || (elementName == "Location" && !getImageKey) {
                    isTargetTag = true
                }
            }
            
            func parser(_ parser: XMLParser, foundCharacters string: String) {
                if isTargetTag {
                    result = string
                    parser.abortParsing()
                }
            }
        }
        
        let delegate = ParserDelegate(getImageKey: getImageKey)
        let parser = XMLParser(data: responseData)
        parser.delegate = delegate
        parser.parse()
        
        return delegate.result
    }
}
