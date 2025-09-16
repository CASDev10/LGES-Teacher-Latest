import 'package:lges_teacher_app/module/exam_result/models/exam_class_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_sections_response.dart';

import '../../../../core/failures/base_failures/base_failure.dart';

enum ExamClassSectionsStatus {
  none,
  loading,
  success,
  failure,
}

class ExamClassSectionsState {
  final ExamClassSectionsStatus examClassSectionsStatus;
  final BaseFailure failure;
  final List<ExamClassSectionModel> classSections;

  ExamClassSectionsState({
    required this.examClassSectionsStatus,
    required this.failure,
    required this.classSections,
  });

  factory ExamClassSectionsState.initial() {
    return ExamClassSectionsState(
      examClassSectionsStatus: ExamClassSectionsStatus.none,
      failure: const BaseFailure(),
      classSections: [],
    );
  }

  ExamClassSectionsState copyWith({
    ExamClassSectionsStatus? examClassSectionsStatus,
    BaseFailure? failure,
    List<ExamClassSectionModel>? classSections,
  }) {
    return ExamClassSectionsState(
      examClassSectionsStatus: examClassSectionsStatus ?? this.examClassSectionsStatus,
      failure: failure ?? this.failure,
      classSections: classSections ?? this.classSections,
    );
  }
}

