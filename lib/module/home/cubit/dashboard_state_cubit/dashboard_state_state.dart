import 'package:lges_teacher_app/core/failures/base_failures/base_failure.dart';

enum DashboardStateStatus {
  none,
  loading,
  success,
  failure,
}

class DashboardStateState {
  final DashboardStateStatus dashboardStateStatus;
  final BaseFailure failure;

  DashboardStateState({
    required this.dashboardStateStatus,
    required this.failure,
  });

  factory DashboardStateState.initial() {
    return DashboardStateState(
      dashboardStateStatus: DashboardStateStatus.none,
      failure: const BaseFailure()
    );
  }

  DashboardStateState copyWith({
    DashboardStateStatus? dashboardStateStatus,
    BaseFailure? failure,
  }) {
    return DashboardStateState(
      dashboardStateStatus: dashboardStateStatus ?? this.dashboardStateStatus,
      failure: failure ?? this.failure
    );
  }
}