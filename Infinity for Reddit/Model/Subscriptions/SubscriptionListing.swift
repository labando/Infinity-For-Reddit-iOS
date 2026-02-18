//
//  SubscriptionListing.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Foundation
import SwiftyJSON

class SubscriptionListingRootClass : NSObject {
    
    var kind : String!
    var subscriptionListing : SubscriptionListing?

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        kind = json["kind"].stringValue
        let listsJson = json["data"]
        if !listsJson.isEmpty {
            subscriptionListing = try SubscriptionListing(fromJson: listsJson)
        }
    }
}

public class SubscriptionListing : NSObject {
    
    var after : String!
    var subscriptions : [Subscription]!
    
    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        after = json["after"].stringValue
        subscriptions = [Subscription]()
        let childrenArray = json["children"].arrayValue
        for childrenJson in childrenArray {
            do {
                let value = try Subscription(fromJson: childrenJson)
                subscriptions.append(value)
            } catch {
                // Ignore
            }
        }
    }
}

class Subscription : NSObject {
    
    var kind : String!
    
    var acceptFollowers : Bool!
    var accountsActiveIsFuzzed : Bool!
    var advertiserCategory : String!
    var allOriginalContent : Bool!
    var allowDiscovery : Bool!
    var allowGalleries : Bool!
    var allowImages : Bool!
    var allowPolls : Bool!
    var allowPredictionContributors : Bool!
    var allowPredictions : Bool!
    var allowPredictionsTournament : Bool!
    var allowTalks : Bool!
    var allowVideogifs : Bool!
    var allowVideos : Bool!
    var allowedMediaInComments : [String]!
    var bannerBackgroundColor : String!
    var bannerBackgroundImage : String!
    var bannerImg : String!
    var bannerSize : [Int]!
    var canAssignLinkFlair : Bool!
    var canAssignUserFlair : Bool!
    var collapseDeletedComments : Bool!
    var commentContributionSettings : CommentContributionSetting?
    var commentScoreHideMins : Int!
    var communityIcon : String!
    var communityReviewed : Bool!
    var created : Int64!
    var createdUtc : Int64!
    var descriptionField : String!
    var descriptionHtml : String!
    var disableContributorRequests : Bool!
    var displayName : String!
    var displayNamePrefixed : String!
    var emojisEnabled : Bool!
    var freeFormReports : Bool!
    var hasMenuWidget : Bool!
    var headerImg : String!
    var headerSize : [Int]!
    var headerTitle : String!
    var hideAds : Bool!
    var iconImg : String!
    var iconSize : [Int]!
    var id : String!
    var isCrosspostableSubreddit : Bool?
    var isEnrolledInNewModmail : Bool?
    var keyColor : String!
    var lang : String!
    var linkFlairEnabled : Bool!
    var linkFlairPosition : String!
    var mobileBannerImage : String!
    var name : String!
    var notificationLevel : String!
    var originalContentTagEnabled : Bool!
    var over18 : Bool!
    var predictionLeaderboardEntryType : Int!
    var primaryColor : String!
    var publicDescription : String!
    var publicDescriptionHtml : String!
    var publicTraffic : Bool!
    var quarantine : Bool!
    var restrictCommenting : Bool!
    var restrictPosting : Bool!
    var shouldArchivePosts : Bool!
    var shouldShowMediaInCommentsSetting : Bool!
    var showMedia : Bool!
    var showMediaPreview : Bool!
    var spoilersEnabled : Bool!
    var submissionType : String!
    var submitLinkLabel : String!
    var submitText : String!
    var submitTextHtml : String!
    var submitTextLabel : String!
    var subredditType : String!
    var subscribers : Int!
    var suggestedCommentSort : String?
    var title : String!
    var url : String!
    var userFlairEnabledInSr : Bool!
    var userFlairPosition : String!
    var userFlairRichtext : [UserFlairRichtext]!
    var userFlairType : String!
    var userHasFavorited : Bool!
    var userIsBanned : Bool!
    var userIsContributor : Bool!
    var userIsModerator : Bool!
    var userIsMuted : Bool!
    var userIsSubscriber : Bool!
    var userSrThemeEnabled : Bool!
    var videostreamLinksCount : Int!
    var wikiEnabled : Bool?
    var wls : Int!
    

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        kind = json["kind"].stringValue
        
