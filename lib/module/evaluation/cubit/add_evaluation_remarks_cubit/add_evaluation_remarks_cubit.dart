import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/evaluation/models/add_evaluation_remarks_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/add_evaluation_remarks_input.dart';
import '../../repo/evaluation_repo.dart';
import 'add_evaluation_remarks_state.dart';

class AddEvaluationRemarksCubit extends Cubit<AddEvaluationRemarksState> {
  AddEvaluationRemarksCubit(this.evaluationRepository)
    : super(AddEvaluationRemarksState.initial());

  EvaluationRepository evaluationRepository;

  Future addEvaluationRemarks(
    AddEvaluationRemarksInput addEvaluationRemarksInput,
  ) async {
    emit(
      state.copyWith(
        addEvaluationRemarksStatus: AddEvaluationRemarksStatus.loading,
      ),
    );

    try {
      BaseResponseModel responseModel = await evaluationRepository
          .addEvaluationRemarks(addEvaluationRemarksInput);

      if (responseModel.result == ApiResult.success) {
        emit(
          state.copyWith(
            addEvaluationRemarksStatus: AddEvaluationRemarksStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            addEvaluationRemarksStatus: AddEvaluationRemarksStatus.failure,
            failure: HighPriorityException(responseModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          addEvaluationRemarksStatus: AddEvaluationRemarksStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
