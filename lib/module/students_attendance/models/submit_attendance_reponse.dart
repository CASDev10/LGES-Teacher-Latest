import 'dart:convert';

SubmitAttendanceResponseModel submitAttendanceResponseModelFromJson(dynamic json) => SubmitAttendanceResponseModel.fromJson(json);

String submitAttendanceResponseModelToJson(SubmitAttendanceResponseModel data) => json.encode(data.toJson());

class SubmitAttendanceResponseModel {
  String result;
  String message;

  SubmitAttendanceResponseModel({
    required this.result,
    required this.message,
  });

  factory SubmitAttendanceResponseModel.fromJson(Map<String, dynamic> json) => SubmitAttendanceResponseModel(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message
  };
}
