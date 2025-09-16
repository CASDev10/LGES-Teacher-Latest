part of 'add_update_delete_remarks_cubit.dart';

enum AddUpdateDeleteRemarksStatus {
  none,
  loading,
  success,
  failure,
}

class AddUpdateDeleteRemarksState{
  final AddUpdateDeleteRemarksStatus remarksStatus;
  final BaseFailure failure;
  final BaseResponseModel? baseResponseModel;

  AddUpdateDeleteRemarksState({required this.remarksStatus, required this.failure, required this.baseResponseModel});

  factory AddUpdateDeleteRemarksState.initial(){
    return AddUpdateDeleteRemarksState(
        remarksStatus: AddUpdateDeleteRemarksStatus.none,
        failure: const BaseFailure(), baseResponseModel: null);
  }

  AddUpdateDeleteRemarksState copyWith({
    AddUpdateDeleteRemarksStatus? remarksStatus,
    BaseFailure? failure,
    BaseResponseModel? baseResponseModel

  }) {
    return AddUpdateDeleteRemarksState(
      remarksStatus: remarksStatus ?? this.remarksStatus,
      failure: failure ?? this.failure,
      baseResponseModel: baseResponseModel ?? this.baseResponseModel,
    );
  }

}
