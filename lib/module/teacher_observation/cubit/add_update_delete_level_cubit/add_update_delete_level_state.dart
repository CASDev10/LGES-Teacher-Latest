

import 'package:lges_teacher_app/module/base_resposne_model.dart';

import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/observation_levels_response.dart';

enum AddUpdateDeleteLevelStatus {
  none,
  loading,
  success,
  failure,
}


class AddUpdateDeleteLevelState {
  final AddUpdateDeleteLevelStatus levelStatus;
  final BaseFailure failure;
  final BaseResponseModel? baseResponseModel;

  AddUpdateDeleteLevelState(
      { required this.levelStatus, required this.failure, required this.baseResponseModel});

  factory AddUpdateDeleteLevelState.initial(){
    return AddUpdateDeleteLevelState(
        levelStatus: AddUpdateDeleteLevelStatus.none,
        failure: const BaseFailure(), baseResponseModel: null);
  }


  AddUpdateDeleteLevelState copyWith({
    AddUpdateDeleteLevelStatus? levelStatus,
    BaseFailure? failure,
    BaseResponseModel? baseResponseModel

  }) {
    return AddUpdateDeleteLevelState(
      levelStatus: levelStatus ?? this.levelStatus,
        failure: failure ?? this.failure,
        baseResponseModel: baseResponseModel ?? this.baseResponseModel,
    );
  }

}