import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
    @Published var post: Post
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var isSubmittingComment = false
    @Published var commentText: String = ""

    init(post: Post) {
        self.post = post
        fetchComments()
    }

    func fetchComments() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.comments = [
                Comment(id: UUID().uuidString, postId: self.post.id, authorUid: "1", text: "This is a great post!", authorUsername: "user1", authorDisplayName: "User One", createdAt: "1h ago"),
                Comment(id: UUID().uuidString, postId: self.post.id, authorUid: "2", text: "I completely agree with you.", authorUsername: "user2", authorDisplayName: "User Two", createdAt: "30m ago")
            ]
            self.isLoading = false
        }
    }

    func submitComment() {
        guard !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isSubmittingComment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newComment = Comment(id: UUID().uuidString, postId: self.post.id, authorUid: "me", text: self.commentText, authorUsername: "me_user", authorDisplayName: "Me", createdAt: "Just now")
            self.comments.insert(newComment, at: 0)
            self.commentText = ""
            self.isSubmittingComment = false

            // Increment post comments count optimistically
            self.post = Post(
                id: self.post.id,
                authorUid: self.post.authorUid,
                postText: self.post.postText,
                postImage: self.post.postImage,
                postType: self.post.postType,
                likesCount: self.post.likesCount,
                commentsCount: self.post.commentsCount + 1,
                viewsCount: self.post.viewsCount,
                resharesCount: self.post.resharesCount,
                mediaItems: self.post.mediaItems,
                hasPoll: self.post.hasPoll,
                pollQuestion: self.post.pollQuestion,
                pollOptions: self.post.pollOptions,
                createdAt: self.post.createdAt,
                updatedAt: self.post.updatedAt,
                username: self.post.username,
                displayName: self.post.displayName,
                avatarUrl: self.post.avatarUrl,
                isVerified: self.post.isVerified,
                isBookmarked: self.post.isBookmarked,
                isReshared: self.post.isReshared,
                userReaction: self.post.userReaction,
                reactions: self.post.reactions
            )
        }
    }
}

struct Comment: Identifiable {
    let id: String
    let postId: String
    let authorUid: String
    let text: String
    let authorUsername: String
    let authorDisplayName: String?
    let authorAvatarUrl: String? = nil
    let createdAt: String
}
