//
//  UserDetail.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-02.
//

import Foundation
import SwiftyJSON
import GRDB

class UserDetailRootClass : NSObject {
    var data : User!
    var kind : String!
    
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        let dataJson = json["data"]
        if !dataJson.isEmpty {
            data = User(fromJson: dataJson)
        }
        kind = json["kind"].stringValue
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
