import Foundation

struct PollOption: Codable, Identifiable {
    let id: Int
    let text: String
    var votes: Int
}

struct FeelingActivity: Codable {
    let emoji: String
    let text: String
    let type: String
}

struct PostMetadata: Codable {
    let layoutType: String?
    let taggedPeople: [User]?
    let feeling: FeelingActivity?
    let backgroundColor: Int64?

    enum CodingKeys: String, CodingKey {
        case layoutType = "layout_type"
        case taggedPeople = "tagged_people"
        case feeling
        case backgroundColor = "background_color"
    }
}

struct Post: Codable, Identifiable {
    let id: String
    let authorUid: String
    let postText: String?
    var postImage: String?
    var postType: String?

    let likesCount: Int
    let commentsCount: Int
    let viewsCount: Int
    let resharesCount: Int

    var mediaItems: [MediaItem]?

    let hasPoll: Bool?
    let pollQuestion: String?
    let pollOptions: [PollOption]?

    let createdAt: String?
    let updatedAt: String?

    // UI specific properties mapped manually or parsed
    var username: String?
    var displayName: String?
    var avatarUrl: String?
    var isVerified: Bool = false

    var isBookmarked: Bool = false
    var isReshared: Bool = false

    var userReaction: ReactionType?
    var reactions: [String: Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case authorUid = "author_uid"
        case postText = "post_text"
        case postImage = "post_image"
        case postType = "post_type"

        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case viewsCount = "views_count"
        case resharesCount = "reshares_count"

        case mediaItems = "media_items"

        case hasPoll = "has_poll"
        case pollQuestion = "poll_question"
        case pollOptions = "poll_options"

        case createdAt = "created_at"
        case updatedAt = "updated_at"

        case username = "author_username"
        case avatarUrl = "author_avatar_url"
        case isVerified = "author_is_verified"
    }
}