        let dataJson = json["data"]
        if !dataJson.isEmpty {
            acceptFollowers = dataJson["accept_followers"].boolValue
            accountsActiveIsFuzzed = dataJson["accounts_active_is_fuzzed"].boolValue
            advertiserCategory = dataJson["advertiser_category"].stringValue
            allOriginalContent = dataJson["all_original_content"].boolValue
            allowDiscovery = dataJson["allow_discovery"].boolValue
            allowGalleries = dataJson["allow_galleries"].boolValue
            allowImages = dataJson["allow_images"].boolValue
            allowPolls = dataJson["allow_polls"].boolValue
            allowPredictionContributors = dataJson["allow_prediction_contributors"].boolValue
            allowPredictions = dataJson["allow_predictions"].boolValue
            allowPredictionsTournament = dataJson["allow_predictions_tournament"].boolValue
            allowTalks = dataJson["allow_talks"].boolValue
            allowVideogifs = dataJson["allow_videogifs"].boolValue
            allowVideos = dataJson["allow_videos"].boolValue
            allowedMediaInComments = [String]()
            let allowedMediaInCommentsArray = dataJson["allowed_media_in_comments"].arrayValue
            for allowedMediaInCommentsJson in allowedMediaInCommentsArray{
                allowedMediaInComments.append(allowedMediaInCommentsJson.stringValue)
            }
            bannerBackgroundColor = dataJson["banner_background_color"].stringValue
            bannerBackgroundImage = dataJson["banner_background_image"].stringValue
            bannerImg = dataJson["banner_img"].stringValue
            bannerSize = [Int]()
            let bannerSizeArray = dataJson["banner_size"].arrayValue
            for bannerSizeJson in bannerSizeArray{
                bannerSize.append(bannerSizeJson.intValue)
            }
            canAssignLinkFlair = dataJson["can_assign_link_flair"].boolValue
            canAssignUserFlair = dataJson["can_assign_user_flair"].boolValue
            collapseDeletedComments = dataJson["collapse_deleted_comments"].boolValue
            let commentContributionSettingsJson = dataJson["comment_contribution_settings"]
            if !commentContributionSettingsJson.isEmpty {
                commentContributionSettings = try? CommentContributionSetting(fromJson: commentContributionSettingsJson)
            }
            commentScoreHideMins = dataJson["comment_score_hide_mins"].intValue
            communityIcon = dataJson["community_icon"].stringValue
            communityReviewed = dataJson["community_reviewed"].boolValue
            created = dataJson["created"].int64Value
            createdUtc = dataJson["created_utc"].int64Value
            descriptionField = dataJson["description"].stringValue
            descriptionHtml = dataJson["description_html"].stringValue
            disableContributorRequests = dataJson["disable_contributor_requests"].boolValue
            displayName = dataJson["display_name"].stringValue
            displayNamePrefixed = dataJson["display_name_prefixed"].stringValue
            emojisEnabled = dataJson["emojis_enabled"].boolValue
            freeFormReports = dataJson["free_form_reports"].boolValue
            hasMenuWidget = dataJson["has_menu_widget"].boolValue
            headerImg = dataJson["header_img"].stringValue
            headerSize = [Int]()
            let headerSizeArray = dataJson["header_size"].arrayValue
            for headerSizeJson in headerSizeArray{
                headerSize.append(headerSizeJson.intValue)
            }
            headerTitle = dataJson["header_title"].stringValue
            hideAds = dataJson["hide_ads"].boolValue
            iconImg = dataJson["icon_img"].stringValue
            iconSize = [Int]()
            let iconSizeArray = dataJson["icon_size"].arrayValue
            for iconSizeJson in iconSizeArray{
                iconSize.append(iconSizeJson.intValue)
            }
            id = dataJson["id"].stringValue
            isCrosspostableSubreddit = dataJson["is_crosspostable_subreddit"].boolValue
            isEnrolledInNewModmail = dataJson["is_enrolled_in_new_modmail"].boolValue
            keyColor = dataJson["key_color"].stringValue
            lang = dataJson["lang"].stringValue
            linkFlairEnabled = dataJson["link_flair_enabled"].boolValue
            linkFlairPosition = dataJson["link_flair_position"].stringValue
            mobileBannerImage = dataJson["mobile_banner_image"].stringValue
            name = dataJson["name"].stringValue
            notificationLevel = dataJson["notification_level"].stringValue
            originalContentTagEnabled = dataJson["original_content_tag_enabled"].boolValue
            over18 = dataJson["over18"].boolValue
            predictionLeaderboardEntryType = dataJson["prediction_leaderboard_entry_type"].intValue
            primaryColor = dataJson["primary_color"].stringValue
            publicDescription = dataJson["public_description"].stringValue
            publicDescriptionHtml = dataJson["public_description_html"].stringValue
            publicTraffic = dataJson["public_traffic"].boolValue
            quarantine = dataJson["quarantine"].boolValue
            restrictCommenting = dataJson["restrict_commenting"].boolValue
            restrictPosting = dataJson["restrict_posting"].boolValue
            shouldArchivePosts = dataJson["should_archive_posts"].boolValue
            shouldShowMediaInCommentsSetting = dataJson["should_show_media_in_comments_setting"].boolValue
            showMedia = dataJson["show_media"].boolValue
            showMediaPreview = dataJson["show_media_preview"].boolValue
            spoilersEnabled = dataJson["spoilers_enabled"].boolValue
            submissionType = dataJson["submission_type"].stringValue
            submitLinkLabel = dataJson["submit_link_label"].stringValue
            submitText = dataJson["submit_text"].stringValue
            submitTextHtml = dataJson["submit_text_html"].stringValue
            submitTextLabel = dataJson["submit_text_label"].stringValue
            subredditType = dataJson["subreddit_type"].stringValue
            subscribers = dataJson["subscribers"].intValue
            suggestedCommentSort = dataJson["suggested_comment_sort"].stringValue
            title = dataJson["title"].stringValue
            url = dataJson["url"].stringValue
            userFlairEnabledInSr = dataJson["user_flair_enabled_in_sr"].boolValue
            userFlairPosition = dataJson["user_flair_position"].stringValue
            userFlairRichtext = [UserFlairRichtext]()
            let userFlairRichtextArray = dataJson["user_flair_richtext"].arrayValue
            for userFlairRichtextJson in userFlairRichtextArray {
                do {
                    let singleUserFlairRichtext = try UserFlairRichtext(fromJson: userFlairRichtextJson)
                    userFlairRichtext.append(singleUserFlairRichtext)
                } catch {
                    // Ignore
                }
            }
            userFlairType = dataJson["user_flair_type"].stringValue
            userHasFavorited = dataJson["user_has_favorited"].boolValue
            userIsBanned = dataJson["user_is_banned"].boolValue
            userIsContributor = dataJson["user_is_contributor"].boolValue
            userIsModerator = dataJson["user_is_moderator"].boolValue
            userIsMuted = dataJson["user_is_muted"].boolValue
            userIsSubscriber = dataJson["user_is_subscriber"].boolValue
            userSrThemeEnabled = dataJson["user_sr_theme_enabled"].boolValue
            videostreamLinksCount = dataJson["videostream_links_count"].intValue
            wikiEnabled = dataJson["wiki_enabled"].boolValue
            wls = dataJson["wls"].intValue
        }
    }
}

class CommentContributionSetting : NSObject {
    
    var allowedMediaTypes : [String]!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        allowedMediaTypes = [String]()
        let allowedMediaTypesArray = json["allowed_media_types"].arrayValue
        for allowedMediaTypesJson in allowedMediaTypesArray{
            allowedMediaTypes.append(allowedMediaTypesJson.stringValue)
        }
    }
}

class UserFlairRichtext : NSObject {
    
    //Type e.g. "text", "emoji"
    var e : String!
    //Text
    var t : String!
    //Media id, e.g. :pixel9proxlporcelain: (Not sure)
    var a : String!
    //Media URL
    var u : String!

    init(fromJson json: JSON!) throws {
        if json.isEmpty {
            throw JSONError.invalidData
        }
        e = json["e"].stringValue
        t = json["t"].stringValue
        a = json["a"].stringValue
        u = json["u"].stringValue
    }
}
