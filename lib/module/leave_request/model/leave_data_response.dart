import 'dart:convert';

import 'package:lges_teacher_app/module/leave_request/model/reliever_list.dart';

import 'leave_types_list.dart';

LeaveDataResponse leaveDataResponseFromJson(String str) =>
    LeaveDataResponse.fromJson(json.decode(str));

String leaveDataResponseToJson(LeaveDataResponse data) =>
    json.encode(data.toJson());

class LeaveDataResponse {
  String result;
  String message;
  int messageCode;
  List<dynamic> leaveDataList;
  List<EmpLeaveDataList> empLeaveDataList;
  List<LeaveTypeList> leaveTypeList;
  List<RelieverListElement> relieverList;
  List<dynamic> subejctList;

  LeaveDataResponse({
    required this.result,
    required this.message,
    required this.messageCode,
    required this.leaveDataList,
    required this.empLeaveDataList,
    required this.leaveTypeList,
    required this.relieverList,
    required this.subejctList,
  });

  factory LeaveDataResponse.fromJson(Map<String, dynamic> json) =>
      LeaveDataResponse(
        result: json["Result"],
        message: json["Message"],
        messageCode: json["MessageCode"],
        leaveDataList: List<dynamic>.from(json["LeaveDataList"].map((x) => x)),
        empLeaveDataList: List<EmpLeaveDataList>.from(
          json["EmpLeaveDataList"].map((x) => EmpLeaveDataList.fromJson(x)),
        ),
        leaveTypeList: List<LeaveTypeList>.from(
          json["LeaveTypeList"].map((x) => LeaveTypeList.fromJson(x)),
        ),
        relieverList: List<RelieverListElement>.from(
          json["RelieverList"].map((x) => RelieverListElement.fromJson(x)),
        ),
        subejctList: List<dynamic>.from(json["SubejctList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "Result": result,
    "Message": message,
    "MessageCode": messageCode,
    "LeaveDataList": List<dynamic>.from(leaveDataList.map((x) => x)),
    "EmpLeaveDataList": List<dynamic>.from(
      empLeaveDataList.map((x) => x.toJson()),
    ),
    "LeaveTypeList": List<dynamic>.from(leaveTypeList.map((x) => x.toJson())),
    "RelieverList": List<dynamic>.from(relieverList.map((x) => x.toJson())),
    "SubejctList": List<dynamic>.from(subejctList.map((x) => x)),
  };
}

class EmpLeaveDataList {
  String appliedDate;
  String status;
  int leaveBalance;
  int days;
  int entityLeaveTypeId;
  String leaveTypeName;
  int relieverId;
  String relieverName;
  String? userFileName;
  String? systemFileName;
  String fileDownloadLink;

  EmpLeaveDataList({
    required this.appliedDate,
    required this.status,
    required this.leaveBalance,
    required this.days,
    required this.entityLeaveTypeId,
    required this.leaveTypeName,
    required this.relieverId,
    required this.relieverName,
    required this.userFileName,
    required this.systemFileName,
    required this.fileDownloadLink,
  });

  factory EmpLeaveDataList.fromJson(Map<String, dynamic> json) =>
      EmpLeaveDataList(
        appliedDate: json["AppliedDate"],
        status: json["Status"],
        leaveBalance: json["LeaveBalance"],
        days: json["Days"],
        entityLeaveTypeId: json["EntityLeaveTypeId"],
        leaveTypeName: json["LeaveTypeName"],
        relieverId: json["RelieverId"],
        relieverName: json["RelieverName"],
        userFileName: json["UserFileName"],
        systemFileName: json["SystemFileName"],
        fileDownloadLink: json["FileDownloadLink"],
      );

  Map<String, dynamic> toJson() => {
    "AppliedDate": appliedDate,
    "Status": status,
    "LeaveBalance": leaveBalance,
    "Days": days,
    "EntityLeaveTypeId": entityLeaveTypeId,
    "LeaveTypeName": leaveTypeName,
    "RelieverId": relieverId,
    "RelieverName": relieverName,
    "UserFileName": userFileName,
    "SystemFileName": systemFileName,
    "FileDownloadLink": fileDownloadLink,
  };
}
