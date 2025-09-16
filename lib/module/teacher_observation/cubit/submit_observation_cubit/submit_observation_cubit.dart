import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/teacher_observation/repo/observation_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../base_resposne_model.dart';
import '../../models/submit_observation_input.dart';

part 'submit_observation_state.dart';

class SubmitObservationCubit extends Cubit<SubmitObservationState> {
  SubmitObservationCubit(this.repository)
      : super(SubmitObservationState.initial());

  ObservationRepository repository;

  Future submitTeacherObservation(SubmitObservationInput input) async {
    emit(state.copyWith(
        submitObservationStatus: SubmitObservationStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
          await repository.submitTeacherObservation(input);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            submitObservationStatus: SubmitObservationStatus.success));
      } else {
        emit(state.copyWith(
            submitObservationStatus: SubmitObservationStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          submitObservationStatus: SubmitObservationStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
