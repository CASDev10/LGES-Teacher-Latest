import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/home/repo/home_repo.dart';

import '../../../core/api_result.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/failures/high_priority_failure.dart';
import '../models/app_config_reponse.dart';
import 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  AppConfigCubit(this._repository) : super(AppConfigState.initial());

  HomeRepository _repository;

  Future getAppConfig() async {
    emit(state.copyWith(appConfigStatus: AppConfigStatus.loading));

    try {
      MobileAppConfigResponse response = await _repository.getAppConfig();
      if (response.result == ApiResult.success) {
        emit(state.copyWith(
          appConfigStatus: AppConfigStatus.success,
        ));
      } else {
        emit(state.copyWith(
            appConfigStatus: AppConfigStatus.failure,
            failure: HighPriorityException(response.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          appConfigStatus: AppConfigStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
