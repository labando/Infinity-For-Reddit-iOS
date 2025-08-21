//
//  SubmitCommentRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-21.
//

import Alamofire
import SwiftyJSON

class SubmitCommentRepository: SubmitCommentRepositoryProtocol {
    enum SubmitCommentRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
        case SendCommentError(String)
    }
    
    func submitComment(accout: Account, content: String, parentFullname: String, depth: Int) async throws -> Comment {
        guard !accout.isAnonymous() else {
            throw SubmitCommentRepositoryError.SendCommentError("Please choose an account to submit as.")
        }
        
        guard !content.isEmpty else {
            throw SubmitCommentRepositoryError.SendCommentError("Where are your interesting thoughts?")
        }
        
        let session = SessionProvider.getAccountSpecificSession(account: accout)
        let params = ["api_type": "json", "return_rtjson": "true", "text": content, "thing_id": parentFullname]
        print(params)
        
        try Task.checkCancellation()
        
        let data = try await session.request(RedditOAuthAPI.sendCommentOrReplyToMessage(params: params))
            .validate()
            .serializingData(automaticallyCancelling: true)
            .value
        
        let json = JSON(data)
        if let error = json.error {
            throw SubmitCommentRepositoryError.JSONDecodingError(error.localizedDescription)
        }
        
        let errorArray = json["json"]["errors"].array
        if let errorArray = errorArray, !errorArray.isEmpty {
            if let lastErrorArray = errorArray.last?.array, !lastErrorArray.isEmpty {
                let errorString: String
                if lastErrorArray.count >= 2 {
                    errorString = lastErrorArray[1].stringValue
                } else {
                    errorString = lastErrorArray[0].stringValue
                }
                throw(SubmitCommentRepositoryError.SendCommentError(errorString.prefix(1).uppercased() + errorString.dropFirst()))
            } else {
                throw(SubmitCommentRepositoryError.SendCommentError("Error submitting comment"))
            }
        }
        
        let comment = try Comment(fromJson: json)
        if comment.id.isEmpty {
            // This is a work around for checking if JSON parsing failed
            throw(SubmitCommentRepositoryError.SendCommentError("Error getting your sent comment"))
        }
        comment.depth = depth
        return comment
    }
}
