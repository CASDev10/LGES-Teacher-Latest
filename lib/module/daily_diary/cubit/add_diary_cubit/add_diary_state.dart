import '../../../../core/failures/base_failures/base_failure.dart';

enum AddDiaryStatus { none, loading, success, failure }

class AddDiaryState {
  final AddDiaryStatus addDiaryStatus;
  final BaseFailure failure;

  AddDiaryState({required this.addDiaryStatus, required this.failure});

  factory AddDiaryState.initial() {
    return AddDiaryState(
      addDiaryStatus: AddDiaryStatus.none,
      failure: const BaseFailure(),
    );
  }
  AddDiaryState copyWith({
    AddDiaryStatus? addDiaryStatus,
    BaseFailure? failure,
  }) {
    return AddDiaryState(
      addDiaryStatus: addDiaryStatus ?? this.addDiaryStatus,
      failure: failure ?? this.failure,
    );
  }
}
