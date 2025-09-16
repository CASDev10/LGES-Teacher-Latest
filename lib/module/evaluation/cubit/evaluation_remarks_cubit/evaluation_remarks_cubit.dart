import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/evaluation/models/evaluation_remarks_response.dart';
import 'package:lges_teacher_app/module/evaluation/repo/evaluation_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';

part 'evaluation_remarks_state.dart';

class EvaluationRemarksCubit extends Cubit<EvaluationRemarksState> {
  EvaluationRemarksCubit(this.evaluationRepository) : super(EvaluationRemarksState.initial());

  EvaluationRepository evaluationRepository;
  Future fetchEvaluationRemarks() async {
    emit(state.copyWith(evaluationRemarksStatus: EvaluationRemarksStatus.loading));

    try {
      EvaluationRemarksResponse responseModel =
      await evaluationRepository.getEvaluationRemarks();

      if (responseModel.result == ApiResult.success) {
        emit(state.copyWith(
          evaluationRemarksStatus: EvaluationRemarksStatus.success,
          evaluationRemarks: responseModel.data,
        ));
      } else {
        emit(state.copyWith(
            evaluationRemarksStatus: EvaluationRemarksStatus.failure,
            failure: HighPriorityException(responseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          evaluationRemarksStatus: EvaluationRemarksStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }

}
