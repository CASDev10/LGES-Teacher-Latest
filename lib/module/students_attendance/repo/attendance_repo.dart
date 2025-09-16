import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lges_teacher_app/constants/api_endpoints.dart';
import 'package:lges_teacher_app/core/di/service_locator.dart';
import 'package:lges_teacher_app/core/failures/base_failures/base_failure.dart';
import 'package:lges_teacher_app/core/network_service/network_service.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_reponse.dart';
import 'package:lges_teacher_app/module/students_attendance/models/submit_attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/submit_attendance_reponse.dart';

import '../../base_resposne_model.dart';

class AttendanceRepository {
  final NetworkService _networkService = sl<NetworkService>();

  Future<AttendanceResponseModel> getGetSectionStudentList(AttendanceInput input) async {
    try {
      var response = await _networkService.get(
        Endpoints.getGetSectionStudentList,
        data: input.toJson(),
      );
      AttendanceResponseModel attendanceResponseModel =
          await compute(attendanceResponseModelFromJson, response);
      return attendanceResponseModel;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<BaseResponseModel> submitAttendance(SubmitAttendanceInput input) async {
    try {
      var response = await _networkService.post(
        Endpoints.addSchoolAttendance,
        data: input.toJson(),
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
