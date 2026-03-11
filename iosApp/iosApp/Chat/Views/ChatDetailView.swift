import SwiftUI
import shared

struct ChatDetailView: View {
    let chatId: String
    let participantName: String

    @StateObject private var viewModel = ChatViewModel()

    // In a real app we'd inject currentUserId to know which messages are "mine"
    // Assuming we have a mock "my_user_id" or get it from auth context
    private let currentUserId = "my_user_id"

    var body: some View {
        VStack(spacing: 0) {
            // Message List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        if viewModel.isLoading && viewModel.messages.isEmpty {
                            ProgressView()
                                .padding()
                        } else {
                            ForEach(viewModel.messages) { message in
                                MessageBubbleView(
                                    message: message,
                                    isFromMe: message.senderId == currentUserId
                                )
                                .id(message.id)
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // Scroll to bottom when new message arrives
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let lastMessage = viewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }

            // Error banner if any
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.bottom, 4)
            }

            // Input Area
            ChatInputView(
                isSending: viewModel.isSending,
                onSendText: { text in
                    viewModel.sendMessage(content: text)
                },
                onAttachMedia: { data, name, mime in
                    if let d = data, let n = name, let m = mime {
                        viewModel.sendMediaMessage(data: d, fileName: n, mimeType: m)
                    }
                }
            )
        }
        .navigationTitle(participantName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.setup(chatId: chatId)
        }
    }
}
