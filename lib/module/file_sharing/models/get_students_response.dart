// To parse this JSON data, do
//
//     final getStudentsResponse = getStudentsResponseFromJson(jsonString);

import 'dart:convert';

GetStudentsResponse getStudentsResponseFromJson(dynamic json) =>
    GetStudentsResponse.fromJson(json);

String getStudentsResponseToJson(GetStudentsResponse data) =>
    json.encode(data.toJson());

class GetStudentsResponse {
  String result;
  String message;
  List<NotificationStudentModel> data;

  GetStudentsResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory GetStudentsResponse.fromJson(Map<String, dynamic> json) =>
      GetStudentsResponse(
        result: json["result"],
        message: json["message"],
        data: List<NotificationStudentModel>.from(
          json["data"].map((x) => NotificationStudentModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationStudentModel {
  int studentId;
  String? admissionNumber;
  String studentName;
  String fatherName;
  String className;
  String sectionName;
  String createdBy;
  String schoolName;
  String enrollStatus;
  String enrollStatus1;

  NotificationStudentModel({
    required this.studentId,
    required this.admissionNumber,
    required this.studentName,
    required this.fatherName,
    required this.className,
    required this.sectionName,
    required this.createdBy,
    required this.schoolName,
    required this.enrollStatus,
    required this.enrollStatus1,
  });

  factory NotificationStudentModel.fromJson(Map<String, dynamic> json) =>
      NotificationStudentModel(
        studentId: json["StudentId"],
        admissionNumber: json["AdmissionNumber"],
        studentName: json["StudentName"],
        fatherName: json["FatherName"],
        className: json["ClassName"] ?? '',
        sectionName: json["SectionName"],
        createdBy: json["CreatedBy"],
        schoolName: json["SchoolName"],
        enrollStatus: json["EnrollStatus"],
        enrollStatus1: json["EnrollStatus1"]!,
      );

  Map<String, dynamic> toJson() => {
    "StudentId": studentId,
    "AdmissionNumber": admissionNumber,
    "StudentName": studentName,
    "FatherName": fatherName,
    "ClassName": className,
    "SectionName": sectionName,
    "CreatedBy": createdBy,
    "SchoolName": schoolName,
    "EnrollStatus": enrollStatus,
    "EnrollStatus1": enrollStatus1,
  };
}
