// To parse this JSON data, do
//
//     final chatHistoryResponse = chatHistoryResponseFromJson(jsonString);

import 'dart:convert';

ChatHistoryResponse chatHistoryResponseFromJson(dynamic json) =>
    ChatHistoryResponse.fromJson(json);

String chatHistoryResponseToJson(ChatHistoryResponse data) =>
    json.encode(data.toJson());

class ChatHistoryResponse {
  String result;
  String message;
  List<MessageModel> data;

  ChatHistoryResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) =>
      ChatHistoryResponse(
        result: json["result"],
        message: json["message"],
        data: List<MessageModel>.from(
          json["data"].map((x) => MessageModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MessageModel {
  int conversationId;
  int messageId;
  int empId;
  int studentId;
  String text;
  int senderId;
  DateTime sentDate;
  bool isSeen;
  dynamic seenAt;

  MessageModel({
    required this.conversationId,
    required this.messageId,
    required this.empId,
    required this.studentId,
    required this.text,
    required this.senderId,
    required this.sentDate,
    required this.isSeen,
    required this.seenAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    conversationId: json["ConversationId"],
    messageId: json["MessageId"],
    empId: json["EmpId"],
    studentId: json["StudentId"],
    text: json["Text"],
    senderId: json["SenderId"],
    sentDate: DateTime.parse(json["SentDate"]),
    isSeen: json["isSeen"],
    seenAt: json["SeenAt"],
  );

  Map<String, dynamic> toJson() => {
    "ConversationId": conversationId,
    "MessageId": messageId,
    "EmpId": empId,
    "StudentId": studentId,
    "Text": text,
    "SenderId": senderId,
    "SentDate": sentDate.toIso8601String(),
    "isSeen": isSeen,
    "SeenAt": seenAt,
  };
}
