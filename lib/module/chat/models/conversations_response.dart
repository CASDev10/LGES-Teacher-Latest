// To parse this JSON data, do
//
//     final conversationsResponse = conversationsResponseFromJson(jsonString);

import 'dart:convert';

ConversationsResponse conversationsResponseFromJson(dynamic json) =>
    ConversationsResponse.fromJson(json);

String conversationsResponseToJson(ConversationsResponse data) =>
    json.encode(data.toJson());

class ConversationsResponse {
  String result;
  String message;
  List<ConversationModel> data;

  ConversationsResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) =>
      ConversationsResponse(
        result: json["result"],
        message: json["message"],
        data: List<ConversationModel>.from(
          json["data"].map((x) => ConversationModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ConversationModel {
  int conversationId;
  String teacherName;
  int studentId;
  String studentName;
  String latestMessage;
  DateTime latestMessageDate;

  ConversationModel({
    required this.conversationId,
    required this.teacherName,
    required this.studentId,
    required this.studentName,
    required this.latestMessage,
    required this.latestMessageDate,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        conversationId: json["ConversationId"],
        teacherName: json["TeacherName"],
        studentId: json["StudentId"],
        studentName: json["StudentName"],
        latestMessage: json["LatestMessage"],
        latestMessageDate: DateTime.parse(json["LatestMessageDate"]),
      );

  Map<String, dynamic> toJson() => {
    "ConversationId": conversationId,
    "TeacherName": teacherName,
    "StudentId": studentId,
    "StudentName": studentName,
    "LatestMessage": latestMessage,
    "LatestMessageDate": latestMessageDate.toIso8601String(),
  };
}
