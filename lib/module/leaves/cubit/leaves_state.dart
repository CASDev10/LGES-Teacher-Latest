import '../../../../../../core/failures/base_failures/base_failure.dart';
import '../model/employee_leaves_response.dart';
import '../model/leave_balance_response.dart';

enum TeacherLeaveStatus { none, loading, loadMore, success, failure }

class TeacherLeaveState {
  final TeacherLeaveStatus studentAttendanceStatus;
  final BaseFailure failure;
  final List<LeaveModel> leaveBalance;
  final List<EmployeeLeaveModel> employeeLeaves;

  TeacherLeaveState({
    required this.studentAttendanceStatus,
    required this.failure,
    required this.leaveBalance,
    required this.employeeLeaves,
  });

  factory TeacherLeaveState.initial() {
    return TeacherLeaveState(
      studentAttendanceStatus: TeacherLeaveStatus.none,
      failure: const BaseFailure(),
      leaveBalance: [],
      employeeLeaves: [],
    );
  }

  TeacherLeaveState copyWith({
    TeacherLeaveStatus? studentAttendanceStatus,
    BaseFailure? failure,
    List<LeaveModel>? leaveBalance,
    List<EmployeeLeaveModel>? employeeLeaves,
  }) {
    return TeacherLeaveState(
      studentAttendanceStatus:
          studentAttendanceStatus ?? this.studentAttendanceStatus,
      failure: failure ?? this.failure,
      leaveBalance: leaveBalance ?? this.leaveBalance,
      employeeLeaves: employeeLeaves ?? this.employeeLeaves,
    );
  }
}
