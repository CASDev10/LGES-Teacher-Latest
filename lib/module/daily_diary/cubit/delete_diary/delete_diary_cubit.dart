import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/delete_diary/delete_diary_state.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_response.dart';
import 'package:lges_teacher_app/module/daily_diary/repo/diary_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../pages/delete_diary_input.dart';

class DeleteDiaryCubit extends Cubit<DeleteDiaryState> {
  DeleteDiaryCubit(this._repository) : super(DeleteDiaryState.initial());

  DiaryRepository _repository;

  Future deleteDiary(DeleteDiaryInput input) async {
    emit(state.copyWith(deleteDiaryStatus: DeleteDiaryStatus.loading));
    try {
      AddDiaryResponseModel response = await _repository.deleteDiary(input);
      if (response.result == ApiResult.success) {
        emit(state.copyWith(deleteDiaryStatus: DeleteDiaryStatus.success));
      } else {
        emit(
          state.copyWith(
            deleteDiaryStatus: DeleteDiaryStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          deleteDiaryStatus: DeleteDiaryStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
