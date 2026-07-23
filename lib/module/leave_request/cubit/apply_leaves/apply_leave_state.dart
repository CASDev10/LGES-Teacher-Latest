import '../../model/apply_leave_model.dart';

enum ApplyLeaveStatus { initial, fileSelected, loading, success, error }

class ApplyLeaveState {
  final ApplyLeaveStatus status;
  final String message;
  final ApplyLeaveResponse applyLeaveResponse;

  ApplyLeaveState({
    required this.status,
    required this.message,
    required this.applyLeaveResponse,
  });

  factory ApplyLeaveState.initial() {
    return ApplyLeaveState(
      status: ApplyLeaveStatus.initial,
      message: '',
      applyLeaveResponse: ApplyLeaveResponse(),
    );
  }

  ApplyLeaveState copyWith({
    ApplyLeaveStatus? status,
    String? message,
    ApplyLeaveResponse? applyLeaveResponse,
  }) {
    return ApplyLeaveState(
      status: status ?? this.status,
      message: message ?? this.message,
      applyLeaveResponse: applyLeaveResponse ?? this.applyLeaveResponse,
    );
  }
}
