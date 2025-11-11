import 'dart:convert';

GetEventsResponse getEventsResponseFromJson(dynamic json) =>
    GetEventsResponse.fromJson(json);

String getEventsResponseToJson(GetEventsResponse data) =>
    json.encode(data.toJson());

class GetEventsResponse {
  final String result;
  final String message;
  final List<EventModel> data;

  GetEventsResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) =>
      GetEventsResponse(
        result: json["result"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<EventModel>.from(
                json["data"].map((x) => EventModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EventModel {
  final String className;
  final String sectionName;
  final String day;
  final bool status;
  final String description;

  EventModel({
    required this.className,
    required this.sectionName,
    required this.day,
    required this.status,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    className: json["ClassName"] ?? "",
    sectionName: json["SectionName"] ?? "",
    day: json["Day"] ?? "",
    status: json["Status"] ?? false,
    description: json["Description"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "ClassName": className,
    "SectionName": sectionName,
    "Day": day,
    "Status": status,
    "Description": description,
  };
}
