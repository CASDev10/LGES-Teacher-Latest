import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/chat/models/conversations_response.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../models/chat_history_response.dart';
import '../models/send_message_response.dart';

class ChatRepository {
  final NetworkService _networkService = sl<NetworkService>();
  AuthRepository _authRepository = sl<AuthRepository>();

  Future<ConversationsResponse> getConversations() async {
    try {
      Map<String, dynamic> input = {"EmpId": _authRepository.user.empId};

      var response = await _networkService.post(
        Endpoints.getConversations,
        data: input,
      );
      ConversationsResponse conversationsResponse = await compute(
        conversationsResponseFromJson,
        response,
      );
      return conversationsResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<ChatHistoryResponse> getChatHistory(int id) async {
    try {
      Map<String, dynamic> input = {"ConversationId": id};

      var response = await _networkService.post(
        Endpoints.getChatHistory,
        data: input,
      );
      ChatHistoryResponse chatHistoryResponse = await compute(
        chatHistoryResponseFromJson,
        response,
      );
      return chatHistoryResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<SendMessageResponse> sendMessage(int studentId, String message) async {
    try {
      Map<String, dynamic> input = {
        "EmpId": _authRepository.user.empId,
        "StudentId": studentId,
        "Text": message,
      };

      var response = await _networkService.post(
        Endpoints.sendMessage,
        data: input,
      );
      SendMessageResponse sendMessageResponse = await compute(
        sendMessageResponseFromJson,
        response,
      );
      return sendMessageResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
