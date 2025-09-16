
import 'dart:convert';

ForgetPasswordResponseModel forgetPasswordResponseModelFromJson(dynamic json) => ForgetPasswordResponseModel.fromJson(json);

String forgetPasswordResponseModelToJson(ForgetPasswordResponseModel data) => json.encode(data.toJson());

class ForgetPasswordResponseModel {
  String result;
  String message;

  ForgetPasswordResponseModel({
    required this.result,
    required this.message,
  });

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) => ForgetPasswordResponseModel(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message
  };
}