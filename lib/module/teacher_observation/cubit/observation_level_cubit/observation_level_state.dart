part of 'observation_level_cubit.dart';




enum ObservationLevelStatus{
  none,
  loading,
  success,
  failure,
}

class ObservationLevelState {
  final ObservationLevelStatus observationLevelStatus;
  final BaseFailure failure;
  final List<ObservationLevelModel> levels;

  ObservationLevelState({required this.observationLevelStatus, required this.failure, required this.levels});

  factory ObservationLevelState.initial() {
    return ObservationLevelState(
      observationLevelStatus: ObservationLevelStatus.none,
      failure: const BaseFailure(),
      levels: [],
    );
  }




  ObservationLevelState copyWith({
    ObservationLevelStatus? observationLevelStatus,
    BaseFailure? failure,
    List<ObservationLevelModel>? levels,
  }) {
    return ObservationLevelState(
      observationLevelStatus: observationLevelStatus ?? this.observationLevelStatus,
      failure: failure ?? this.failure,
      levels: levels ?? this.levels,
    );
  }

}
