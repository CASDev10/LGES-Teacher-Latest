import 'package:lges_teacher_app/core/failures/base_failures/base_failure.dart';
import 'package:lges_teacher_app/module/home/models/dashboard_stats_model.dart';

enum DashboardStateStatus {
  none,
  loading,
  success,
  failure,
}

class DashboardStateState {
  final DashboardStateStatus dashboardStateStatus;
  final DashboardStatsModel? dashboardStats;
  final BaseFailure failure;

  DashboardStateState({
    required this.dashboardStateStatus,
    this.dashboardStats,
    required this.failure,
  });

  factory DashboardStateState.initial() {
    return DashboardStateState(
      dashboardStateStatus: DashboardStateStatus.none,
      dashboardStats: null,
      failure: const BaseFailure(),
    );
  }

  DashboardStateState copyWith({
    DashboardStateStatus? dashboardStateStatus,
    DashboardStatsModel? dashboardStats,
    BaseFailure? failure,
  }) {
    return DashboardStateState(
      dashboardStateStatus: dashboardStateStatus ?? this.dashboardStateStatus,
      dashboardStats: dashboardStats ?? this.dashboardStats,
      failure: failure ?? this.failure,
    );
  }
}