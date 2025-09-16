part of 'sections_cubit.dart';

enum SectionsStatus {
  none,
  loading,
  success,
  failure,
}

class SectionsState {
  final SectionsStatus sectionsStatus;
  final BaseFailure failure;
  final List<Section> sections;

  SectionsState({
    required this.sectionsStatus,
    required this.failure,
    required this.sections,
  });

  factory SectionsState.initial() {
    return SectionsState(
      sectionsStatus: SectionsStatus.none,
      failure: const BaseFailure(),
      sections: [],
    );
  }

  SectionsState copyWith({
    SectionsStatus? sectionsStatus,
    BaseFailure? failure,
    List<Section>? sections,
  }) {
    return SectionsState(
      sectionsStatus: sectionsStatus ?? this.sectionsStatus,
      failure: failure ?? this.failure,
      sections: sections ?? this.sections,
    );
  }
}
