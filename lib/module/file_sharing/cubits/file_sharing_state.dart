import '../../../core/failures/base_failures/base_failure.dart';

enum FileSharingStatus { none, loading, success, failure }

class FileSharingState {
  final FileSharingStatus status;
  final BaseFailure failure;

  FileSharingState({required this.status, required this.failure});

  factory FileSharingState.initial() {
    return FileSharingState(
      status: FileSharingStatus.none,
      failure: const BaseFailure(),
    );
  }

  FileSharingState copyWith({FileSharingStatus? status, BaseFailure? failure}) {
    return FileSharingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
