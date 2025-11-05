import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/home/models/app_config_reponse.dart';

import '../../../constants/api_endpoints.dart';
import '../../../constants/keys.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/base_failures/base_failure.dart';
import '../../../core/network_service/network_service.dart';
import '../../../core/storage_service/storage_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../../base_resposne_model.dart';
import '../../file_sharing/models/file_sharing_input.dart';

class HomeRepository {
  final NetworkService _networkService = sl<NetworkService>();
  final StorageService _storageService = sl<StorageService>();

  AuthRepository _authRepository = sl<AuthRepository>();
  AppConfigModel appConfigModel = AppConfigModel.empty;

  Future<MobileAppConfigResponse> getAppConfig() async {
    try {
      Map<String, dynamic> input = {
        "UC_SchoolId": _authRepository.user.schoolId,
      };
      var response = await _networkService.get(
        Endpoints.getMobileAppConfig,
        data: input,
      );

      MobileAppConfigResponse mobileAppConfigResponse = await compute(
        mobileAppConfigResponseFromJson,
        response,
      );
      saveAppConfigModel(mobileAppConfigResponse.data);
      return mobileAppConfigResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<void> saveAppConfigModel(AppConfigModel appConfigModel) async {
    this.appConfigModel = appConfigModel;
    final appConfigModelJson = appConfigModel.toJson();
    await _storageService.setString(
      StorageKeys.appConfig,
      json.encode(appConfigModelJson),
    );
  }

  Future<void> getAppConfigModel() async {
    final appConfigString = _storageService.getString(StorageKeys.appConfig);
    if (appConfigString.isEmpty) {
      return;
    }
    final Map<String, dynamic> appConfigMap = jsonDecode(appConfigString);
    AppConfigModel appConfigModel = AppConfigModel.fromJson(appConfigMap);
    this.appConfigModel = appConfigModel;
  }

  Future<BaseResponseModel> uploadTeacherFile(FileSharingInput input) async {
    try {
      Map<String, dynamic> description = {
        "UC_LoginUserId": _authRepository.user.userId,
        "UC_EntityId": _authRepository.user.entityId,
        "UC_SchoolId": _authRepository.user.schoolId,
        "ClassIdFk": input.classId,
        "SectionIdFk": input.sectionId,
      };
      FormData toFormData() => FormData.fromMap({
        "Description": jsonEncode(description),
        "TeacherFile": input.file,
      });
      var response = await _networkService.post(
        Endpoints.uploadTeacherFile,
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
}
