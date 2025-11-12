// To parse this JSON data, do
//
//     final notificationTypesResponse = notificationTypesResponseFromJson(jsonString);

import 'dart:convert';

NotificationTypesResponse notificationTypesResponseFromJson(dynamic json) =>
    NotificationTypesResponse.fromJson(json);

String notificationTypesResponseToJson(NotificationTypesResponse data) =>
    json.encode(data.toJson());

class NotificationTypesResponse {
  String result;
  String message;
  List<NotificationTypeModel> data;

  NotificationTypesResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory NotificationTypesResponse.fromJson(Map<String, dynamic> json) =>
      NotificationTypesResponse(
        result: json["result"],
        message: json["message"],
        data: List<NotificationTypeModel>.from(
          json["data"].map((x) => NotificationTypeModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationTypeModel {
  String notificationTypeId;
  String notificationTypeName;

  NotificationTypeModel({
    required this.notificationTypeId,
    required this.notificationTypeName,
  });

  factory NotificationTypeModel.fromJson(Map<String, dynamic> json) =>
      NotificationTypeModel(
        notificationTypeId: json["NotificationTypeId"],
        notificationTypeName: json["NotificationTypeName"],
      );

  Map<String, dynamic> toJson() => {
    "NotificationTypeId": notificationTypeId,
    "NotificationTypeName": notificationTypeName,
  };
}
