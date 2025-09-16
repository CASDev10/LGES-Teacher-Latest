part of 'evaluation_remarks_cubit.dart';

enum EvaluationRemarksStatus {
  none,
  loading,
  success,
  failure,
}

class EvaluationRemarksState {
  final EvaluationRemarksStatus evaluationRemarksStatus;
  final BaseFailure failure;
  final List<EvaluationRemarksModel> evaluationRemarks;

  EvaluationRemarksState({
    required this.evaluationRemarksStatus,
    required this.failure,
    required this.evaluationRemarks,
  });

  factory EvaluationRemarksState.initial() {
    return EvaluationRemarksState(
      evaluationRemarksStatus: EvaluationRemarksStatus.none,
      failure: const BaseFailure(),
      evaluationRemarks: [],
    );
  }

  EvaluationRemarksState copyWith({
    EvaluationRemarksStatus? evaluationRemarksStatus,
    BaseFailure? failure,
    List<EvaluationRemarksModel>? evaluationRemarks,
  }) {
    return EvaluationRemarksState(
      evaluationRemarksStatus: evaluationRemarksStatus ?? this.evaluationRemarksStatus,
      failure: failure ?? this.failure,
      evaluationRemarks: evaluationRemarks ?? this.evaluationRemarks,
    );
  }
}