import '../../../../../../core/failures/base_failures/base_failure.dart';
import '../../model/employee_leaves_response.dart';
import '../../model/leave_balance_response.dart';

enum ApplyLeaveStatus { none, loading, loadMore, success, failure }

class ApplyLeaveState {
  final ApplyLeaveStatus studentAttendanceStatus;
  final BaseFailure failure;
  final List<LeaveModel> leaveBalance;
  final List<EmployeeLeaveModel> employeeLeaves;

  ApplyLeaveState({
    required this.studentAttendanceStatus,
    required this.failure,
    required this.leaveBalance,
    required this.employeeLeaves,
  });

  factory ApplyLeaveState.initial() {
    return ApplyLeaveState(
      studentAttendanceStatus: ApplyLeaveStatus.none,
      failure: const BaseFailure(),
      leaveBalance: [],
      employeeLeaves: [],
    );
  }

  ApplyLeaveState copyWith({
    ApplyLeaveStatus? studentAttendanceStatus,
    BaseFailure? failure,
    List<LeaveModel>? leaveBalance,
    List<EmployeeLeaveModel>? employeeLeaves,
  }) {
    return ApplyLeaveState(
      studentAttendanceStatus:
          studentAttendanceStatus ?? this.studentAttendanceStatus,
      failure: failure ?? this.failure,
      leaveBalance: leaveBalance ?? this.leaveBalance,
      employeeLeaves: employeeLeaves ?? this.employeeLeaves,
    );
  }
}
