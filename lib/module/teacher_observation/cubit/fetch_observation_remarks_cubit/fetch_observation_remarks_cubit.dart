import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_remarks_cubit/fetch_observation_remarks_state.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_remarks_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/observation_repo.dart';

class FetchObservationRemarksCubit extends Cubit<FetchObservationRemarksState> {
  FetchObservationRemarksCubit(this.repository)
    : super(FetchObservationRemarksState.initial());
  ObservationRepository repository;

  Future getObservationRemarks() async {
    emit(
      state.copyWith(
        fetchObservationRemarksStatus: FetchObservationRemarksStatus.loading,
      ),
    );
    try {
      ObservationRemarksResponse observationRemarksResponse = await repository
          .getObservationRemarks();
      observationRemarksResponse.data.sort(
        (a, b) => b.createdDate.compareTo(a.createdDate),
      );
      if (observationRemarksResponse.result == ApiResult.success) {
        emit(
          state.copyWith(
            fetchObservationRemarksStatus:
                FetchObservationRemarksStatus.success,
            remarks: observationRemarksResponse.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            fetchObservationRemarksStatus:
                FetchObservationRemarksStatus.failure,
            failure: HighPriorityException(observationRemarksResponse.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          fetchObservationRemarksStatus: FetchObservationRemarksStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
