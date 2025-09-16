import 'dart:convert';

AttendanceResponseModel attendanceResponseModelFromJson(dynamic json) => AttendanceResponseModel.fromJson(json);

String attendanceResponseModelToJson(AttendanceResponseModel data) => json.encode(data.toJson());

class AttendanceResponseModel {
  String result;
  String message;
  List<AttendanceModel> data;

  AttendanceResponseModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) => AttendanceResponseModel(
    result: json["result"],
    message: json["message"],
    data: List<AttendanceModel>.from(json["data"].map((x) => AttendanceModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AttendanceModel {
  int attendanceId;
  int studentId;
  String rollNumber;
  String studentName;
  String fatherName;
  int attendanceStatusIdFk;
  String? convertedPicture;

  AttendanceModel({
    required this.attendanceId,
    required this.studentId,
    required this.rollNumber,
    required this.studentName,
    required this.fatherName,
    required this.attendanceStatusIdFk,
    required this.convertedPicture,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    attendanceId: json["AttendanceId"],
    studentId: json["StudentId"],
    rollNumber: json["RollNumber"] ?? "",
    studentName: json["StudentName"],
    fatherName: json["FatherName"],
    attendanceStatusIdFk: json["AttendanceStatusIdFk"],
    convertedPicture: json["ConvertedPicture"],
  );

  Map<String, dynamic> toJson() => {
    "AttendanceId": attendanceId,
    "StudentId": studentId,
    "RollNumber": rollNumber,
    "StudentName": studentName,
    "FatherName": fatherName,
    "AttendanceStatusIdFk": attendanceStatusIdFk,
    "ConvertedPicture": convertedPicture,
  };
}
