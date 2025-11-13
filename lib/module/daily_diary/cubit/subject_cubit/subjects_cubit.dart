import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/daily_diary/models/subjects_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/diary_repo.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit(this._repository) : super(SubjectsState.initial());
  DiaryRepository _repository;

  Future fetchSubjects(String classId, String sectionId) async {
    emit(state.copyWith(subjectsStatus: SubjectsStatus.loading));

    try {
      SubjectsResponseModel responseModel = await _repository.getClassSubjects(
        classId,
        sectionId,
      );

      if (responseModel.result == ApiResult.success) {
        emit(
          state.copyWith(
            subjectsStatus: SubjectsStatus.success,
            subjects: responseModel.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            subjectsStatus: SubjectsStatus.failure,
            failure: HighPriorityException(responseModel.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          subjectsStatus: SubjectsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
