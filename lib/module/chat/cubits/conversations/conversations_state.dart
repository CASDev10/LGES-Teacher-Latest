import 'package:lges_teacher_app/module/chat/models/conversations_response.dart';

enum ConversationsStatus { none, loading, success, failure }

class ConversationsState {
  final ConversationsStatus conversationsStatus;
  final String message;
  final List<ConversationModel> conversations;

  ConversationsState({
    required this.conversationsStatus,
    required this.message,
    required this.conversations,
  });

  factory ConversationsState.initial() {
    return ConversationsState(
      conversationsStatus: ConversationsStatus.none,
      message: '',
      conversations: [],
    );
  }
  ConversationsState copyWith({
    ConversationsStatus? conversationsStatus,
    String? message,
    List<ConversationModel>? conversations,
  }) {
    return ConversationsState(
      conversationsStatus: conversationsStatus ?? this.conversationsStatus,
      message: message ?? this.message,
      conversations: conversations ?? this.conversations,
    );
  }
}
