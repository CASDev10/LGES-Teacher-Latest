import 'dart:convert';

SectionsModel sectionsModelFromJson(dynamic json) => SectionsModel.fromJson(json);

String sectionsModelToJson(SectionsModel data) => json.encode(data.toJson());

class SectionsModel {
  String result;
  String message;
  List<Section> data;

  SectionsModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory SectionsModel.fromJson(Map<String, dynamic> json) => SectionsModel(
    result: json["result"],
    message: json["message"],
    data: List<Section>.from(json["data"].map((x) => Section.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Section {
  int sectionId;
  String sessionName;
  String sectionName;
  String sectionCode;
  int sessionIdFk;
  bool isActive;

  Section({
    required this.sectionId,
    required this.sessionName,
    required this.sectionName,
    required this.sectionCode,
    required this.sessionIdFk,
    required this.isActive,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: json["SectionId"],
    sessionName: json["SessionName"],
    sectionName: json["SectionName"],
    sectionCode: json["SectionCode"],
    sessionIdFk: json["SessionIdFk"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "SectionId": sectionId,
    "SessionName": sessionName,
    "SectionName": sectionName,
    "SectionCode": sectionCode,
    "SessionIdFk": sessionIdFk,
    "isActive": isActive,
  };
}
