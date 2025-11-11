import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../constants/api_endpoints.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../../base_resposne_model.dart';
import '../models/add_event_input.dart';
import '../models/get_events_input.dart';
import '../models/get_events_response.dart';

class EventsRepository {
  final NetworkService _networkService = sl<NetworkService>();
  final AuthRepository _authRepository = sl<AuthRepository>();

  Future<BaseResponseModel> addUpdateEvent(AddEventInput input) async {
    try {
      final response = await _networkService.post(
        Endpoints.addEvent,
        data: input.toJson(),
      );
      BaseResponseModel baseResponseModel = await compute(
        baseResponseModelFromJson,
        response,
      );
      return baseResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e, s) {
      log('❌ TYPE error in AddEvent: $e');
      log('STACK TRACE: $s');
      rethrow;
    }
  }

  Future<GetEventsResponse> getEvents(GetEventsInput input) async {
    try {
      final response = await _networkService.post(
        Endpoints.calendarEvents,
        data: input.toJson(),
      );
      GetEventsResponse getEventsResponse = await compute(
        getEventsResponseFromJson,
        response,
      );
      return getEventsResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e, s) {
      log('❌ TYPE error in GetEvents: $e');
      log('STACK TRACE: $s');
      rethrow;
    }
  }
}
