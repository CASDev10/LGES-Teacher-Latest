import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/evaluation/models/evaluation_areas_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/student_evaluation_areas_input.dart';
import '../../models/student_evaluation_areas_response.dart';
import '../../repo/evaluation_repo.dart';
import 'evaluation_areas_state.dart';

class EvaluationAreasCubit extends Cubit<EvaluationAreasState> {
  EvaluationAreasCubit(this.evaluationRepository)
    : super(EvaluationAreasState.initial());

  EvaluationRepository evaluationRepository;
  Future fetchEvaluationAreas(
    StudentEvaluationAreasInput studentEvaluationAreasInput,
  ) async {
    emit(state.copyWith(evaluationAreasStatus: EvaluationAreasStatus.loading));

    try {
      StudentEvaluationAreasResponse responseModel = await evaluationRepository
          .getEvaluationAreas(studentEvaluationAreasInput);

      if (responseModel.result == ApiResult.success) {
        emit(
          state.copyWith(
            evaluationAreasStatus: EvaluationAreasStatus.success,
            evaluationAreas: responseModel.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            evaluationAreasStatus: EvaluationAreasStatus.failure,
            failure: HighPriorityException(responseModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          evaluationAreasStatus: EvaluationAreasStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
