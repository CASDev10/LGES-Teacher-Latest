import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../models/observation_levels_response.dart';
import '../../repo/observation_repo.dart';

part 'observation_level_state.dart';

class ObservationLevelCubit extends Cubit<ObservationLevelState> {
  ObservationLevelCubit(this.repository)
    : super(ObservationLevelState.initial());
  ObservationRepository repository;

  Future getObservationLevels() async {
    try {
      ObservationLevelsResponse observationLevelsResponse = await repository
          .getObservationLevels();
      observationLevelsResponse.data.sort(
        (a, b) => b.createdDate.compareTo(a.createdDate),
      );
      if (observationLevelsResponse.result == ApiResult.success) {
        emit(
          state.copyWith(
            observationLevelStatus: ObservationLevelStatus.success,
            levels: observationLevelsResponse.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            observationLevelStatus: ObservationLevelStatus.failure,
            failure: HighPriorityException(observationLevelsResponse.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          observationLevelStatus: ObservationLevelStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (_) {}
  }
}
