import 'dart:convert';

LeaveBalanceResponse leaveBalanceResponseFromJson(String str) =>
    LeaveBalanceResponse.fromJson(json.decode(str));

String leaveBalanceResponseToJson(LeaveBalanceResponse data) =>
    json.encode(data.toJson());

class LeaveBalanceResponse {
  String result;
  String message;
  int messageCode;
  List<LeaveBalanceList> data;

  LeaveBalanceResponse({
    required this.result,
    required this.message,
    required this.messageCode,
    required this.data,
  });

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceResponse(
        result: json["Result"],
        message: json["Message"],
        messageCode: json["MessageCode"],
        data: List<LeaveBalanceList>.from(
            json["Data"].map((x) => LeaveBalanceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Result": result,
        "Message": message,
        "MessageCode": messageCode,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LeaveBalanceList {
  int empLeaveBalanceId;
  int leaveTypeId;
  int empId;
  int balance;
  int allowLeavePerMonth;
  String leaveTypeName;
  String validFromDate;
  String validToDate;
  int canTakeLeave;
  int isValidLeaveBalance;
  int isCalenderExists;

  LeaveBalanceList({
    required this.empLeaveBalanceId,
    required this.leaveTypeId,
    required this.empId,
    required this.balance,
    required this.allowLeavePerMonth,
    required this.leaveTypeName,
    required this.validFromDate,
    required this.validToDate,
    required this.canTakeLeave,
    required this.isValidLeaveBalance,
    required this.isCalenderExists,
  });

  factory LeaveBalanceList.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceList(
        empLeaveBalanceId: json["EmpLeaveBalanceID"],
        leaveTypeId: json["LeaveTypeId"],
        empId: json["EmpId"],
        balance: json["Balance"],
        allowLeavePerMonth: json["AllowLeavePerMonth"],
        leaveTypeName: json["LeaveTypeName"],
        validFromDate: json["ValidFromDate"],
        validToDate: json["ValidToDate"],
        canTakeLeave: json["CanTakeLeave"],
        isValidLeaveBalance: json["IsValidLeaveBalance"],
        isCalenderExists: json["IsCalenderExists"],
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
        "CanTakeLeave": canTakeLeave,
        "IsValidLeaveBalance": isValidLeaveBalance,
        "IsCalenderExists": isCalenderExists,
      };
}
