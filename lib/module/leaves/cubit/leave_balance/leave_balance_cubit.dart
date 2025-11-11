import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/core/api_result.dart';

import '../../../../../core/failures/base_failures/base_failure.dart';
import '../../../../../core/failures/high_priority_failure.dart';
import '../../model/leave_balance_response.dart';
import '../../repo/leaves_repo.dart';
import 'leave_balance_state.dart';

class LeaveBalanceCubit extends Cubit<LeaveBalanceState> {
  LeaveBalanceCubit(this._repository) : super(LeaveBalanceState.initial());
  LeavesRepository _repository;

  Future fetchLeaveBalance() async {
    emit(state.copyWith(leaveBalanceStatus: LeaveBalanceStatus.loading));
    try {
      LeaveBalanceResponse response = await _repository
          .getEmployeeLeaveBalance();
      if (response.result == ApiResult.success) {
        final uniqueList = response.data
            .fold<Map<int, LeaveModel>>({}, (map, item) {
              map[item.leaveTypeId] = item; // keeps last occurrence per id
              return map;
            })
            .values
            .toList();
        emit(
          state.copyWith(
            leaveBalanceStatus: LeaveBalanceStatus.success,
            leaveBalance: uniqueList, // make a fresh copy
            failure: const HighPriorityException(""), // reset failure
          ),
        );
      } else {
        emit(
          state.copyWith(
            leaveBalanceStatus: LeaveBalanceStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          leaveBalanceStatus: LeaveBalanceStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          leaveBalanceStatus: LeaveBalanceStatus.failure,
          failure: HighPriorityException(e.toString()),
        ),
      );
    }
  }
}
