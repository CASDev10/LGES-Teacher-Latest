// To parse this JSON data, do
//
//     final employeeDetailResponse = employeeDetailResponseFromJson(jsonString);

import 'dart:convert';

EmployeeDetailResponse employeeDetailResponseFromJson(dynamic json) => EmployeeDetailResponse.fromJson(json);

String employeeDetailResponseToJson(EmployeeDetailResponse data) => json.encode(data.toJson());

class EmployeeDetailResponse {
  String result;
  String message;
  List<EmployeeModel> data;

  EmployeeDetailResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory EmployeeDetailResponse.fromJson(Map<String, dynamic> json) => EmployeeDetailResponse(
    result: json["result"],
    message: json["message"],
    data: List<EmployeeModel>.from(json["data"].map((x) => EmployeeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EmployeeModel {
  int empId;
  String empName;
  String empCode;
  String jobStatus;
  String department;

  EmployeeModel({
    required this.empId,
    required this.empName,
    required this.empCode,
    required this.jobStatus,
    required this.department,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    empId: json["EmpId"],
    empName: json["EmpName"],
    empCode: json["EmpCode"],
    jobStatus: json["JobStatus"],
    department: json["Department"],
  );

  Map<String, dynamic> toJson() => {
    "EmpId": empId,
    "EmpName": empName,
    "EmpCode": empCode,
    "JobStatus": jobStatus,
    "Department": department,
  };
}
