import 'package:bloc/bloc.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/chat/cubits/send_message/send_message_state.dart';
import 'package:lges_teacher_app/module/chat/repo/chat_repository.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(this._repository) : super(MessageState.initial());

  ChatRepository _repository;
  Future sendMessage(int studentId, String message) async {
    emit(state.copyWith(messageStatus: MessageStatus.loading));
    try {
      BaseResponseModel response = await _repository.sendMessage(
        studentId,
        message,
      );
      if (response.result == ApiResult.success) {
        emit(
          state.copyWith(
            messageStatus: MessageStatus.success,
            message: response.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            messageStatus: MessageStatus.failure,
            message: response.message,
          ),
        );
      }
    } on BaseFailure catch (e) {
      emit(
        state.copyWith(
          messageStatus: MessageStatus.failure,
          message: e.message,
        ),
      );
    } catch (_) {}
  }
}
