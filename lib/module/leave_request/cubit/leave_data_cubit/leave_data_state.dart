// import 'package:bkmc/module/leave_request/model/leave_data_response.dart';
// import 'package:bkmc/module/leave_request/model/leave_types_list.dart';
// import 'package:bkmc/module/leave_request/model/reliever_list.dart';
//
// enum LeaveDataStatus {
//   initial,
//   loading,
//   success,
//   error,
// }
//
// class LeaveDataState {
//   final LeaveDataStatus status;
//   final String message;
//   final List<EmpLeaveDataList> empLeaveDataList;
//   final List<LeaveTypeList> leaveTypesList;
//   final List<RelieverListElement> relieverListElement;
//
//   LeaveDataState({
//     required this.status,
//     required this.message,
//     required this.leaveTypesList,
//     required this.empLeaveDataList,
//     required this.relieverListElement,
//   });
//
//   factory LeaveDataState.initial() {
//     return LeaveDataState(
//       status: LeaveDataStatus.initial,
//       message: '',
//       leaveTypesList: [],
//       empLeaveDataList: [],
//       relieverListElement: [],
//     );
//   }
//
//   LeaveDataState copyWith({
//     LeaveDataStatus? status,
//     String? message,
//     List<LeaveTypeList>? leaveTypesList,
//     List<EmpLeaveDataList>? empLeaveDataList,
//     List<RelieverListElement>? relieverListElement,
//   }) {
//     return LeaveDataState(
//       status: status ?? this.status,
//       message: message ?? this.message,
//       leaveTypesList: leaveTypesList ?? this.leaveTypesList,
//       empLeaveDataList: empLeaveDataList ?? this.empLeaveDataList,
//       relieverListElement: relieverListElement ?? this.relieverListElement,
//     );
//   }
// }
