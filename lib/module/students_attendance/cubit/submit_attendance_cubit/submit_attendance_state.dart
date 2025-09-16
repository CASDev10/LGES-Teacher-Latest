part of 'submit_attendance_cubit.dart';

enum SubmitAttendanceStatus {
  none,
  loading,
  success,
  failure,
}

class SubmitAttendanceState {
  final SubmitAttendanceStatus submitAttendanceStatus;
  final BaseFailure failure;

  SubmitAttendanceState({
    required this.submitAttendanceStatus,
    required this.failure,
  });

  factory SubmitAttendanceState.initial() {
    return SubmitAttendanceState(
      submitAttendanceStatus: SubmitAttendanceStatus.none,
      failure: const BaseFailure(),
    );
  }

  SubmitAttendanceState copyWith({
    SubmitAttendanceStatus? submitAttendanceStatus,
    BaseFailure? failure,
  }) {
    return SubmitAttendanceState(
      submitAttendanceStatus: submitAttendanceStatus ?? this.submitAttendanceStatus,
      failure: failure ?? this.failure,
    );
  }
}
