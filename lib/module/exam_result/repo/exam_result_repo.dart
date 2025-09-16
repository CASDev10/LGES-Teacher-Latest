import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/import_exam_result_data_input.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../models/exam_class_sections_response.dart';

class ExamResultRepository {
  final NetworkService _networkService = sl<NetworkService>();
  AuthRepository _authRepository = sl<AuthRepository>();

  Future<ExamClassResponse> getClasses(String schoolId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "UC_EntityId": _authRepository.user.entityId,
        "UC_SchoolId": schoolId,
      };

      var response = await _networkService.get(
        Endpoints.getClassesForExam,
        data: input,
      );

      ExamClassResponse getExamClassResponse = await compute(
        examClassResponseFromJson,
        response,
      );

      return getExamClassResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<ExamClassSectionsResponse> getSections(String classId) async {
    try {
      // Map<String, dynamic> input =  {
      //   "UC_LoginUserId": _authRepository.user.userId,
      //   "UC_EntityId": _authRepository.user.entityId,
      //   "UC_SchoolId": _authRepository.user.schoolId,
      //   "ClassIdFk": classId,
      // };

      Map<String, dynamic> input = {
        "SchoolId": _authRepository.user.schoolId,
        "ClassId": classId,
      };

      var response = await _networkService.get(
        Endpoints.getSectionsForExam,
        data: input,
      );

      ExamClassSectionsResponse examClassSectionsResponse = await compute(
        examClassSectionsResponseFromJson,
        response,
      );

      return examClassSectionsResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> importExamResult(
    ImportExamResultDataInput input,
  ) async {
    try {
      var response = await _networkService.post(
        Endpoints.importExamResultData,
        data: input.toJson(),
      );

      BaseResponseModel baseResponseModel = await compute(
        baseResponseModelFromJson,
        response,
      );

      return baseResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
