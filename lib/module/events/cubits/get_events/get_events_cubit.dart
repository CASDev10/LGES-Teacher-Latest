import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failures/base_failures/base_failure.dart';
import '../../../../../core/failures/high_priority_failure.dart';
import '../models/get_events_input.dart';
import '../repo/events_repository.dart';
import 'get_events_state.dart';

class GetEventsCubit extends Cubit<GetEventsState> {
  final EventsRepository _repository;

  GetEventsCubit(this._repository) : super(GetEventsState.initial());

  Future<void> fetchEvents(GetEventsInput input) async {
    emit(state.copyWith(status: GetEventsStatus.loading));
    try {
      final response = await _repository.getEvents(input);
      if (response.result.toLowerCase() == "success") {
        emit(
          state.copyWith(
            status: GetEventsStatus.success,
            events: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: GetEventsStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          status: GetEventsStatus.failure,
          failure: HighPriorityException(e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GetEventsStatus.failure,
          failure: HighPriorityException(e.toString()),
        ),
      );
    }
  }
}
