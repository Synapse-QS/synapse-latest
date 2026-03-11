# Implement Message Reaction in Chat

This feature adds the ability for users to react to individual chat messages with emojis, similar to the existing post and comment reaction systems.

## Proposed Changes

### Database Layer
- **Migration**: Create a new table `message_reactions` (similar to `comment_reactions`) to store message reactions. 
  - Columns: `id` (UUID), `message_id` (UUID), `user_id` (UUID), `reaction_type` (VARCHAR), `created_at` (TIMESTAMP), `updated_at` (TIMESTAMP).
  - Primary Key: `id`
  - Unique Constraint: [(message_id, user_id)](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/domain/model/Reaction.kt#32-35)
  - Foreign Keys: `message_id` references `messages(id)`, `user_id` references `users(uid)`.

---

### Data Layer
- **Update [ReactionRepository.kt](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt)**:
  - Add `"message"` to [getTableName()](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt#485-492) to return `"message_reactions"`.
  - Add `"message"` to [getIdColumn()](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt#493-500) to return `"message_id"`.
  - Add helper methods: `toggleMessageReaction`, `getMessageReactionSummary`, `getUserMessageReaction`.
  - Add RPC function mapping or manual querying for message reactions in batches inside [getReactionSummary](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt#139-194) if needed (or just rely on the fallback query for now).

---

### Domain Models
- **Update [Message.kt](file:///c:/Users/Ashik/Documents/synapseApp/shared/src/commonMain/kotlin/com/synapse/social/studioasinc/shared/domain/model/chat/Message.kt) (Shared domain)**: 
  - Add `val reactions: Map<ReactionType, Int> = emptyMap()`
  - Add `val userReaction: ReactionType? = null`
  - Ensure [ReactionType](file:///c:/Users/Ashik/Documents/synapseApp/shared/src/commonMain/kotlin/com/synapse/social/studioasinc/shared/domain/model/ReactionType.kt#5-23) is imported correctly.
- **Update [MessageDto.kt](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/model/MessageDto.kt) and [ChatDtos.kt](file:///c:/Users/Ashik/Documents/synapseApp/shared/src/commonMain/kotlin/com/synapse/social/studioasinc/shared/data/dto/chat/ChatDtos.kt)**:
  - Add `reactions: String? = null` (or similar depending on how data is fetched, though if we fetch reactions separately like posts/comments do, we might not need to modify the DTO, but rather populate them using the repository).
  - *Actually, [ReactionRepository](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt#26-554) populates reactions for posts/comments AFTER fetching them. We can do the same for messages in [ChatViewModel](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/feature/inbox/inbox/ChatViewModel.kt#27-577) or [SupabaseChatRepository](file:///c:/Users/Ashik/Documents/synapseApp/shared/src/commonMain/kotlin/com/synapse/social/studioasinc/shared/data/repository/SupabaseChatRepository.kt#24-440).*

---

### Presentation Layer ([ChatViewModel](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/feature/inbox/inbox/ChatViewModel.kt#27-577) & UI)
- **[ChatViewModel.kt](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/feature/inbox/inbox/ChatViewModel.kt)**:
  - Inject [ReactionRepository](file:///c:/Users/Ashik/Documents/synapseApp/app/src/main/java/com/synapse/social/studioasinc/data/repository/ReactionRepository.kt#26-554).
  - Fetch message reaction summaries and user reactions when messages are loaded/updated from realtime.
  - Expose a `toggleMessageReaction(messageId: String, reactionType: ReactionType)` method.
  - When `toggleMessageReaction` is called:
    - Optimistically update the [Message](file:///c:/Users/Ashik/Documents/synapseApp/shared/src/commonMain/kotlin/com/synapse/social/studioasinc/shared/domain/model/chat/Message.kt#3-24) in `_messages` with the new reaction.
    - Call `reactionRepository.toggleMessageReaction(...)`.
    - If it fails, revert the optimistic update.
- **`ChatScreen` / `MessageBubble`**:
  - Update UI to show `ReactionPicker` on long press or via a specific icon.
  - Display reaction summaries at the bottom of the `MessageBubble`.

## Verification Plan
1. Apply database migration in Supabase dashboard.
2. Build and run app. Focus on a chat.
3. Long press on a message (or tap reaction button), pick a reaction.
4. Verify optimistic update puts the reaction on the message.
5. Verify backend stores the reaction in `message_reactions`.
6. Reload the chat screen and verify the reaction is loaded correctly.
