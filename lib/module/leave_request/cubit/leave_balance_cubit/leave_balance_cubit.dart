// import 'package:bkmc/core/exceptions/api_error.dart';
// import 'package:bkmc/core/network/api_result.dart';
// import 'package:bkmc/module/leave_request/cubit/leave_balance_cubit/leave_balance_state.dart';
// import 'package:bkmc/module/leave_request/model/leave_balance_response.dart';
// import 'package:bkmc/module/leave_request/repository/leave_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/api_result.dart';
// import '../../../../core/exceptions/api_error.dart';
// import '../../../leaves/model/leave_balance_response.dart';
// import '../../repository/leave_repository.dart';
// import 'leave_balance_state.dart';
//
// class LeaveBalanceCubit extends Cubit<LeaveBalanceState> {
//   final LeaveRepository _repository;
//
//   LeaveBalanceCubit({required LeaveRepository leaveRepo})
//       : _repository = leaveRepo,
//         super(LeaveBalanceState.initial());
//
//   Future fetchLeaveBalance(int employeeId) async {
//     emit(state.copyWith(status: LeaveBalanceStatus.loading));
//     try {
//       LeaveBalanceResponse response =
//           await _repository.getLeaveBalance(employeeId);
//       if (response.result == ApiResult.success) {
//         emit(state.copyWith(
//             status: LeaveBalanceStatus.success,
//             leaveBalanceList: response.data,
//             message: response.message));
//       } else {
//         emit(state.copyWith(
//             status: LeaveBalanceStatus.error, message: response.message));
//       }
//     } on ApiError catch (e) {
//       emit(state.copyWith(
//           status: LeaveBalanceStatus.error, message: "${e.message}"));
//     }
//   }
// }
