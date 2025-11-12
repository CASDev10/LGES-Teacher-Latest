import '../../models/get_students_response.dart';

enum GetStudentsStatus { none, loading, success, failure }

class GetStudentsState {
  final GetStudentsStatus status;
  final String message;
  final List<NotificationStudentModel> students;

  GetStudentsState({
    required this.status,
    required this.message,
    required this.students,
  });

  factory GetStudentsState.initial() {
    return GetStudentsState(
      status: GetStudentsStatus.none,
      message: '',
      students: [],
    );
  }

  GetStudentsState copyWith({
    GetStudentsStatus? status,
    String? message,
    List<NotificationStudentModel>? students,
  }) {
    return GetStudentsState(
      status: status ?? this.status,
      message: message ?? this.message,
      students: students ?? this.students,
    );
  }
}
