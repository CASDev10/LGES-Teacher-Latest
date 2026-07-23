import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/students_attendance/models/submit_attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/submit_attendance_reponse.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/attendance_repo.dart';

part 'submit_attendance_state.dart';

class SubmitAttendanceCubit extends Cubit<SubmitAttendanceState> {
  SubmitAttendanceCubit(this._repository)
    : super(SubmitAttendanceState.initial());

  AttendanceRepository _repository;

  Future submitAttendance(SubmitAttendanceInput input) async {
    emit(
      state.copyWith(submitAttendanceStatus: SubmitAttendanceStatus.loading),
    );

    try {
      BaseResponseModel response = await _repository.submitAttendance(input);
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            submitAttendanceStatus: SubmitAttendanceStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            submitAttendanceStatus: SubmitAttendanceStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          submitAttendanceStatus: SubmitAttendanceStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
