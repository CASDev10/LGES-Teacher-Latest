import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/home/models/dashboard_stats_model.dart';
import 'package:lges_teacher_app/module/home/repo/home_repo.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import 'dashboard_state_state.dart';

class DashboardStateCubit extends Cubit<DashboardStateState> {
  DashboardStateCubit(this._repository) : super(DashboardStateState.initial());

  HomeRepository _repository;

  Future fetchDashboardStats() async {
    emit(state.copyWith(dashboardStateStatus: DashboardStateStatus.loading));

    try {
      DashboardStatsModel response = await _repository.getDashboardStats();
      if (response.result == ApiResult.success) {
        emit(state.copyWith(
          dashboardStateStatus: DashboardStateStatus.success,
        ));
      } else {
        emit(state.copyWith(
            dashboardStateStatus: DashboardStateStatus.failure,
            failure: HighPriorityException(response.message??"Something went wrong")));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          dashboardStateStatus: DashboardStateStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
