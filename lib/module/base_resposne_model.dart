// To parse this JSON data, do
//
//     final baseResponseModel = baseResponseModelFromJson(jsonString);

import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(dynamic json) => BaseResponseModel.fromJson(json);

String baseResponseModelToJson(BaseResponseModel data) => json.encode(data.toJson());

class BaseResponseModel {
  String result;
  String message;
  Data data;

  BaseResponseModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => BaseResponseModel(
    result: json["result"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}
