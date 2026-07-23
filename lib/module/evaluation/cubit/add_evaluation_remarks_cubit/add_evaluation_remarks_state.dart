import '../../../../core/failures/base_failures/base_failure.dart';

enum AddEvaluationRemarksStatus { none, loading, success, failure }

class AddEvaluationRemarksState {
  final AddEvaluationRemarksStatus addEvaluationRemarksStatus;
  final BaseFailure failure;

  AddEvaluationRemarksState({
    required this.addEvaluationRemarksStatus,
    required this.failure,
  });

  factory AddEvaluationRemarksState.initial() {
    return AddEvaluationRemarksState(
      addEvaluationRemarksStatus: AddEvaluationRemarksStatus.none,
      failure: const BaseFailure(),
    );
  }

  AddEvaluationRemarksState copyWith({
    AddEvaluationRemarksStatus? addEvaluationRemarksStatus,
    BaseFailure? failure,
  }) {
    return AddEvaluationRemarksState(
      addEvaluationRemarksStatus:
          addEvaluationRemarksStatus ?? this.addEvaluationRemarksStatus,
      failure: failure ?? this.failure,
    );
  }
}
