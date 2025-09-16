

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_sections_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/exam_result_repo.dart';
import 'exam_class_sections_state.dart';

class ExamClassSectionsCubit extends Cubit<ExamClassSectionsState> {
  ExamClassSectionsCubit(this._repository) : super(ExamClassSectionsState.initial());

  ExamResultRepository _repository;

  Future fetchClassSections(String schoolId) async {
    emit(state.copyWith(examClassSectionsStatus: ExamClassSectionsStatus.loading));

    try {
      ExamClassSectionsResponse examClassResponse =
      await _repository.getSections(schoolId);

      if (examClassResponse.result == ApiResult.success) {
        emit(state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.success,
          classSections: examClassResponse.data,
        ));
      } else {
        emit(state.copyWith(
            examClassSectionsStatus: ExamClassSectionsStatus.failure,
            failure: HighPriorityException(examClassResponse.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          examClassSectionsStatus: ExamClassSectionsStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}