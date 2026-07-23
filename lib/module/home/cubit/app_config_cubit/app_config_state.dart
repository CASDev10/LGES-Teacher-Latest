



import '../../../../core/failures/base_failures/base_failure.dart';

enum AppConfigStatus {
  none,
  loading,
  success,
  failure,
}

class AppConfigState {
  final AppConfigStatus appConfigStatus;
  final BaseFailure failure;

  AppConfigState({
    required this.appConfigStatus,
    required this.failure,
  });

  factory AppConfigState.initial() {
    return AppConfigState(
      appConfigStatus: AppConfigStatus.none,
      failure: const BaseFailure()
    );
  }

  AppConfigState copyWith({
    AppConfigStatus? appConfigStatus,
    BaseFailure? failure,
  }) {
    return AppConfigState(
      appConfigStatus: appConfigStatus ?? this.appConfigStatus,
      failure: failure ?? this.failure
    );
  }
}