import 'package:bloc/bloc.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import '../../../base_resposne_model.dart';
import '../../repo/observation_repo.dart';
import 'add_update_delete_level_state.dart';

class AddUpdateDeleteLevelCubit extends Cubit<AddUpdateDeleteLevelState> {
  AddUpdateDeleteLevelCubit(this.repository)
      : super(AddUpdateDeleteLevelState.initial());

  ObservationRepository repository;

  Future updateObservationLevel(String level , String levelId) async {
    emit(state.copyWith(
        levelStatus: AddUpdateDeleteLevelStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
      await repository.updateObservationLevel(level,levelId);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.success));
      } else {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          levelStatus: AddUpdateDeleteLevelStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
  Future addObservationLevel(String level ) async {
    emit(state.copyWith(
        levelStatus: AddUpdateDeleteLevelStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
      await repository.addObservationLevel(level);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.success));
      } else {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          levelStatus: AddUpdateDeleteLevelStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }

  Future deleteObservationLevel(String levelId) async {
    emit(state.copyWith(
        levelStatus: AddUpdateDeleteLevelStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
      await repository.deleteObservationLevel(levelId);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.success));
      } else {
        emit(state.copyWith(
            levelStatus: AddUpdateDeleteLevelStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          levelStatus: AddUpdateDeleteLevelStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
