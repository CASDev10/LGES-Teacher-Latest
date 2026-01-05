import 'dart:convert';

EvaluationTypeResponse evaluationTypeResponseFromJson(dynamic json) =>
    EvaluationTypeResponse.fromJson(json);

String evaluationTypeResponseToJson(EvaluationTypeResponse data) =>
    json.encode(data.toJson());

class EvaluationTypeResponse {
  String result;
  String message;
  List<EvaluationTypeModel> data;

  EvaluationTypeResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  EvaluationTypeResponse copyWith({
    String? result,
    String? message,
    List<EvaluationTypeModel>? data,
  }) =>
      EvaluationTypeResponse(
        result: result ?? this.result,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory EvaluationTypeResponse.fromJson(Map<String, dynamic> json) =>
      EvaluationTypeResponse(
        result: json["result"],
        message: json["message"],
        data: List<EvaluationTypeModel>.from(
            json["data"].map((x) => EvaluationTypeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EvaluationTypeModel {
  int evaluationTypeId;
  String name;

  EvaluationTypeModel({
    required this.evaluationTypeId,
    required this.name,
  });

  EvaluationTypeModel copyWith({
    int? evaluationTypeId,
    String? name,
  }) =>
      EvaluationTypeModel(
        evaluationTypeId: evaluationTypeId ?? this.evaluationTypeId,
        name: name ?? this.name,
      );

  factory EvaluationTypeModel.fromJson(Map<String, dynamic> json) =>
      EvaluationTypeModel(
        evaluationTypeId: json["EvaluationTypeId"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "EvaluationTypeId": evaluationTypeId,
        "Name": name,
      };
}
