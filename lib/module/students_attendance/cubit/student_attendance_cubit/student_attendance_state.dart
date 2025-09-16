
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/attendance_reponse.dart';

enum StudentAttendanceStatus {
  none,
  loading,
  success,
  failure,
}

class StudentAttendanceState {
  final StudentAttendanceStatus studentAttendanceStatus;
  final BaseFailure failure;
  final List<AttendanceModel> attendanceList;

  StudentAttendanceState({
    required this.studentAttendanceStatus,
    required this.failure,
    required this.attendanceList,
  });

  factory StudentAttendanceState.initial() {
    return StudentAttendanceState(
      studentAttendanceStatus: StudentAttendanceStatus.none,
      failure: const BaseFailure(),
      attendanceList: [],
    );
  }

  StudentAttendanceState copyWith({
    StudentAttendanceStatus? studentAttendanceStatus,
    BaseFailure? failure,
    List<AttendanceModel>? attendanceList,
  }) {
    return StudentAttendanceState(
      studentAttendanceStatus: studentAttendanceStatus ?? this.studentAttendanceStatus,
      failure: failure ?? this.failure,
      attendanceList: attendanceList ?? this.attendanceList,
    );
  }
}
