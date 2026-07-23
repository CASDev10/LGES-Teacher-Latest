import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/auth/cubit/user_schools_cubit/user_schools_cubit.dart';
import 'package:lges_teacher_app/module/auth/models/user_schools_model.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';

class UserSchoolsRepository {
  final NetworkService _networkService = sl<NetworkService>();

  Future<UserSchoolsModel> getUserSchools(UserSchoolsInput input) async {
    try {
      var response = await _networkService.get(
        Endpoints.getUserSchools,
        data: input.toJson(),
      );

      UserSchoolsModel userSchoolsModel = await compute(
        userSchoolsModelFromJson,
        response,
      );

      return userSchoolsModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
