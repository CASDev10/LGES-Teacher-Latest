// To parse this JSON data, do
//
//     final evaluationAreasResponse = evaluationAreasResponseFromJson(jsonString);

import 'dart:convert';

EvaluationAreasResponse evaluationAreasResponseFromJson(dynamic json) => EvaluationAreasResponse.fromJson(json);

String evaluationAreasResponseToJson(EvaluationAreasResponse data) => json.encode(data.toJson());

class EvaluationAreasResponse {
  String result;
  String message;
  List<EvaluationAreaModel> data;

  EvaluationAreasResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory EvaluationAreasResponse.fromJson(Map<String, dynamic> json) => EvaluationAreasResponse(
    result: json["result"],
    message: json["message"],
    data: List<EvaluationAreaModel>.from(json["data"].map((x) => EvaluationAreaModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EvaluationAreaModel {
  int id;
  String name;

  EvaluationAreaModel({
    required this.id,
    required this.name,
  });

  factory EvaluationAreaModel.fromJson(Map<String, dynamic> json) => EvaluationAreaModel(
    id: json["ID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "Name": name,
  };
}
