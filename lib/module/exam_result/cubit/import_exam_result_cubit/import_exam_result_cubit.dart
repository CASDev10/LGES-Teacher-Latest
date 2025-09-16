


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/exam_result/models/import_exam_result_data_input.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/exam_result_repo.dart';
import 'import_exam_result_state.dart';

class ImportExamResultCubit extends Cubit<ImportExamResultState> {
  ImportExamResultCubit(this._repository) : super(ImportExamResultState.initial());

  ExamResultRepository _repository;

  Future importExamResult(ImportExamResultDataInput input) async {
    emit(state.copyWith(importExamResultStatus: ImportExamResultStatus.loading));

    try {
      BaseResponseModel baseResponseModel =
      await _repository.importExamResult(input);

      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
          importExamResultStatus: ImportExamResultStatus.success,
        ));
      } else {
        emit(state.copyWith(
            importExamResultStatus: ImportExamResultStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          importExamResultStatus: ImportExamResultStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
