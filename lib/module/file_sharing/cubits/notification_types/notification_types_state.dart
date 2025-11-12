import 'package:lges_teacher_app/module/file_sharing/models/notification_types_response.dart';

enum NotificationTypeStatus { none, loading, success, failure }

class NotificationTypeState {
  final NotificationTypeStatus status;
  final String message;
  final List<NotificationTypeModel> types;

  NotificationTypeState({
    required this.status,
    required this.message,
    required this.types,
  });

  factory NotificationTypeState.initial() {
    return NotificationTypeState(
      status: NotificationTypeStatus.none,
      message: '',
      types: [],
    );
  }

  NotificationTypeState copyWith({
    NotificationTypeStatus? status,
    String? message,
    List<NotificationTypeModel>? types,
  }) {
    return NotificationTypeState(
      status: status ?? this.status,
      message: message ?? this.message,
      types: types ?? this.types,
    );
  }
}
