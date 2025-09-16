// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

List<StudentModel> studentModelFromJson(dynamic json) => List<StudentModel>.from(json.map((x) => StudentModel.fromJson(x)));

String studentModelToJson(List<StudentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

StudentModel studentFromJson(dynamic json) => StudentModel.fromJson(json);

String studentToJson(StudentModel data) => json.encode(data.toJson());


class StudentModel {
  String studentId;
  String fileNo;
  String studentName;
  String biology;
  String chemistry;
  String englishLanguage;
  String islamiyat;
  String mathematics;
  String pakistanStudies;
  String physics;
  String urdu;
  String obtainedMarks;
  String maxMarks;
  String percentage;

  StudentModel({
    required this.studentId,
    required this.fileNo,
    required this.studentName,
    required this.biology,
    required this.chemistry,
    required this.englishLanguage,
    required this.islamiyat,
    required this.mathematics,
    required this.pakistanStudies,
    required this.physics,
    required this.urdu,
    required this.obtainedMarks,
    required this.maxMarks,
    required this.percentage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    studentId: json["StudentId"],
    fileNo: json["FileNo"],
    studentName: json["StudentName"],
    biology: json["Biology"],
    chemistry: json["Chemistry"],
    englishLanguage: json["English Language"],
    islamiyat: json["Islamiyat"],
    mathematics: json["Mathematics"],
    pakistanStudies: json["Pakistan Studies"],
    physics: json["Physics"],
    urdu: json["Urdu"],
    obtainedMarks: json["ObtainedMarks"],
    maxMarks: json["MaxMarks"],
    percentage: json["Percentage"],
  );

  Map<String, dynamic> toJson() => {
    "StudentId": studentId,
    "FileNo": fileNo,
    "StudentName": studentName,
    "Biology": biology,
    "Chemistry": chemistry,
    "English Language": englishLanguage,
    "Islamiyat": islamiyat,
    "Mathematics": mathematics,
    "Pakistan Studies": pakistanStudies,
    "Physics": physics,
    "Urdu": urdu,
    "ObtainedMarks": obtainedMarks,
    "MaxMarks": maxMarks,
    "Percentage": percentage,
  };
}
