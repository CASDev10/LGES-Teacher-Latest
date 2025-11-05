import 'dart:convert';

ApplyLeaveModel applyLeaveModelFromJson(String str) =>
    ApplyLeaveModel.fromJson(json.decode(str));

String applyLeaveModelToJson(ApplyLeaveModel data) =>
    json.encode(data.toJson());

class ApplyLeaveModel {
  String result;
  String message;
  int messageCode;
  ApplyLeaveResponse applyLeaveResponse;

  ApplyLeaveModel({
    required this.result,
    required this.message,
    required this.messageCode,
    required this.applyLeaveResponse,
  });

  factory ApplyLeaveModel.fromJson(Map<String, dynamic> json) =>
      ApplyLeaveModel(
        result: json["Result"],
        message: json["Message"],
        messageCode: json["MessageCode"],
        applyLeaveResponse: ApplyLeaveResponse.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Result": result,
        "Message": message,
        "MessageCode": messageCode,
        "Data": applyLeaveResponse.toJson(),
      };
}

class ApplyLeaveResponse {
  ApplyLeaveResponse();

  factory ApplyLeaveResponse.fromJson(Map<String, dynamic> json) =>
      ApplyLeaveResponse();

  Map<String, dynamic> toJson() => {};
}
