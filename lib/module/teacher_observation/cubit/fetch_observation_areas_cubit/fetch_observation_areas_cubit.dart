import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_areas_response.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../repo/observation_repo.dart';
import 'fetch_observation_areas_cubit.dart';

part 'fetch_observation_areas_state.dart';

class FetchObservationAreasCubit
    extends Cubit<FetchObservationAreasState> {
  FetchObservationAreasCubit(this.repository)
      : super(FetchObservationAreasState.initial());

  ObservationRepository repository;

  Future getObservationAreas() async {
    emit(state.copyWith(
        fetchObservationAreasStatus: FetchObservationAreasStatus.loading));
    try {
      ObservationAreasResponse observationAreasResponse =
          await repository.getObservationAreas();

      if (observationAreasResponse.result == ApiResult.success) {
        emit(state.copyWith(
            fetchObservationAreasStatus: FetchObservationAreasStatus.success,
            observationModel: observationAreasResponse.data));
      } else {
        emit(state.copyWith(
            fetchObservationAreasStatus: FetchObservationAreasStatus.failure,
            failure: HighPriorityException(observationAreasResponse.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          fetchObservationAreasStatus: FetchObservationAreasStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
