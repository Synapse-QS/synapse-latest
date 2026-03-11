import Foundation
import shared

/// A helper to initialize the KMP dependencies. Since Hilt is used in Android,
/// and iOS doesn't have a fully exported Koin/DI setup shown, we manually construct
/// the required UseCases for iOS, or rely on a generic entry point if one existed.
/// We will instantiate SupabaseChatRepository or a mock.

@MainActor
class KMPHelper {
    static let sharedHelper = KMPHelper()

    // In a real app, you would expose a Koin injector or initialize this cleanly.
    // For this implementation, we will mock the dependencies if the concrete
    // implementations aren't fully exposed to Swift, or use the concrete ones if they are.

    let chatRepository: shared.ChatRepository

    let getConversationsUseCase: shared.GetConversationsUseCase
    let getMessagesUseCase: shared.GetMessagesUseCase
    let subscribeToMessagesUseCase: shared.SubscribeToMessagesUseCase
    let sendMessageUseCase: shared.SendMessageUseCase

    let uploadMediaUseCase: shared.UploadMediaUseCase

    init() {
        // We instantiate the real SupabaseChatRepository exposed by KMP.
        // The default constructor arguments in Kotlin (dataSource, client, etc.)
        // allow us to initialize it without passing dependencies manually.
        self.chatRepository = shared.SupabaseChatRepository(dataSource: shared.SupabaseChatDataSource(), client: shared.SupabaseClient.shared.client, signalProtocolManager: nil)

        self.getConversationsUseCase = shared.GetConversationsUseCase(repository: chatRepository)
        self.getMessagesUseCase = shared.GetMessagesUseCase(repository: chatRepository)
        self.subscribeToMessagesUseCase = shared.SubscribeToMessagesUseCase(repository: chatRepository)
        self.sendMessageUseCase = shared.SendMessageUseCase(repository: chatRepository)
        self.uploadMediaUseCase = shared.UploadMediaUseCase(repository: chatRepository)
    }
}
