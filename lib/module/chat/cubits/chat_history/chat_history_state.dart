import 'package:lges_teacher_app/module/chat/models/chat_history_response.dart';

enum ChatHistoryStatus { none, loading, success, failure }

class ChatHistoryState {
  final ChatHistoryStatus chatHistoryStatus;
  final String message;
  final List<MessageModel> messages;

  ChatHistoryState({
    required this.chatHistoryStatus,
    required this.message,
    required this.messages,
  });

  factory ChatHistoryState.initial() {
    return ChatHistoryState(
      chatHistoryStatus: ChatHistoryStatus.none,
      message: '',
      messages: [],
    );
  }
  ChatHistoryState copyWith({
    ChatHistoryStatus? chatHistoryStatus,
    String? message,
    List<MessageModel>? messages,
  }) {
    return ChatHistoryState(
      chatHistoryStatus: chatHistoryStatus ?? this.chatHistoryStatus,
      message: message ?? this.message,
      messages: messages ?? this.messages,
    );
  }
}
