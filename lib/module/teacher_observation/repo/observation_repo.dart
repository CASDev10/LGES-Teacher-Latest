import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/employee_detail_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_areas_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_levels_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_remarks_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_report_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/submit_observation_input.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../../base_resposne_model.dart';

class ObservationRepository {
  final NetworkService _networkService = sl<NetworkService>();
  AuthRepository _authRepository = sl<AuthRepository>();

  Future<BaseResponseModel> addObservationLevel(String level) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "Level": level
      };
      var response = await _networkService.post(
        Endpoints.addObservationLevel,
        data: input,
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

  Future<BaseResponseModel> updateObservationLevel(
      String level, String levelId) async {
    try {
      Map<String, dynamic> input = {
        "LevelId": levelId,
        "UC_LoginUserId": _authRepository.user.userId,
        "Level": level
      };
      var response = await _networkService.post(
        Endpoints.updateObservationLevel,
        data: input,
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

  Future<BaseResponseModel> deleteObservationLevel(String levelId) async {
    try {
      Map<String, dynamic> input = {
        "LevelId": levelId,
        "UC_LoginUserId": _authRepository.user.userId
      };
      var response = await _networkService.post(
        Endpoints.deleteObservationLevel,
        data: input,
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

  Future<ObservationLevelsResponse> getObservationLevels() async {
    try {
      var response = await _networkService.get(
        Endpoints.getObservationLevelList,
      );

      ObservationLevelsResponse observationLevelsResponse =
          await compute(observationLevelsResponseFromJson, response);
      return observationLevelsResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<ObservationAreasResponse> getObservationAreas() async {
    try {
      var response = await _networkService.get(
        Endpoints.getObservationAreas,
      );

      ObservationAreasResponse observationAreasResponse =
          await compute(observationAreasResponseFromJson, response);
      return observationAreasResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<ObservationRemarksResponse> getObservationRemarks() async {
    try {
      var response = await _networkService.get(
        Endpoints.getObservationAreaRemarksList,
      );

      ObservationRemarksResponse observationRemarksResponse =
          await compute(observationRemarksResponseFromJson, response);
      return observationRemarksResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> addObservationRemarks(
      String remarks, String areaId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "AreaId": areaId,
        "Remarks": remarks
      };
      var response = await _networkService.post(
        Endpoints.addObservationAreaRemarks,
        data: input,
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

  Future<BaseResponseModel> deleteObservationRemarks(String remarksId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "RemarksId": remarksId,
      };
      var response = await _networkService.post(
        Endpoints.deleteObservationAreaRemarks,
        data: input,
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

  Future<BaseResponseModel> updateObservationRemarks(
      String remarksId, String remarks, String areaId) async {
    try {
      Map<String, dynamic> input = {
        "UC_LoginUserId": _authRepository.user.userId,
        "RemarksId": remarksId,
        "Remarks": remarks,
        "AreaId": areaId,
      };
      var response = await _networkService.post(
        Endpoints.updateObservationAreaRemarks,
        data: input,
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

  Future<EmployeeDetailResponse> getEmployeeDetail(String empId) async {
    try {
      Map<String, dynamic> input = {"EmpId": empId};
      var response =
          await _networkService.get(Endpoints.getEmployeeById, data: input);

      EmployeeDetailResponse employeeDetailResponse =
          await compute(employeeDetailResponseFromJson, response);
      return employeeDetailResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> submitTeacherObservation(SubmitObservationInput input) async {
    try {

      var response =
          await _networkService.post(Endpoints.saveTeacherObservation, data: input.toJson());

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

  Future<ObservationReportResponse> getObservationReport(String startDate, String endDate) async {
    try {
      Map<String, dynamic> input = {
        "UC_SchoolId": _authRepository.user.schoolId,
        "StartDate": startDate,
        "EndDate": endDate,
      };
      var response = await _networkService.get(
        Endpoints.getObservationReport,
        data: input,
      );
      ObservationReportResponse observationReportResponse =
          await compute(observationReportResponseFromJson, response);
      return observationReportResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
