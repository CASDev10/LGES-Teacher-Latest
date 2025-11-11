import 'package:bloc/bloc.dart';

import '../../../../../core/failures/base_failures/base_failure.dart';
import '../../../../../core/failures/high_priority_failure.dart';
import '../../../../../utils/display/display_utils.dart';
import '../../base_resposne_model.dart';
import '../model/employee_leaves_response.dart';
import '../model/leave_balance_response.dart';
import '../repo/leaves_repo.dart';
import 'leaves_state.dart';

class TeacherLeaveCubit extends Cubit<TeacherLeaveState> {
  TeacherLeaveCubit(this._repository) : super(TeacherLeaveState.initial());
  LeavesRepository _repository;
  List<EmployeeLeaveModel> employeeLeaves = [];

  Future fetchEmployeeLeaves({
    required int offSet,
    required int next,
    bool loadMore = false,
  }) async {
    DisplayUtils.showLoader();
    emit(
      state.copyWith(
        leaveStatus: loadMore
            ? TeacherLeaveStatus.loadMore
            : TeacherLeaveStatus.loadMore,
      ),
    );

    if (loadMore) {
      DisplayUtils.showLoader();
    } else {
      employeeLeaves.clear();
    }
    try {
      EmployeeLeavesResponse response = await _repository.getGetEmployeeLeaves(
        offSet: offSet,
        next: next,
      );
      employeeLeaves.addAll(response.data);
      emit(
        state.copyWith(
          leaveStatus: TeacherLeaveStatus.success,
          employeeLeaves: employeeLeaves,
        ),
      );
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          leaveStatus: TeacherLeaveStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }

  Future fetchLeaveBalance() async {
    DisplayUtils.showLoader();
    emit(state.copyWith(leaveStatus: TeacherLeaveStatus.loading));
    try {
      LeaveBalanceResponse response = await _repository
          .getEmployeeLeaveBalance();
      emit(
        state.copyWith(
          leaveStatus: TeacherLeaveStatus.success,
          leaveBalance: response.data,
        ),
      );
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          leaveStatus: TeacherLeaveStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }

  // Future addUpdateEmployeeLeave({required AddUpdateLeaveInput input}) async {
  //   DisplayUtils.showLoader();
  //   emit(state.copyWith(studentAttendanceStatus: TeacherLeaveStatus.loading));
  //   try {
  //     BaseResponseModel? response =
  //         await _repository.addUpdateEmployeeLeave(input);

  //     emit(
  //       state.copyWith(
  //         studentAttendanceStatus: TeacherLeaveStatus.success,
  //       ),
  //     );
  //     DisplayUtils.removeLoader();
  //   } on BaseFailure catch (e) {
  //     DisplayUtils.removeLoader();
  //     emit(state.copyWith(
  //         studentAttendanceStatus: TeacherLeaveStatus.failure,
  //         failure: HighPriorityException(e.message)));
  //   } catch (_) {
  //     DisplayUtils.removeLoader();
  //   }
  // }

  Future deleteLeave({required int id}) async {
    DisplayUtils.showLoader();
    emit(state.copyWith(leaveStatus: TeacherLeaveStatus.loading));
    try {
      BaseResponseModel response = await _repository.deleteLeave(id: id);
      emit(state.copyWith(leaveStatus: TeacherLeaveStatus.success));
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          leaveStatus: TeacherLeaveStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }
}
