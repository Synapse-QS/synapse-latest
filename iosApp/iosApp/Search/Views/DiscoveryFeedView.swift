import SwiftUI
import shared

struct DiscoveryFeedView: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Recommended Users
                if !viewModel.suggestedUsers.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Suggested Accounts")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.suggestedUsers, id: \.id) { user in
                                    SuggestedUserCard(user: user)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Trending Hashtags
                if !viewModel.trendingHashtags.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Trending Now")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal)

                        VStack(spacing: 0) {
                            ForEach(viewModel.trendingHashtags.prefix(10), id: \.id) { hashtag in
                                HashtagResultRow(hashtag: hashtag, isTrending: true)
                                    .onTapGesture {
                                        viewModel.searchQuery = hashtag.tag
                                        viewModel.selectedCategory = .hashtags
                                    }

                                if hashtag.id != viewModel.trendingHashtags.prefix(10).last?.id {
                                    Divider()
                                        .padding(.leading, 76)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                }

                // Bottom Padding
                Spacer(minLength: 40)
            }
            .padding(.top, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SuggestedUserCard: View {
    let user: SearchAccount

    var body: some View {
        VStack(spacing: 8) {
            // Avatar Placeholder
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Text(user.displayName?.prefix(1).uppercased() ?? user.handle?.prefix(1).uppercased() ?? "?")
                        .foregroundColor(.gray)
                        .font(.title3)
                )

            VStack(spacing: 2) {
                Text(user.displayName ?? user.handle ?? "Unknown")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text("@\(user.handle ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Button(action: {
                // To be implemented
            }) {
                Text("Follow")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 4)
        }
        .padding()
        .frame(width: 140)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
