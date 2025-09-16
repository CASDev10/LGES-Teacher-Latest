import 'package:lges_teacher_app/module/evaluation/models/student_evaluation_areas_response.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/evaluation_areas_response.dart';

enum EvaluationAreasStatus {
  none,
  loading,
  success,
  failure,
}

class EvaluationAreasState {
  final EvaluationAreasStatus evaluationAreasStatus;
  final BaseFailure failure;
  final StudentEvaluationAreaModel? evaluationAreas;

  EvaluationAreasState({
    required this.evaluationAreasStatus,
    required this.failure,
    required this.evaluationAreas,
  });

  factory EvaluationAreasState.initial() {
    return EvaluationAreasState(
      evaluationAreasStatus: EvaluationAreasStatus.none,
      failure: const BaseFailure(),
      evaluationAreas: null,
    );
  }

  EvaluationAreasState copyWith({
    EvaluationAreasStatus? evaluationAreasStatus,
    BaseFailure? failure,
  StudentEvaluationAreaModel? evaluationAreas,
  }) {
    return EvaluationAreasState(
      evaluationAreasStatus: evaluationAreasStatus ?? this.evaluationAreasStatus,
      failure: failure ?? this.failure,
      evaluationAreas: evaluationAreas ?? this.evaluationAreas,
    );
  }
}