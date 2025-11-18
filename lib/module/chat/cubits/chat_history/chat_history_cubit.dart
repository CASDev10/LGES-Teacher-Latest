import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/chat/repo/chat_repository.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/chat_history_response.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  ChatHistoryCubit(this._repository) : super(ChatHistoryState.initial());
  ChatRepository _repository;

  Future getChatHistory(int id, {bool isLoading = true}) async {
    if (isLoading)
      emit(state.copyWith(chatHistoryStatus: ChatHistoryStatus.loading));
    try {
      ChatHistoryResponse response = await _repository.getChatHistory(id);
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            chatHistoryStatus: ChatHistoryStatus.success,
            messages: response.data.reversed.toList(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            chatHistoryStatus: ChatHistoryStatus.failure,
            message: response.message,
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          chatHistoryStatus: ChatHistoryStatus.failure,
          message: e.message,
        ),
      );
    } catch (_) {}
  }
}
