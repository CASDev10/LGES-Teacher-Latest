import 'package:bloc/bloc.dart';

import '../../../../../core/failures/base_failures/base_failure.dart';
import '../../../../../core/failures/high_priority_failure.dart';
import '../../../../../utils/display/display_utils.dart';
import '../../../base_resposne_model.dart';
import '../../model/add_update_leave_input.dart';
import '../../model/employee_leaves_response.dart';
import '../../repo/leaves_repo.dart';
import 'apply_leave_state.dart';

class ApplyLeaveCubit extends Cubit<ApplyLeaveState> {
  ApplyLeaveCubit(this._repository) : super(ApplyLeaveState.initial());
  LeavesRepository _repository;
  List<EmployeeLeaveModel> employeeLeaves = [];

  Future addUpdateEmployeeLeave({required AddUpdateLeaveInput input}) async {
    DisplayUtils.showLoader();
    emit(state.copyWith(studentAttendanceStatus: ApplyLeaveStatus.loading));
    try {
      BaseResponseModel? response = await _repository.addUpdateEmployeeLeave(
        input,
      );

      emit(state.copyWith(studentAttendanceStatus: ApplyLeaveStatus.success));
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          studentAttendanceStatus: ApplyLeaveStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }
}
