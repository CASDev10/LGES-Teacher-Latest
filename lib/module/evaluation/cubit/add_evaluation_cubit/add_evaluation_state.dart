


import '../../../../core/failures/base_failures/base_failure.dart';

enum AddEvaluationStatus {
  none,
  loading,
  success,
  failure,
}

class AddEvaluationState {
  final AddEvaluationStatus addEvaluationStatus;
  final BaseFailure failure;

  AddEvaluationState({
    required this.addEvaluationStatus,
    required this.failure,
  });

  factory AddEvaluationState.initial() {
    return AddEvaluationState(
        addEvaluationStatus: AddEvaluationStatus.none,
        failure: const BaseFailure()
    );
  }

  AddEvaluationState copyWith({
    AddEvaluationStatus? addEvaluationStatus,
    BaseFailure? failure
  }) {
    return AddEvaluationState(
      addEvaluationStatus: addEvaluationStatus ?? this.addEvaluationStatus,
      failure: failure ?? this.failure,
    );
  }
}