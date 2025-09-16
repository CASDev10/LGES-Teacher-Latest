part of 'observation_report_cubit.dart';



enum ObservationReportStatus{
  none,
  loading,
  success,
  failure,
}
class ObservationReportState {
  final ObservationReportStatus observationReportStatus;
  final BaseFailure failure;
  final List<ObservationReportModel> observationReportList;

  ObservationReportState({required this.observationReportStatus, required this.failure, required this.observationReportList});


  factory ObservationReportState.initial(){
    return ObservationReportState(
        observationReportStatus: ObservationReportStatus.none,
        failure: const BaseFailure(), observationReportList: []);
  }


  ObservationReportState copyWith({
    ObservationReportStatus? observationReportStatus,
    BaseFailure? failure,
    List<ObservationReportModel>? observationReportList

  }) {
    return ObservationReportState(
      observationReportStatus: observationReportStatus ?? this.observationReportStatus,
      failure: failure ?? this.failure,
      observationReportList: observationReportList ?? this.observationReportList,
    );
  }


}