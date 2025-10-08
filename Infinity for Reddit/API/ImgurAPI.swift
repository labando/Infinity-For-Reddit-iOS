//
//  ImgurAPI.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-07.
//

import Alamofire
import Foundation

enum ImgurAPI: URLRequestConvertible {
    case getGalleryImages(imgurId: String)
    case getAlbumImages(imgurId: String)
    case getImage(imgurId: String)
    
    private var baseURL: String {
        return APIUtils.IMGUR_API_BASE_URI
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getGalleryImages(let imgurId):
            return "/gallery/\(imgurId)"
        case .getAlbumImages(let imgurId):
            return "/album/\(imgurId)"
        case .getImage(let imgurId):
            return "/image/\(imgurId)"
        }
    }
    
    var parameters: [String: String]? {
        return nil
    }
    
    var queries: [String: String]? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization": "Client-ID cc671794e0ab397"]
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL().appendingPathComponent(path)
        //Setup query params
        if let queries = queries {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queries.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            if let updatedURL = urlComponents.url {
                url = updatedURL
            }
        }
        //Set up method and headers
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers ?? HTTPHeaders()
        
        //Setup URL encoded form data
        let formEncodedData = parameters?.map { key, value in
            "\(key)=\(value)"
        }.joined(separator: "&")
        request.httpBody = formEncodedData?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
