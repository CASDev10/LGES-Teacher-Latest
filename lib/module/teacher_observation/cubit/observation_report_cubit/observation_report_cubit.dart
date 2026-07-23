import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_report_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/repo/observation_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';

part 'observation_report_state.dart';

class ObservationReportCubit extends Cubit<ObservationReportState> {
  ObservationReportCubit(this.repository)
    : super(ObservationReportState.initial());

  ObservationRepository repository;
  Future getObservationReport(String startDate, String endDate) async {
    emit(
      state.copyWith(observationReportStatus: ObservationReportStatus.loading),
    );
    try {
      ObservationReportResponse observationReportResponse = await repository
          .getObservationReport(startDate, endDate);
      if (observationReportResponse.result == ApiResult.success) {
        emit(
          state.copyWith(
            observationReportStatus: ObservationReportStatus.success,
            observationReportList: observationReportResponse.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            observationReportStatus: ObservationReportStatus.failure,
            failure: HighPriorityException(observationReportResponse.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          observationReportStatus: ObservationReportStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
