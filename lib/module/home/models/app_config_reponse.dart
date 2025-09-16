// To parse this JSON data, do
//
//     final mobileAppConfigReponse = mobileAppConfigReponseFromJson(jsonString);

import 'dart:convert';

MobileAppConfigResponse mobileAppConfigResponseFromJson(dynamic json) => MobileAppConfigResponse.fromJson(json);

String mobileAppConfigResponseToJson(MobileAppConfigResponse data) => json.encode(data.toJson());

class MobileAppConfigResponse {
  String result;
  String message;
  AppConfigModel data;

  MobileAppConfigResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory MobileAppConfigResponse.fromJson(Map<String, dynamic> json) => MobileAppConfigResponse(
    result: json["result"],
    message: json["message"],
    data: AppConfigModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class AppConfigModel {
  List<AttendanceTime> attendanceTime;
  List<AllPrivilege> allPrivilege;

  AppConfigModel({
    required this.attendanceTime,
    required this.allPrivilege,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
    attendanceTime: List<AttendanceTime>.from(json["AttendanceTime"].map((x) => AttendanceTime.fromJson(x))),
    allPrivilege: List<AllPrivilege>.from(json["AllPrivilege"].map((x) => AllPrivilege.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AttendanceTime": List<dynamic>.from(attendanceTime.map((x) => x.toJson())),
    "AllPrivilege": List<dynamic>.from(allPrivilege.map((x) => x.toJson())),
  };
  static  AppConfigModel empty = AppConfigModel(attendanceTime: [], allPrivilege: []);
}

class AllPrivilege {
  int privilegeId;
  String description;

  AllPrivilege({
    required this.privilegeId,
    required this.description,
  });

  factory AllPrivilege.fromJson(Map<String, dynamic> json) => AllPrivilege(
    privilegeId: json["PrivilegeId"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "PrivilegeId": privilegeId,
    "Description": description,
  };
}

class AttendanceTime {
  String attendanceStartTime;
  String attendanceEndTime;

  AttendanceTime({
    required this.attendanceStartTime,
    required this.attendanceEndTime,
  });

  factory AttendanceTime.fromJson(Map<String, dynamic> json) => AttendanceTime(
    attendanceStartTime: json["AttendanceStartTime"],
    attendanceEndTime: json["AttendanceEndTime"],
  );

  Map<String, dynamic> toJson() => {
    "AttendanceStartTime": attendanceStartTime,
    "AttendanceEndTime": attendanceEndTime,
  };


}
