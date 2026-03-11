import SwiftUI

struct PostDetailView: View {
    @StateObject private var viewModel: PostDetailViewModel

    init(post: Post) {
        _viewModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // Full Post Card
                    PostCardView(
                        post: viewModel.post,
                        onLike: { /* Detail like logic */ },
                        onComment: { /* Scroll to comment field */ },
                        onShare: { /* Detail share logic */ },
                        onBookmark: { /* Detail bookmark logic */ }
                    )

                    Divider()
                        .padding(.vertical, 8)

                    // Comments Header
                    HStack {
                        Text("Comments")
                            .font(.headline)
                        Spacer()
                        Text("\(viewModel.post.commentsCount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    // Comments List
                    if viewModel.isLoading {
                        ProgressView("Loading comments...")
                            .padding()
                    } else if viewModel.comments.isEmpty {
                        Text("No comments yet. Be the first to comment!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.comments) { comment in
                                CommentRowView(comment: comment)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }

            Divider()

            // Comment Input Area
            HStack {
                TextField("Add a comment...", text: $viewModel.commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(viewModel.isSubmittingComment)

                Button(action: {
                    viewModel.submitComment()
                }) {
                    if viewModel.isSubmittingComment {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(viewModel.commentText.isEmpty ? .gray : .blue)
                            .font(.system(size: 20))
                    }
                }
                .disabled(viewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSubmittingComment)
            }
            .padding()
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.bottom))
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentRowView: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(comment.authorDisplayName?.prefix(1) ?? comment.authorUsername.prefix(1)).uppercased())
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(comment.authorDisplayName ?? comment.authorUsername)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("@\(comment.authorUsername)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(comment.createdAt)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Text(comment.text)
                    .font(.subheadline)
                    .foregroundColor(.primary)

                HStack(spacing: 16) {
                    Button(action: { /* Like comment */ }) {
                        Text("Like")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Button(action: { /* Reply comment */ }) {
                        Text("Reply")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}
