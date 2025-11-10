// To parse this JSON data, do
//
//     final employeeLeavesResponse = employeeLeavesResponseFromJson(jsonString);

import 'dart:convert';

EmployeeLeavesResponse employeeLeavesResponseFromJson(String str) =>
    EmployeeLeavesResponse.fromJson(json.decode(str));

String employeeLeavesResponseToJson(EmployeeLeavesResponse data) =>
    json.encode(data.toJson());

class EmployeeLeavesResponse {
  String result;
  String message;
  List<EmployeeLeaveModel> data;

  EmployeeLeavesResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory EmployeeLeavesResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeLeavesResponse(
        result: json["result"],
        message: json["message"],
        data: List<EmployeeLeaveModel>.from(
          json["data"].map((x) => EmployeeLeaveModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeLeaveModel {
  int id;
  int empId;
  DateTime fromDate;
  String fromDateString;
  DateTime toDate;
  String toDateString;
  String reason;
  int days;
  int entityLeaveTypeId;
  String entityLeaveType;
  bool isDeleted;
  int createdBy;
  DateTime createdDate;
  String createdDateString;
  dynamic employeeName;
  dynamic departmentName;
  dynamic desginationName;
  bool approved;
  dynamic shift;
  int waitingForApproval;
  int offSet;
  int next;
  int leaveStatus;
  String leaveStatusString;
  String fileDownloadLink;
  dynamic ucUser;
  int ucLoginUserId;
  dynamic ucUserFullName;
  int ucEntityId;
  int ucSchoolId;
  int ucPrivilegeId;
  int ucIsAllowed;
  int ucMessageId;
  dynamic ucMessage;
  dynamic ucCompanyName;
  dynamic ucDbConnectionString;
  bool ucIsAdminUser;

  EmployeeLeaveModel({
    required this.id,
    required this.empId,
    required this.fromDate,
    required this.fromDateString,
    required this.toDate,
    required this.toDateString,
    required this.reason,
    required this.days,
    required this.entityLeaveTypeId,
    required this.entityLeaveType,
    required this.isDeleted,
    required this.createdBy,
    required this.createdDate,
    required this.createdDateString,
    required this.employeeName,
    required this.departmentName,
    required this.desginationName,
    required this.approved,
    required this.shift,
    required this.waitingForApproval,
    required this.offSet,
    required this.next,
    required this.leaveStatus,
    required this.leaveStatusString,
    required this.fileDownloadLink,
    required this.ucUser,
    required this.ucLoginUserId,
    required this.ucUserFullName,
    required this.ucEntityId,
    required this.ucSchoolId,
    required this.ucPrivilegeId,
    required this.ucIsAllowed,
    required this.ucMessageId,
    required this.ucMessage,
    required this.ucCompanyName,
    required this.ucDbConnectionString,
    required this.ucIsAdminUser,
  });

  factory EmployeeLeaveModel.fromJson(Map<String, dynamic> json) =>
      EmployeeLeaveModel(
        id: json["ID"],
        empId: json["EmpId"],
        fromDate: DateTime.parse(json["FromDate"]),
        fromDateString: json["FromDateString"],
        toDate: DateTime.parse(json["ToDate"]),
        toDateString: json["ToDateString"],
        reason: json["Reason"],
        days: json["Days"],
        entityLeaveTypeId: json["EntityLeaveTypeId"],
        entityLeaveType: json["EntityLeaveType"],
        isDeleted: json["IsDeleted"],
        createdBy: json["CreatedBy"],
        createdDate: DateTime.parse(json["CreatedDate"]),
        createdDateString: json["CreatedDateString"],
        employeeName: json["EmployeeName"],
        departmentName: json["DepartmentName"],
        desginationName: json["DesginationName"],
        approved: json["Approved"],
        shift: json["Shift"],
        waitingForApproval: json["WaitingForApproval"],
        offSet: json["OffSet"] ?? 0,
        next: json["Next"] ?? 0,
        leaveStatus: json["LeaveStatus"] ?? 0,
        leaveStatusString: json["LeaveStatusString"],
        fileDownloadLink: json["FileDownloadLink"],
        ucUser: json["UC_User"],
        ucLoginUserId: json["UC_LoginUserId"],
        ucUserFullName: json["UC_UserFullName"],
        ucEntityId: json["UC_EntityId"],
        ucSchoolId: json["UC_SchoolId"],
        ucPrivilegeId: json["UC_PrivilegeId"],
        ucIsAllowed: json["UC_isAllowed"],
        ucMessageId: json["UC_MessageId"],
        ucMessage: json["UC_Message"],
        ucCompanyName: json["UC_CompanyName"],
        ucDbConnectionString: json["UC_DBConnectionString"],
        ucIsAdminUser: json["UC_isAdminUser"],
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "EmpId": empId,
    "FromDate": fromDate.toIso8601String(),
    "FromDateString": fromDateString,
    "ToDate": toDate.toIso8601String(),
    "ToDateString": toDateString,
    "Reason": reason,
    "Days": days,
    "EntityLeaveTypeId": entityLeaveTypeId,
    "EntityLeaveType": entityLeaveType,
    "IsDeleted": isDeleted,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "CreatedDateString": createdDateString,
    "EmployeeName": employeeName,
    "DepartmentName": departmentName,
    "DesginationName": desginationName,
    "Approved": approved,
    "Shift": shift,
    "WaitingForApproval": waitingForApproval,
    "OffSet": offSet,
    "Next": next,
    "LeaveStatus": leaveStatus,
    "LeaveStatusString": leaveStatusString,
    "FileDownloadLink": fileDownloadLink,
    "UC_User": ucUser,
    "UC_LoginUserId": ucLoginUserId,
    "UC_UserFullName": ucUserFullName,
    "UC_EntityId": ucEntityId,
    "UC_SchoolId": ucSchoolId,
    "UC_PrivilegeId": ucPrivilegeId,
    "UC_isAllowed": ucIsAllowed,
    "UC_MessageId": ucMessageId,
    "UC_Message": ucMessage,
    "UC_CompanyName": ucCompanyName,
    "UC_DBConnectionString": ucDbConnectionString,
    "UC_isAdminUser": ucIsAdminUser,
  };
}
