// import 'package:bkmc/core/exceptions/api_error.dart';
// import 'package:bkmc/core/network/api_result.dart';
// import 'package:bkmc/module/leave_request/cubit/leave_data_cubit/leave_data_state.dart';
// import 'package:bkmc/module/leave_request/model/leave_data_response.dart';
// import 'package:bkmc/module/leave_request/repository/leave_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class LeaveDataCubit extends Cubit<LeaveDataState> {
//   final LeaveRepository _repository;
//
//   LeaveDataCubit({required LeaveRepository leaveRepo})
//       : _repository = leaveRepo,
//         super(LeaveDataState.initial());
//
//   Future fetchLeaveData(int employeeId) async {
//     emit(state.copyWith(status: LeaveDataStatus.loading));
//     try {
//       LeaveDataResponse response = await _repository.getLeaveData(employeeId);
//       if (response.result == ApiResult.success) {
//         emit(state.copyWith(
//             status: LeaveDataStatus.success,
//             empLeaveDataList: response.empLeaveDataList,
//             message: response.message));
//       } else {
//         emit(state.copyWith(
//             status: LeaveDataStatus.error, message: response.message));
//       }
//     } on ApiError catch (e) {
//       emit(state.copyWith(
//           status: LeaveDataStatus.error, message: "${e.message}"));
//     }
//   }
//
//   Future fetchLeaveTypes() async {
//     emit(state.copyWith(status: LeaveDataStatus.loading));
//     try {
//       LeaveDataResponse response = await _repository.getLeaveTypes();
//       if (response.result == ApiResult.success) {
//         emit(state.copyWith(
//             status: LeaveDataStatus.success,
//             leaveTypesList: response.leaveTypeList,
//             message: response.message));
//       } else {
//         emit(state.copyWith(
//             status: LeaveDataStatus.error, message: response.message));
//       }
//     } on ApiError catch (e) {
//       emit(state.copyWith(
//           status: LeaveDataStatus.error, message: "${e.message}"));
//     }
//   }
//
//   Future fetchRelieverList(dynamic data) async {
//     emit(state.copyWith(status: LeaveDataStatus.loading));
//     try {
//       LeaveDataResponse response = await _repository.getRelieverList(data);
//       if (response.result == ApiResult.success) {
//         emit(state.copyWith(
//             status: LeaveDataStatus.success,
//             relieverListElement: response.relieverList,
//             message: response.message));
//       } else {
//         emit(state.copyWith(
//             status: LeaveDataStatus.error, message: response.message));
//       }
//     } on ApiError catch (e) {
//       emit(state.copyWith(
//           status: LeaveDataStatus.error, message: "${e.message}"));
//     }
//   }
// }
