import '../../../../core/failures/base_failures/base_failure.dart';

enum ImportExamResultStatus {
  none,
  loading,
  success,
  failure,
}

class ImportExamResultState {
  final ImportExamResultStatus importExamResultStatus;
  final BaseFailure failure;

  ImportExamResultState({
    required this.importExamResultStatus,
    required this.failure,
  });

  factory ImportExamResultState.initial() {
    return ImportExamResultState(
      importExamResultStatus: ImportExamResultStatus.none,
      failure: const BaseFailure()
    );
  }

  ImportExamResultState copyWith({
    ImportExamResultStatus? importExamResultStatus,
    BaseFailure? failure,
  }) {
    return ImportExamResultState(
      importExamResultStatus: importExamResultStatus ?? this.importExamResultStatus,
      failure: failure ?? this.failure
    );
  }
}

