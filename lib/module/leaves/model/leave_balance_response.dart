import 'dart:convert';

LeaveBalanceResponse leaveBalanceResponseFromJson(dynamic json) =>
    LeaveBalanceResponse.fromJson(json);

String leaveBalanceResponseToJson(LeaveBalanceResponse data) =>
    json.encode(data.toJson());

class LeaveBalanceResponse {
  String result;
  String message;
  List<LeaveModel> data;

  LeaveBalanceResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  LeaveBalanceResponse copyWith({
    String? result,
    String? message,
    List<LeaveModel>? data,
  }) =>
      LeaveBalanceResponse(
        result: result ?? this.result,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceResponse(
        result: json["result"],
        message: json["message"],
        data: List<LeaveModel>.from(
            json["data"].map((x) => LeaveModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LeaveModel {
  int empLeaveBalanceId;
  int leaveTypeId;
  int empId;
  int balance;
  int allowLeavePerMonth;
  String leaveTypeName;
  String validFromDate;
  String validToDate;

  LeaveModel({
    required this.empLeaveBalanceId,
    required this.leaveTypeId,
    required this.empId,
    required this.balance,
    required this.allowLeavePerMonth,
    required this.leaveTypeName,
    required this.validFromDate,
    required this.validToDate,
  });

  LeaveModel copyWith({
    int? empLeaveBalanceId,
    int? leaveTypeId,
    int? empId,
    int? balance,
    int? allowLeavePerMonth,
    String? leaveTypeName,
    String? validFromDate,
    String? validToDate,
  }) =>
      LeaveModel(
        empLeaveBalanceId: empLeaveBalanceId ?? this.empLeaveBalanceId,
        leaveTypeId: leaveTypeId ?? this.leaveTypeId,
        empId: empId ?? this.empId,
        balance: balance ?? this.balance,
        allowLeavePerMonth: allowLeavePerMonth ?? this.allowLeavePerMonth,
        leaveTypeName: leaveTypeName ?? this.leaveTypeName,
        validFromDate: validFromDate ?? this.validFromDate,
        validToDate: validToDate ?? this.validToDate,
      );

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        empLeaveBalanceId: json["EmpLeaveBalanceID"],
        leaveTypeId: json["LeaveTypeId"],
        empId: json["EmpId"],
        balance: json["Balance"],
        allowLeavePerMonth: json["AllowLeavePerMonth"],
        leaveTypeName: json["LeaveTypeName"],
        validFromDate: json["ValidFromDate"],
        validToDate: json["ValidToDate"],
      );

  Map<String, dynamic> toJson() => {
        "EmpLeaveBalanceID": empLeaveBalanceId,
        "LeaveTypeId": leaveTypeId,
        "EmpId": empId,
        "Balance": balance,
        "AllowLeavePerMonth": allowLeavePerMonth,
        "LeaveTypeName": leaveTypeName,
        "ValidFromDate": validFromDate,
        "ValidToDate": validToDate,
      };
}
