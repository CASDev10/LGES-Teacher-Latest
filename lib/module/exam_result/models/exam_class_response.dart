// To parse this JSON data, do
//
//     final getExamClassReponse = getExamClassReponseFromJson(jsonString);

import 'dart:convert';

ExamClassResponse examClassResponseFromJson(dynamic json) => ExamClassResponse.fromJson(json);

String examClassResponseToJson(ExamClassResponse data) => json.encode(data.toJson());

class ExamClassResponse {
  String result;
  String message;
  List<ExamClassModel> data;

  ExamClassResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ExamClassResponse.fromJson(Map<String, dynamic> json) => ExamClassResponse(
    result: json["result"],
    message: json["message"],
    data: List<ExamClassModel>.from(json["data"].map((x) => ExamClassModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ExamClassModel {
  int classId;
  String className;

  ExamClassModel({
    required this.classId,
    required this.className,
  });

  factory ExamClassModel.fromJson(Map<String, dynamic> json) => ExamClassModel(
    classId: json["ClassId"],
    className: json["ClassName"],
  );

  Map<String, dynamic> toJson() => {
    "ClassId": classId,
    "ClassName": className,
  };
}
