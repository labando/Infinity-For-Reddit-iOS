//
//  MediaUploadRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-14.
//

import UIKit
import Alamofire
import SwiftyJSON
import UniformTypeIdentifiers

class MediaUploadRepository: MediaUploadRepositoryProtocol {
    enum MediaUploadRepositoryError: LocalizedError {
        case failedToGetImageData
        case failedToExtractImageURL
        case failedToExtractImageId
        case failedToExtractGIFURL
        case failedToExtractVideoURL
        
        var errorDescription: String? {
            switch self {
            case .failedToGetImageData:
                return "Could not get image data"
            case .failedToExtractImageURL:
                return "Could not extract image URL from response"
            case .failedToExtractImageId:
                return "Could not extract image ID from response"
            case .failedToExtractGIFURL:
                return "Could not extract GIF URL from response"
            case .failedToExtractVideoURL:
                return "Could not extract video URL from response"
            
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
    
    // Return image URL or image ID
    func uploadImage(account: Account, image: UIImage, getImageId: Bool) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw MediaUploadRepositoryError.failedToGetImageData
        }
        
        let params = [
            "filepath": "post_image.jpg",
            "mimetype": "image/jpeg"
        ]
        
        let interceptor = await RedditAccessTokenProvider.shared.getRedditPerAccountInterceptor(account: account)
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
        
        if getImageId {
            if let imageId = self.getImageId(metadataResponseData) {
                print(imageId)
                return imageId
            }
            
            throw MediaUploadRepositoryError.failedToExtractImageId
        } else {
            if let imageUrlString = getImageURLString(uploadImageResponseData, getImageKey: false) {
                return imageUrlString
            }
            
            throw MediaUploadRepositoryError.failedToExtractImageURL
        }
    }
    
    func uploadGIF(account: Account, gifData: Data) async throws -> String {
        let params = [
            "filepath": "post_gif.gif",
            "mimetype": "image/gif"
        ]
        
        let interceptor = await RedditAccessTokenProvider.shared.getRedditPerAccountInterceptor(account: account)
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
        
        throw MediaUploadRepositoryError.failedToExtractGIFURL
    }
    
    func uploadVideo(account: Account, videoURL: URL) async throws -> String {
        let mimeType = getVideoMimeType(url: videoURL)
        var params = [
            "mimetype": mimeType
        ]
        let fileName: String
        if let fileExtension = mimeType.split(separator: "/").last {
            fileName = "post_video.\(fileExtension)"
        } else {
            fileName = "post_video.mp4"
        }
        params["filepath"] = fileName
        
        let interceptor = await RedditAccessTokenProvider.shared.getRedditPerAccountInterceptor(account: account)
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
                    videoURL,
                    withName: "file",
                    fileName: fileName,
                    mimeType: mimeType
                )
            },
            with: MediaUploadAPI.uploadVideo
        )
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        if let videoUrlString = getImageURLString(uploadImageResponseData, getImageKey: false) {
            return videoUrlString
        }
        
        throw MediaUploadRepositoryError.failedToExtractVideoURL
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
    
    private func getImageId(_ responseData: Data) -> String? {
        return JSON(responseData)["asset"]["asset_id"].string
    }
    
    func getVideoMimeType(url: URL) -> String {
        if let type = UTType(filenameExtension: url.pathExtension), let mime = type.preferredMIMEType {
            return mime
        }
        return "video/mp4"
    }
}
