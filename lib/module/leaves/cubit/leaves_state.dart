import '../../../../../../core/failures/base_failures/base_failure.dart';
import '../model/employee_leaves_response.dart';
import '../model/leave_balance_response.dart';

enum TeacherLeaveStatus { none, loading, loadMore, success, failure }

class TeacherLeaveState {
  final TeacherLeaveStatus leaveStatus;
  final BaseFailure failure;
  final List<LeaveModel> leaveBalance;
  final List<EmployeeLeaveModel> employeeLeaves;

  TeacherLeaveState({
    required this.leaveStatus,
    required this.failure,
    required this.leaveBalance,
    required this.employeeLeaves,
  });

  factory TeacherLeaveState.initial() {
    return TeacherLeaveState(
      leaveStatus: TeacherLeaveStatus.none,
      failure: const BaseFailure(),
      leaveBalance: [],
      employeeLeaves: [],
    );
  }

  TeacherLeaveState copyWith({
    TeacherLeaveStatus? leaveStatus,
    BaseFailure? failure,
    List<LeaveModel>? leaveBalance,
    List<EmployeeLeaveModel>? employeeLeaves,
  }) {
    return TeacherLeaveState(
      leaveStatus: leaveStatus ?? this.leaveStatus,
      failure: failure ?? this.failure,
      leaveBalance: leaveBalance ?? this.leaveBalance,
      employeeLeaves: employeeLeaves ?? this.employeeLeaves,
    );
  }
}
