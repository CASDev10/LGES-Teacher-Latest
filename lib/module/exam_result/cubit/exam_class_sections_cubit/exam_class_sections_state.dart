import 'package:lges_teacher_app/module/exam_result/models/exam_class_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_sections_response.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/evaluation_response.dart';
import '../../models/evaluation_type_response.dart';
import '../../models/group_evaluation_response.dart';

enum ExamClassSectionsStatus { none, loading, success, failure }

class ExamClassSectionsState {
  final ExamClassSectionsStatus examClassSectionsStatus;
  final BaseFailure failure;
  final List<ExamClassSectionModel> classSections;
  final List<EvaluationTypeModel> evaluationTypes;
  final List<EvaluationModel> evaluations;
  final List<EvaluationGroupModel> evaluationsGroups;
  ExamClassSectionsState({
    required this.examClassSectionsStatus,
    required this.failure,
    required this.classSections,
    required this.evaluationTypes,
    required this.evaluations,
    required this.evaluationsGroups,
  });

  factory ExamClassSectionsState.initial() {
    return ExamClassSectionsState(
      examClassSectionsStatus: ExamClassSectionsStatus.none,
      failure: const BaseFailure(),
      classSections: [],
      evaluationTypes: [],
      evaluations: [],
      evaluationsGroups: [],
    );
  }

  ExamClassSectionsState copyWith({
    ExamClassSectionsStatus? examClassSectionsStatus,
    BaseFailure? failure,
    List<ExamClassSectionModel>? classSections,
    List<EvaluationTypeModel>? evaluationTypes,
    List<EvaluationModel>? evaluations,
    List<EvaluationGroupModel>? evaluationsGroups,
  }) {
    return ExamClassSectionsState(
      examClassSectionsStatus:
          examClassSectionsStatus ?? this.examClassSectionsStatus,
      failure: failure ?? this.failure,
      classSections: classSections ?? this.classSections,
      evaluationTypes: evaluationTypes ?? this.evaluationTypes,
      evaluations: evaluations ?? this.evaluations,
      evaluationsGroups: evaluationsGroups ?? this.evaluationsGroups,
    );
  }
}
