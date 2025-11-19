enum MessageStatus { none, loading, success, failure }

class MessageState {
  final MessageStatus messageStatus;
  final String message;
  final int conversationId;

  MessageState({
    required this.messageStatus,
    required this.message,
    required this.conversationId,
  });

  factory MessageState.initial() {
    return MessageState(
      messageStatus: MessageStatus.none,
      message: '',
      conversationId: -1,
    );
  }
  MessageState copyWith({
    MessageStatus? messageStatus,
    String? message,
    int? conversationId,
  }) {
    return MessageState(
      messageStatus: messageStatus ?? this.messageStatus,
      message: message ?? this.message,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
