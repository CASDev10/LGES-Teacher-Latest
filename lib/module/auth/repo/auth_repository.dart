import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/module/auth/models/forget_password_input.dart';
import 'package:lges_teacher_app/module/auth/models/forget_password_response.dart';

import '../../../constants/api_endpoints.dart';
import '../../../constants/keys.dart';
import '../../../core/api_result.dart';
import '../../../core/core.dart';
import '../../base_resposne_model.dart';
import '../models/auth_response.dart';
import '../models/login_input.dart';

class AuthRepository {
  final NetworkService _networkService;
  final StorageService _storageService;

  User user = User.empty;

  AuthRepository(this._networkService, this._storageService);

  Future<AuthResponse> login(
      LoginInput loginInput, bool isKeepMeLoggedIn) async {
    try {
      var response = await _networkService.post(
        Endpoints.login,
        data: loginInput.toJson(),
      );
      AuthResponse authResponse = AuthResponse.fromJson(response);
      if (authResponse.result == ApiResult.success) {
        //_saveToken(authResponse.user.token);
        saveUser(authResponse.user);
        setKeepMeLoggedIn(isKeepMeLoggedIn);
      }
      return authResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> forgetPassword(
    ForgetPasswordInput forgetPasswordInput,
  ) async {
    try {
      var response = await _networkService.post(
        Endpoints.forgetPassword,
        data: forgetPasswordInput.toJson(),
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

  // token
  Future<void> _saveToken(String token) async {
    await _storageService.setString(StorageKeys.token, token);
  }

  Future<void> setKeepMeLoggedIn(bool isKeepMeLoggedIn) async {
    await _storageService.setBool(
        StorageKeys.isKeepMeLoggedIn, isKeepMeLoggedIn);
  }

  String _getToken() {
    return _storageService.getString(StorageKeys.token);
  }

  bool isKeepMeLoggedIn() {
    return _storageService.getBool(StorageKeys.isKeepMeLoggedIn);
  }

  Future<void> _removeToken() async {
    await _storageService.remove(StorageKeys.token);
  }

  Future<void> _keepMeLoggedIn() async {
    await _storageService.remove(StorageKeys.isKeepMeLoggedIn);
  }

  // user
  Future<void> saveUser(User user) async {
    this.user = user;
    final userMap = user.toJson();
    await _storageService.setString(StorageKeys.user, json.encode(userMap));
  }

  Future<void> _removeUser() async {
    await _storageService.remove(StorageKeys.user);
  }

  Future<void> getUser() async {
    final userString = _storageService.getString(StorageKeys.user);
    if (userString.isEmpty) {
      return;
    }
    final Map<String, dynamic> userMap = jsonDecode(userString);
    User user = User.fromJson(userMap);
    this.user = user;
  }

  Map<String, dynamic>? getHeaders() {
    //live
    String username = 'LgesApiExtPass';
    String password = '7A527#APIAB#@LlmX#1@LGES\$WEB';

    //test
    // String username = 'LgesApiExtPass';
    // String password = 'lgeswebtest@cyberasol';

    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    return {
      'Accept': 'application/json',
      'Authorization': basicAuth,
    };
  }

  Future<bool> isAuthenticated() async {
    await getUser();
    return (isKeepMeLoggedIn() && user.schoolId != null);
  }

  Future<void> logout() async {
    await _removeUser();
    await _removeToken();
    await _keepMeLoggedIn();
    user = User.empty;
  }
}
