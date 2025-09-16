part of 'subjects_cubit.dart';

enum SubjectsStatus {
  none,
  loading,
  success,
  failure,
}

class SubjectsState {
  final SubjectsStatus subjectsStatus;
  final BaseFailure failure;
  final List<SubjectModel> subjects;

  SubjectsState({
    required this.subjectsStatus,
    required this.failure,
    required this.subjects,
  });

  factory SubjectsState.initial() {
    return SubjectsState(
      subjectsStatus: SubjectsStatus.none,
      failure: const BaseFailure(),
      subjects: [],
    );
  }

  SubjectsState copyWith({
    SubjectsStatus? subjectsStatus,
    BaseFailure? failure,
    List<SubjectModel>? subjects,
  }) {
    return SubjectsState(
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      failure: failure ?? this.failure,
      subjects: subjects ?? this.subjects,
    );
  }
}
