import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/exam_result/models/evaluation_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/group_evaluation_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/import_exam_result_data_input.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../models/evaluation_type_response.dart';
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
    List<int> bytes,
    String fileName,
  ) async {
    try {
      FormData toFormData() => FormData.fromMap({
        "Description": jsonEncode(input),
        "ExamFile": MultipartFile.fromBytes(bytes, filename: fileName),
      });
      print('--- Exam Result Import Input ---${jsonEncode(input)}');
      var response = await _networkService.post(
        Endpoints.importExamResultData,
        data: toFormData(),
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

  Future<EvaluationTypeResponse> getEvaluationType() async {
    try {
      var response = await _networkService.get(Endpoints.getEvaluationTypes);
      EvaluationTypeResponse evaluationTypeResponse = await compute(
        evaluationTypeResponseFromJson,
        response,
      );
      return evaluationTypeResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<EvaluationResponse> getEvaluation({
    required int evaluationTypeId,
  }) async {
    try {
      var response = await _networkService.post(
        Endpoints.getEvaluation,
        data: {
          "UC_EntityId": _authRepository.user.entityId,
          "EvaluationTypeId": evaluationTypeId,
          "UC_SchoolId": _authRepository.user.schoolId,
        },
      );
      EvaluationResponse evaluationResponse = await compute(
        evaluationResponseFromJson,
        response,
      );
      return evaluationResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<GroupEvaluationResponse> getEvaluationGroups({
    required int evaluationTypeId,
  }) async {
    try {
      var response = await _networkService.post(
        Endpoints.getEvaluationGroups,
        data: {
          "EvaluationGroupId": evaluationTypeId,
          "IsActive": 1,
          "UC_SchoolId": _authRepository.user.schoolId,
        },
      );
      GroupEvaluationResponse groupEvaluationResponse = await compute(
        groupEvaluationResponseFromJson,
        response,
      );
      return groupEvaluationResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
