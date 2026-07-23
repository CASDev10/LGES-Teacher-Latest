import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/observation_remarks_response.dart';

enum FetchObservationRemarksStatus { none, loading, success, failure }

class FetchObservationRemarksState {
  final FetchObservationRemarksStatus fetchObservationRemarksStatus;
  final BaseFailure failure;
  final List<ObservationRemarksModel> remarks;

  FetchObservationRemarksState({
    required this.fetchObservationRemarksStatus,
    required this.failure,
    required this.remarks,
  });

  factory FetchObservationRemarksState.initial() {
    return FetchObservationRemarksState(
      fetchObservationRemarksStatus: FetchObservationRemarksStatus.none,
      failure: const BaseFailure(),
      remarks: [],
    );
  }

  FetchObservationRemarksState copyWith({
    FetchObservationRemarksStatus? fetchObservationRemarksStatus,
    BaseFailure? failure,
    List<ObservationRemarksModel>? remarks,
  }) {
    return FetchObservationRemarksState(
      fetchObservationRemarksStatus:
          fetchObservationRemarksStatus ?? this.fetchObservationRemarksStatus,
      failure: failure ?? this.failure,
      remarks: remarks ?? this.remarks,
    );
  }
}
