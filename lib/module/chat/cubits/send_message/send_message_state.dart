enum MessageStatus { none, loading, success, failure }

class MessageState {
  final MessageStatus messageStatus;
  final String message;

  MessageState({required this.messageStatus, required this.message});

  factory MessageState.initial() {
    return MessageState(messageStatus: MessageStatus.none, message: '');
  }
  MessageState copyWith({MessageStatus? messageStatus, String? message}) {
    return MessageState(
      messageStatus: messageStatus ?? this.messageStatus,
      message: message ?? this.message,
    );
  }
}
