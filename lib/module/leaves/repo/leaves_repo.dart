import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../constants/api_endpoints.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/network_service/network_service.dart';
import '../../auth/repo/auth_repository.dart';
import '../../base_resposne_model.dart';
import '../model/add_update_leave_input.dart';
import '../model/employee_leaves_response.dart';
import '../model/leave_balance_response.dart';

class LeavesRepository {
  final NetworkService _networkService = sl<NetworkService>();
  final AuthRepository _authRepository = sl<AuthRepository>();

  Future<LeaveBalanceResponse> getEmployeeLeaveBalance() async {
    try {
      var response = await _networkService.get(
        Endpoints.getEmployeeLeaveBalance,
        data: {"EmpId": _authRepository.user.userId, "Option": 0},
      );
      LeaveBalanceResponse leaveBalanceResponse = await compute(
        leaveBalanceResponseFromJson,
        response,
      );
      return leaveBalanceResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<EmployeeLeavesResponse> getGetEmployeeLeaves({
    required int offSet,
    required int next,
  }) async {
    try {
      var response = await _networkService.get(
        Endpoints.getEmployeeLeavesByEmpId,
        data: {
          "EmpId": _authRepository.user.userId,
          "OffSet": offSet,
          "Next": next,
        },
      );
      EmployeeLeavesResponse employeeLeavesResponse =
          await EmployeeLeavesResponse.fromJson(response);
      return employeeLeavesResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel?> addUpdateEmployeeLeave(
    AddUpdateLeaveInput input,
  ) async {
    try {
      FormData toFormData() => FormData.fromMap({
        "LeaveData": jsonEncode(input).toString(),
        "EmployeeFile": input.file,
      });
      var response = await _networkService.post(
        Endpoints.uploadLeave,
        data: toFormData(),
      );
      print('############ Api Hit Response is --> ${jsonEncode(input)}');
      if (response["result"] == "error") {
        print("Api Hit Response is --> ${response["result"]}");
      }
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

  // Future<BaseResponseModel> addUpdateEmployeeLeave(
  //     {required AddUpdateLeaveInput input}) async {
  //   try {
  //     var response = await _networkService.post(
  //       Endpoints.insertEmployeeLeave,
  //       data: input.toJson(),
  //     );
  //     BaseResponseModel baseResponseModel =
  //         await compute(baseResponseModelFromJson, response);
  //     return baseResponseModel;
  //   } on BaseFailure catch (_) {
  //     rethrow;
  //   } on TypeError catch (e) {
  //     log('TYPE error stackTrace :: ${e.stackTrace}');
  //     rethrow;
  //   }
  // }

  Future<BaseResponseModel> deleteLeave({required int id}) async {
    try {
      var response = await _networkService.delete(
        Endpoints.deleteLeave,
        data: {"ID": id},
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
