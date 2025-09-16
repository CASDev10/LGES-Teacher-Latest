// To parse this JSON data, do
//
//     final classSubjectResponseModel = classSubjectResponseModelFromJson(jsonString);

import 'dart:convert';

SubjectsResponseModel subjectsResponseModelFromJson(dynamic json) => SubjectsResponseModel.fromJson(json);

String subjectsResponseModelToJson(SubjectsResponseModel data) => json.encode(data.toJson());

class SubjectsResponseModel {
  String result;
  String message;
  List<SubjectModel> data;

  SubjectsResponseModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) => SubjectsResponseModel(
    result: json["result"],
    message: json["message"],
    data: List<SubjectModel>.from(json["data"].map((x) => SubjectModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubjectModel {
  int subjectId;
  String subjectName;

  SubjectModel({
    required this.subjectId,
    required this.subjectName,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
    subjectId: json["SubjectId"],
    subjectName: json["SubjectName"],
  );

  Map<String, dynamic> toJson() => {
    "SubjectId": subjectId,
    "SubjectName": subjectName,
  };
}
