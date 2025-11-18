import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/chat/repo/chat_repository.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../models/conversations_response.dart';
import 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit(this._repository) : super(ConversationsState.initial());

  ChatRepository _repository;
  Future getConversations({bool isLoading = true}) async {
    if (isLoading)
      emit(state.copyWith(conversationsStatus: ConversationsStatus.loading));
    try {
      ConversationsResponse response = await _repository.getConversations();
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            conversationsStatus: ConversationsStatus.success,
            conversations: response.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            conversationsStatus: ConversationsStatus.failure,
            message: response.message,
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          conversationsStatus: ConversationsStatus.failure,
          message: e.message,
        ),
      );
    } catch (_) {}
  }
}
