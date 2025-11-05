// import 'package:bkmc/module/leave_request/model/leave_balance_response.dart';
//
// enum LeaveBalanceStatus {
//   initial,
//   loading,
//   success,
//   error,
// }
//
// class LeaveBalanceState {
//   final LeaveBalanceStatus status;
//   final String message;
//   final List<LeaveBalanceList> leaveBalanceList;
//
//   LeaveBalanceState({
//     required this.status,
//     required this.message,
//     required this.leaveBalanceList,
//   });
//
//   factory LeaveBalanceState.initial() {
//     return LeaveBalanceState(
//       status: LeaveBalanceStatus.initial,
//       message: '',
//       leaveBalanceList: [],
//     );
//   }
//
//   LeaveBalanceState copyWith({
//     LeaveBalanceStatus? status,
//     String? message,
//     List<LeaveBalanceList>? leaveBalanceList,
//   }) {
//     return LeaveBalanceState(
//       status: status ?? this.status,
//       message: message ?? this.message,
//       leaveBalanceList: leaveBalanceList ?? this.leaveBalanceList,
//     );
//   }
// }
