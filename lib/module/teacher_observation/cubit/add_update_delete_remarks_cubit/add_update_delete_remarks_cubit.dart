import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/core/core.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/teacher_observation/repo/observation_repo.dart';
import 'package:meta/meta.dart';

import '../../../../core/api_result.dart';

part 'add_update_delete_remarks_state.dart';

class AddUpdateDeleteRemarksCubit extends Cubit<AddUpdateDeleteRemarksState> {
  AddUpdateDeleteRemarksCubit(this.repository)
      : super(AddUpdateDeleteRemarksState.initial());

  ObservationRepository repository;

  Future addObservationRemarks(String remarks, String areaId) async {
    emit(state.copyWith(remarksStatus: AddUpdateDeleteRemarksStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
          await repository.addObservationRemarks(remarks, areaId);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.success));
      } else {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          remarksStatus: AddUpdateDeleteRemarksStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }

  Future updateObservationRemarks(
      String remarks, String areaId, String remarksId) async {
    emit(state.copyWith(remarksStatus: AddUpdateDeleteRemarksStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
          await repository.updateObservationRemarks(remarksId, remarks, areaId);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.success));
      } else {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          remarksStatus: AddUpdateDeleteRemarksStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }

  Future deleteObservationRemarks(String remarksId) async {
    emit(state.copyWith(remarksStatus: AddUpdateDeleteRemarksStatus.loading));
    try {
      BaseResponseModel baseResponseModel =
          await repository.deleteObservationRemarks(remarksId);
      if (baseResponseModel.result == ApiResult.success) {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.success));
      } else {
        emit(state.copyWith(
            remarksStatus: AddUpdateDeleteRemarksStatus.failure,
            failure: HighPriorityException(baseResponseModel.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          remarksStatus: AddUpdateDeleteRemarksStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
