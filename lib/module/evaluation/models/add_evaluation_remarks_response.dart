
import 'dart:convert';

AddEvaluationResponseModel addEvaluationResponseModelFromJson(dynamic json) => AddEvaluationResponseModel.fromJson(json);

String addEvaluationResponseModelToJson(AddEvaluationResponseModel data) => json.encode(data.toJson());

class AddEvaluationResponseModel {
  String result;
  String message;

  AddEvaluationResponseModel({
    required this.result,
    required this.message,
  });

  factory AddEvaluationResponseModel.fromJson(Map<String, dynamic> json) => AddEvaluationResponseModel(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message
  };
}