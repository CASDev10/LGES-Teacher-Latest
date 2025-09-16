// To parse this JSON data, do
//
//     final evaluationRemarksList = evaluationRemarksListFromJson(jsonString);

import 'dart:convert';

EvaluationRemarksResponse evaluationRemarksListFromJson(dynamic json) => EvaluationRemarksResponse.fromJson(json);

String evaluationRemarksListToJson(EvaluationRemarksResponse data) => json.encode(data.toJson());

class EvaluationRemarksResponse {
  String result;
  String message;
  List<EvaluationRemarksModel> data;

  EvaluationRemarksResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory EvaluationRemarksResponse.fromJson(Map<String, dynamic> json) => EvaluationRemarksResponse(
    result: json["result"],
    message: json["message"],
    data: List<EvaluationRemarksModel>.from(json["data"].map((x) => EvaluationRemarksModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EvaluationRemarksModel {
  int evaluationRemarksId;
  String evaluationRemarks;
  int evaluationAreaId;
  String evaluationArea;
  bool isDeleted;

  EvaluationRemarksModel({
    required this.evaluationRemarksId,
    required this.evaluationRemarks,
    required this.evaluationAreaId,
    required this.evaluationArea,
    required this.isDeleted,
  });

  factory EvaluationRemarksModel.fromJson(Map<String, dynamic> json) => EvaluationRemarksModel(
    evaluationRemarksId: json["EvaluationRemarksID"],
    evaluationRemarks: json["EvaluationRemarks"],
    evaluationAreaId: json["EvaluationAreaId"],
    evaluationArea: json["EvaluationArea"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "EvaluationRemarksID": evaluationRemarksId,
    "EvaluationRemarks": evaluationRemarks,
    "EvaluationAreaId": evaluationAreaId,
    "EvaluationArea": evaluationArea,
    "isDeleted": isDeleted,
  };
}
