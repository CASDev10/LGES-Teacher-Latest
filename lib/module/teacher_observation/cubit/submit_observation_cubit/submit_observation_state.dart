part of 'submit_observation_cubit.dart';



enum SubmitObservationStatus{
  none,
  loading,
  success,
  failure,
}

class SubmitObservationState {
  final SubmitObservationStatus submitObservationStatus;
  final BaseFailure failure;
  final BaseResponseModel? baseResponseModel;

  SubmitObservationState({required this.submitObservationStatus, required this.failure, required this.baseResponseModel});

  factory SubmitObservationState.initial(){
    return SubmitObservationState(
        submitObservationStatus: SubmitObservationStatus.none,
        failure: const BaseFailure(), baseResponseModel: null);
  }


  SubmitObservationState copyWith({
    SubmitObservationStatus? submitObservationStatus,
    BaseFailure? failure,
    BaseResponseModel? baseResponseModel

  }) {
    return SubmitObservationState(
      submitObservationStatus: submitObservationStatus ?? this.submitObservationStatus,
      failure: failure ?? this.failure,
      baseResponseModel: baseResponseModel ?? this.baseResponseModel,
    );
  }
}


