import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';
import 'package:lges_teacher_app/module/evaluation/models/add_evaluation_remarks_input.dart';
import 'package:lges_teacher_app/module/evaluation/models/evaluation_areas_response.dart';
import 'package:lges_teacher_app/module/evaluation/models/evaluation_remarks_response.dart';
import 'package:lges_teacher_app/module/evaluation/models/student_evaluation_areas_response.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../models/add_evaluation_input.dart';
import '../models/add_evaluation_remarks_response.dart';
import '../models/add_evaluation_response.dart';
import '../models/student_evaluation_areas_input.dart';

class EvaluationRepository {
  final NetworkService _networkService = sl<NetworkService>();

  Future<EvaluationRemarksResponse> getEvaluationRemarks() async {
    try {
      var response = await _networkService.get(
        Endpoints.getEvaluationRemarksList,
      );
      EvaluationRemarksResponse evaluationRemarksList =
          await compute(evaluationRemarksListFromJson, response);
      return evaluationRemarksList;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<StudentEvaluationAreasResponse> getEvaluationAreas(StudentEvaluationAreasInput studentEvaluationAreasInput) async {
    try {
      var response = await _networkService.get(
        Endpoints.getStudentEvaluationAreas,
        data: studentEvaluationAreasInput.toJson()
      );
      StudentEvaluationAreasResponse studentEvaluationAreasResponse =
          await compute(studentEvaluationAreasResponseFromJson, response);
      return studentEvaluationAreasResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> addEvaluationRemarks(AddEvaluationRemarksInput addEvaluationRemarksInput) async {
    try {
      var response = await _networkService.post(
        Endpoints.addEvaluationRemarks,
        data: addEvaluationRemarksInput.toJson()
      );
      BaseResponseModel baseResponseModel =
      await compute(baseResponseModelFromJson, response);
      return baseResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> addEvaluationLogBook(AddEvaluationInput addEvaluationInput) async {
    try {
      var response = await _networkService.post(
        Endpoints.addEvaluationLogBook,
        data: addEvaluationInput.toJson()
      );
      BaseResponseModel baseResponseModel =
          await compute(baseResponseModelFromJson, response);
      return baseResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
