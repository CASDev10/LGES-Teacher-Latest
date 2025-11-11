import '../../../../../core/failures/high_priority_failure.dart';
import '../../models/get_events_response.dart';

enum GetEventsStatus { initial, loading, success, failure }

class GetEventsState {
  final GetEventsStatus status;
  final List<EventModel> events;
  final HighPriorityException failure;

  const GetEventsState({
    required this.status,
    required this.events,
    required this.failure,
  });

  factory GetEventsState.initial() => GetEventsState(
    status: GetEventsStatus.initial,
    events: const [],
    failure: const HighPriorityException(""),
  );

  GetEventsState copyWith({
    GetEventsStatus? status,
    List<EventModel>? events,
    HighPriorityException? failure,
  }) {
    return GetEventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      failure: failure ?? this.failure,
    );
  }
}
