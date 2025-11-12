import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/daily_diary/repo/diary_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/diary_list_response.dart';
import 'diary_list_state.dart';

class DiaryListCubit extends Cubit<DiaryListState> {
  DiaryListCubit(this._repository) : super(DiaryListState.initial());

  DiaryRepository _repository;
  Future fetchDiaryList(String fromDate, String toDate) async {
    emit(state.copyWith(diaryListStatus: DiaryListStatus.loading));
    try {
      DiaryListResponseModel response = await _repository.getDiaryList(
        fromDate,
        toDate,
      );
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            diaryListStatus: DiaryListStatus.success,
            diaryList: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            diaryListStatus: DiaryListStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          diaryListStatus: DiaryListStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
