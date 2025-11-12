import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_input.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_response.dart';
import 'package:lges_teacher_app/module/daily_diary/models/diary_list_response.dart';
import 'package:lges_teacher_app/module/daily_diary/models/subjects_response.dart';

import '../../../constants/api_endpoints.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../models/update_diary_input.dart';
import '../pages/delete_diary_input.dart';

class DiaryRepository {
  final NetworkService _networkService = sl<NetworkService>();
  AuthRepository _authRepository = sl<AuthRepository>();

  Future<DiaryListResponseModel> getDiaryList(
    String fromDate,
    String toDate,
  ) async {
    try {
      Map<String, dynamic> input = {
        "UC_SchoolId": _authRepository.user.schoolId,
        "UC_LoginUserId": _authRepository.user.userId,
        "DateFrom": fromDate,
        "DateTo": toDate,
      };

      var response = await _networkService.get(
        Endpoints.getDiaryList,
        data: input,
      );
      DiaryListResponseModel diaryListResponseModel = await compute(
        diaryListResponseModelFromJson,
        response,
      );
      return diaryListResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<AddDiaryResponseModel> addDiary(AddDiaryInput input) async {
    try {
      FormData formData = FormData.fromMap({
        "Description": jsonEncode(input.toJson()),
        "TeacherFile": input.file,
      });
      var response = await _networkService.post(
        Endpoints.addDiary,
        data: formData,
      );
      AddDiaryResponseModel responseModel = await compute(
        addDiaryResponseModelFromJson,
        response,
      );
      return responseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<AddDiaryResponseModel> updateDiary(UpdateDiaryInput input) async {
    try {
      FormData formData = FormData.fromMap({
        "Description": jsonEncode(input.toJson()),
        "TeacherFile": input.file,
      });
      var response = await _networkService.post(
        Endpoints.updateDiary,
        data: formData,
      );
      AddDiaryResponseModel responseModel = await compute(
        addDiaryResponseModelFromJson,
        response,
      );
      return responseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<AddDiaryResponseModel> deleteDiary(DeleteDiaryInput input) async {
    try {
      var response = await _networkService.post(
        Endpoints.deleteDiary,
        data: input.toJson(),
      );
      AddDiaryResponseModel responseModel = await compute(
        addDiaryResponseModelFromJson,
        response,
      );
      return responseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<SubjectsResponseModel> getClassSubjects(String classId) async {
    try {
      Map<String, dynamic> input = {
        "UC_EntityId": _authRepository.user.entityId,
        "UC_SchoolId": _authRepository.user.schoolId,
        "ClassIdFk": classId,
      };
      var response = await _networkService.get(
        Endpoints.getSubjectOfClass,
        data: input,
      );
      SubjectsResponseModel responseModel = await compute(
        subjectsResponseModelFromJson,
        response,
      );
      return responseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }
}
