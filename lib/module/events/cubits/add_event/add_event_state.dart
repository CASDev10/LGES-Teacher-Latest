import '../../../../../core/failures/high_priority_failure.dart';

/// Status of the AddEvent process
enum AddEventStatus { initial, loading, success, failure }

class AddEventState {
  final AddEventStatus status;
  final HighPriorityException failure;

  const AddEventState({required this.status, required this.failure});

  /// Initial state
  factory AddEventState.initial() => const AddEventState(
    status: AddEventStatus.initial,
    failure: HighPriorityException(""),
  );

  /// CopyWith to update the state
  AddEventState copyWith({
    AddEventStatus? status,
    HighPriorityException? failure,
  }) {
    return AddEventState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
