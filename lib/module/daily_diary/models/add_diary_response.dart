// To parse this JSON data, do
//
//     final addDiaryResponseModel = addDiaryResponseModelFromJson(jsonString);

import 'dart:convert';

AddDiaryResponseModel addDiaryResponseModelFromJson(dynamic json) => AddDiaryResponseModel.fromJson(json);

String addDiaryResponseModelToJson(AddDiaryResponseModel data) => json.encode(data.toJson());

class AddDiaryResponseModel {
  String result;
  String message;

  AddDiaryResponseModel({
    required this.result,
    required this.message,
  });

  factory AddDiaryResponseModel.fromJson(Map<String, dynamic> json) => AddDiaryResponseModel(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
