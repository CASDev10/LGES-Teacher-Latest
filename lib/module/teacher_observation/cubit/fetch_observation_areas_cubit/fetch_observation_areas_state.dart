part of 'fetch_observation_areas_cubit.dart';



enum FetchObservationAreasStatus {
  none,
  loading,
  success,
  failure,
}


class FetchObservationAreasState {
  final FetchObservationAreasStatus fetchObservationAreasStatus;
  final BaseFailure failure;
  final ObservationModel? observationModel;

  FetchObservationAreasState(
      { required this.fetchObservationAreasStatus, required this.failure, required this.observationModel});

  factory FetchObservationAreasState.initial(){
    return FetchObservationAreasState(
        fetchObservationAreasStatus: FetchObservationAreasStatus.none,
        failure: const BaseFailure(), observationModel:null);
  }


  FetchObservationAreasState copyWith({
    FetchObservationAreasStatus? fetchObservationAreasStatus,
    BaseFailure? failure,
    ObservationModel? observationModel

  }) {
    return FetchObservationAreasState(
        fetchObservationAreasStatus: fetchObservationAreasStatus ??
            this.fetchObservationAreasStatus,
        failure: failure ?? this.failure,
        observationModel: observationModel??this.observationModel
    );
  }

}