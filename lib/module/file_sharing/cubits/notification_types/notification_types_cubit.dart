import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/file_sharing/models/notification_types_response.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../home/repo/home_repo.dart';
import 'notification_types_state.dart';

class NotificationTypeCubit extends Cubit<NotificationTypeState> {
  NotificationTypeCubit(this._repository)
    : super(NotificationTypeState.initial());
  HomeRepository _repository;
  Future getNotificationTypes() async {
    emit(state.copyWith(status: NotificationTypeStatus.loading));
    try {
      NotificationTypesResponse response = await _repository
          .getNotificationTypeList();

      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            status: NotificationTypeStatus.success,
            message: response.message,
            types: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: NotificationTypeStatus.failure,
            message: response.message,
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          status: NotificationTypeStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationTypeStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
