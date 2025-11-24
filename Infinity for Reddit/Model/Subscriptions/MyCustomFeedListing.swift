//
//  MyCustomFeedListing.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Foundation
import SwiftyJSON

public class MyCustomFeedListing : NSObject {
    var customFeeds : [CustomFeed]!
    var kind : String!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        customFeeds = [CustomFeed]()
        let childrenArray = json.arrayValue
        for childrenJson in childrenArray {
            do {
                let value = try CustomFeed(fromJson: childrenJson["data"])
                customFeeds.append(value)
            } catch {
                // Ignore
            }
        }
    }
}

class CustomFeed : NSObject {
    var canEdit : Bool!
    var copiedFrom: String!
    var created : Float!
    var createdUtc : Int64!
    var descriptionHtml : String!
    var descriptionMd : String!
    var displayName : String!
    var iconUrl : String!
    var isFavorited : Bool!
    var isSubscriber : Bool!
    var name : String!
    var numSubscribers : Int!
    var over18 : Bool!
    var owner : String!
    var ownerId : String!
    var path : String!
    var subredditsInCustomFeed : [SubredditInCustomFeed]!
    var visibility : String!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        canEdit = json["can_edit"].boolValue
        copiedFrom = json["copied_from"].stringValue
        created = json["created"].floatValue
        createdUtc = json["created_utc"].int64Value
        descriptionHtml = json["description_html"].stringValue
        descriptionMd = json["description_md"].stringValue
        displayName = json["display_name"].stringValue
        iconUrl = json["icon_url"].stringValue
        isFavorited = json["is_favorited"].boolValue
        isSubscriber = json["is_subscriber"].boolValue
        name = json["name"].stringValue
        numSubscribers = json["num_subscribers"].intValue
        over18 = json["over_18"].boolValue
        owner = json["owner"].stringValue
        ownerId = json["owner_id"].stringValue
        path = json["path"].stringValue
        subredditsInCustomFeed = [SubredditInCustomFeed]()
        let subredditsArray = json["subreddits"].arrayValue
        for subredditsJson in subredditsArray {
            do {
                let value = try SubredditInCustomFeed(fromJson: subredditsJson)
                subredditsInCustomFeed.append(value)
            } catch {
                // Ignore
            }
        }
        visibility = json["visibility"].stringValue
    }
    
    func toMyCustomFeed() -> MyCustomFeed {
        return MyCustomFeed(
            path: path,
            displayName: displayName,
            name: name,
            description: descriptionMd,
            copiedFrom: copiedFrom,
            iconUrl: iconUrl,
            visibility: visibility,
            owner: owner,
            nSubscribers: numSubscribers,
            createdUTC: createdUtc,
            over18: over18,
            isSubscriber: isSubscriber,
            isFavorite: isFavorited
        )
    }
}

class SubredditInCustomFeed : NSObject, Identifiable {
    var name : String
    
    var id: String {
        name
    }

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        name = json["name"].stringValue
    }
    
    init(name: String) {
        self.name = name
    }
}

class SubredditInCustomFeedExpandedData : NSObject, Identifiable {
    var acceptFollowers : Bool!
    var allowedMediaInComments : [String]!
    var bannerImg : String!
    var bannerSize : Size?
    var communityIcon : String!
    var created : Float!
    var createdUtc : Float!
    var defaultSet : Bool!
    var descriptionField : String!
    var disableContributorRequests : Bool!
    var displayName : String!
    var displayNamePrefixed : String!
    var freeFormReports : Bool!
    var headerImg : String!
    var headerSize : Size?
    var iconColor : String!
    var iconImg : String!
    var iconSize : Size?
    var keyColor : String!
    var linkFlairEnabled : Bool!
    var linkFlairPosition : String!
    var name : String!
    var over18 : Bool!
    var previousNames : [String]!
    var primaryColor : String!
    var publicDescription : String!
    var quarantine : Bool!
    var restrictCommenting : Bool!
    var restrictPosting : Bool!
    var showMedia : Bool!
    var submitLinkLabel : String!
    var submitTextLabel : String!
    var subredditType : String!
    var subscribers : Int!
    var title : String!
    var url : String!
    var userIsBanned : Bool!
    var userIsContributor : Bool!
    var userIsModerator : Bool!
    var userIsMuted : Bool!
    var userIsSubscriber : Bool!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        acceptFollowers = json["accept_followers"].boolValue
        allowedMediaInComments = [String]()
        let allowedMediaInCommentsArray = json["allowed_media_in_comments"].arrayValue
        for allowedMediaInCommentsJson in allowedMediaInCommentsArray {
            allowedMediaInComments.append(allowedMediaInCommentsJson.stringValue)
        }
        bannerImg = json["banner_img"].stringValue
        bannerSize = JSONUtils.parseNullableSize(json, "banner_size")
        communityIcon = json["community_icon"].stringValue
        created = json["created"].floatValue
        createdUtc = json["created_utc"].floatValue
        defaultSet = json["default_set"].boolValue
        descriptionField = json["description"].stringValue
        disableContributorRequests = json["disable_contributor_requests"].boolValue
        displayName = json["display_name"].stringValue
        displayNamePrefixed = json["display_name_prefixed"].stringValue
        freeFormReports = json["free_form_reports"].boolValue
        headerImg = json["header_img"].stringValue
        headerSize = JSONUtils.parseNullableSize(json, "header_size")
        iconColor = json["icon_color"].stringValue
        iconImg = json["icon_img"].stringValue
        iconSize = JSONUtils.parseNullableSize(json, "icon_size")
        keyColor = json["key_color"].stringValue
        linkFlairEnabled = json["link_flair_enabled"].boolValue
        linkFlairPosition = json["link_flair_position"].stringValue
        name = json["name"].stringValue
        over18 = json["over_18"].boolValue
        previousNames = [String]()
        let previousNamesArray = json["previous_names"].arrayValue
        for previousNamesJson in previousNamesArray {
            previousNames.append(previousNamesJson.stringValue)
        }
        primaryColor = json["primary_color"].stringValue
        publicDescription = json["public_description"].stringValue
        quarantine = json["quarantine"].boolValue
        restrictCommenting = json["restrict_commenting"].boolValue
        restrictPosting = json["restrict_posting"].boolValue
        showMedia = json["show_media"].boolValue
        submitLinkLabel = json["submit_link_label"].stringValue
        submitTextLabel = json["submit_text_label"].stringValue
        subredditType = json["subreddit_type"].stringValue
        subscribers = json["subscribers"].intValue
        title = json["title"].stringValue
        url = json["url"].stringValue
        userIsBanned = json["user_is_banned"].boolValue
        userIsContributor = json["user_is_contributor"].boolValue
        userIsModerator = json["user_is_moderator"].boolValue
        userIsMuted = json["user_is_muted"].boolValue
        userIsSubscriber = json["user_is_subscriber"].boolValue
    }
}
