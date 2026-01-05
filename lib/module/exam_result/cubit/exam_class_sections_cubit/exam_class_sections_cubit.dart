import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_sections_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../../utils/display/display_utils.dart';
import '../../models/evaluation_response.dart';
import '../../models/evaluation_type_response.dart';
import '../../models/group_evaluation_response.dart';
import '../../repo/exam_result_repo.dart';
import 'exam_class_sections_state.dart';

class ExamClassSectionsCubit extends Cubit<ExamClassSectionsState> {
  ExamClassSectionsCubit(this._repository)
    : super(ExamClassSectionsState.initial());

  ExamResultRepository _repository;

  Future fetchClassSections(String schoolId) async {
    emit(
      state.copyWith(examClassSectionsStatus: ExamClassSectionsStatus.loading),
    );

    try {
      ExamClassSectionsResponse examClassResponse = await _repository
          .getSections(schoolId);

      if (examClassResponse.result == ApiResult.success) {
        emit(
          state.copyWith(
            examClassSectionsStatus: ExamClassSectionsStatus.success,
            classSections: examClassResponse.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            examClassSectionsStatus: ExamClassSectionsStatus.failure,
            failure: HighPriorityException(examClassResponse.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }

  Future fetchGroupEvaluation({required int evaluationTypeId}) async {
    DisplayUtils.showLoader();
    emit(
      state.copyWith(examClassSectionsStatus: ExamClassSectionsStatus.loading),
    );
    try {
      GroupEvaluationResponse evaluationTypeResponse = await _repository
          .getEvaluationGroups(evaluationTypeId: evaluationTypeId);

      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.success,
          evaluationsGroups: evaluationTypeResponse.data,
        ),
      );
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }

  Future fetchEvaluationType() async {
    DisplayUtils.showLoader();
    emit(
      state.copyWith(examClassSectionsStatus: ExamClassSectionsStatus.loading),
    );
    try {
      EvaluationTypeResponse evaluationTypeResponse = await _repository
          .getEvaluationType();

      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.success,
          evaluationTypes: evaluationTypeResponse.data,
        ),
      );
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }

  Future fetchEvaluation({required int evaluationTypeId}) async {
    DisplayUtils.showLoader();
    emit(
      state.copyWith(examClassSectionsStatus: ExamClassSectionsStatus.loading),
    );
    try {
      EvaluationResponse evaluationTypeResponse = await _repository
          .getEvaluation(evaluationTypeId: evaluationTypeId);

      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.success,
          evaluations: evaluationTypeResponse.data,
        ),
      );
      DisplayUtils.removeLoader();
    } on BaseFailure catch (e) {
      DisplayUtils.removeLoader();
      emit(
        state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {
      DisplayUtils.removeLoader();
    }
  }
}
