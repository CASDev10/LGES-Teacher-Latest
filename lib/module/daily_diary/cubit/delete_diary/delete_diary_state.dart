import '../../../../core/failures/base_failures/base_failure.dart';

enum DeleteDiaryStatus { none, loading, success, failure }

class DeleteDiaryState {
  final DeleteDiaryStatus deleteDiaryStatus;
  final BaseFailure failure;

  DeleteDiaryState({required this.deleteDiaryStatus, required this.failure});

  factory DeleteDiaryState.initial() {
    return DeleteDiaryState(
      deleteDiaryStatus: DeleteDiaryStatus.none,
      failure: const BaseFailure(),
    );
  }
  DeleteDiaryState copyWith({
    DeleteDiaryStatus? deleteDiaryStatus,
    BaseFailure? failure,
  }) {
    return DeleteDiaryState(
      deleteDiaryStatus: deleteDiaryStatus ?? this.deleteDiaryStatus,
      failure: failure ?? this.failure,
    );
  }
}
