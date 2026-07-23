import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/diary_list_response.dart';

enum DiaryListStatus { none, loading, success, failure }

class DiaryListState {
  final DiaryListStatus diaryListStatus;
  final BaseFailure failure;
  final List<DiaryModel> diaryList;

  DiaryListState({
    required this.diaryListStatus,
    required this.failure,
    required this.diaryList,
  });

  factory DiaryListState.initial() {
    return DiaryListState(
      diaryListStatus: DiaryListStatus.none,
      failure: const BaseFailure(),
      diaryList: [],
    );
  }
  DiaryListState copyWith({
    DiaryListStatus? diaryListStatus,
    BaseFailure? failure,
    List<DiaryModel>? diaryList,
  }) {
    return DiaryListState(
      diaryListStatus: diaryListStatus ?? this.diaryListStatus,
      failure: failure ?? this.failure,
      diaryList: diaryList ?? this.diaryList,
    );
  }
}
