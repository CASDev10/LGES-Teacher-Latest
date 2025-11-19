// To parse this JSON data, do
//
//     final sendMessageResponse = sendMessageResponseFromJson(jsonString);

import 'dart:convert';

SendMessageResponse sendMessageResponseFromJson(dynamic json) =>
    SendMessageResponse.fromJson(json);

String sendMessageResponseToJson(SendMessageResponse data) =>
    json.encode(data.toJson());

class SendMessageResponse {
  String result;
  String message;
  List<Datum> data;

  SendMessageResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) =>
      SendMessageResponse(
        result: json["result"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int conversationId;

  Datum({required this.conversationId});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(conversationId: json["ConversationId"]);

  Map<String, dynamic> toJson() => {"ConversationId": conversationId};
}
