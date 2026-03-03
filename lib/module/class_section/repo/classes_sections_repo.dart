import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/core/core.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/class_section/model/sections_model.dart';

import '../../../constants/api_endpoints.dart';
import '../model/classes_model.dart';

class ClassesSectionsRepository {
  final NetworkService _networkService = sl<NetworkService>();
  AuthRepository _authRepository = sl<AuthRepository>();

  Future<ClassesModel> getClasses(String schoolId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "UC_EntityId": _authRepository.user.entityId,
        "SchoolIdFk": schoolId,
      };

      var response = await _networkService.post(
        Endpoints.getClassesForAttendance,
        data: input,
      );

      ClassesModel classesModel = await compute(classesModelFromJson, response);

      return classesModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<SectionsModel> getSections(String classId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "UC_EntityId": _authRepository.user.entityId,
        "SchoolIdFk": _authRepository.user.schoolId,
        "ClassIdFk": classId,
      };

      var response = await _networkService.post(
        Endpoints.getSectionsForAttendance,
        data: input,
      );

      SectionsModel sectionsModel = await compute(
        sectionsModelFromJson,
        response,
      );

      return sectionsModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
