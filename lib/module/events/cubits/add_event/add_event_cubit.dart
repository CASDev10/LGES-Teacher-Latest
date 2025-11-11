import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failures/high_priority_failure.dart';
import '../../models/add_event_input.dart';
import '../../repo/events_repository.dart';
import 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  final EventsRepository _repository;

  AddEventCubit(this._repository) : super(AddEventState.initial());

  /// Add or update calendar event
  Future<void> addEvent({required AddEventInput input}) async {
    emit(state.copyWith(status: AddEventStatus.loading));

    try {
      final response = await _repository.addUpdateEvent(input);

      if (response.result.toLowerCase() == "success") {
        emit(state.copyWith(status: AddEventStatus.success));
      } else {
        emit(
          state.copyWith(
            status: AddEventStatus.failure,
            failure: HighPriorityException(response.message),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AddEventStatus.failure,
          failure: HighPriorityException(e.toString()),
        ),
      );
    }
  }
}
