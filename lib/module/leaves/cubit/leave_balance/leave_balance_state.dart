import '../../../../../../core/failures/base_failures/base_failure.dart';
import '../../model/leave_balance_response.dart';

enum LeaveBalanceStatus { none, loading, loadMore, success, failure }

class LeaveBalanceState {
  final LeaveBalanceStatus leaveBalanceStatus;
  final BaseFailure failure;
  final List<LeaveModel> leaveBalance;

  LeaveBalanceState({
    required this.leaveBalanceStatus,
    required this.failure,
    required this.leaveBalance,
  });

  factory LeaveBalanceState.initial() {
    return LeaveBalanceState(
      leaveBalanceStatus: LeaveBalanceStatus.none,
      failure: const BaseFailure(),
      leaveBalance: [],
    );
  }

  LeaveBalanceState copyWith({
    LeaveBalanceStatus? leaveBalanceStatus,
    BaseFailure? failure,
    List<LeaveModel>? leaveBalance,
  }) {
    return LeaveBalanceState(
      leaveBalanceStatus: leaveBalanceStatus ?? this.leaveBalanceStatus,
      failure: failure ?? this.failure,
      leaveBalance: leaveBalance ?? this.leaveBalance,
    );
  }
}
