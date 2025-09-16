


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/exam_class_cubit/exam_classes_state.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_response.dart';
import 'package:lges_teacher_app/module/exam_result/repo/exam_result_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';

class ExamClassesCubit extends Cubit<ExamClassesState> {
  ExamClassesCubit(this._repository) : super(ExamClassesState.initial());

  ExamResultRepository _repository;

  Future fetchClasses(String schoolId) async {
    emit(state.copyWith(examClassesStatus: ExamClassesStatus.loading));

    try {
      ExamClassResponse examClassResponse =
      await _repository.getClasses(schoolId);

      if (examClassResponse.result == ApiResult.success) {
        emit(state.copyWith(
          examClassesStatus: ExamClassesStatus.success,
          classes: examClassResponse.data,
        ));
      } else {
        emit(state.copyWith(
            examClassesStatus: ExamClassesStatus.failure,
            failure: HighPriorityException(examClassResponse.message)));
      }
    } on BaseFailure catch (e) {

      emit(state.copyWith(
          examClassesStatus: ExamClassesStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
