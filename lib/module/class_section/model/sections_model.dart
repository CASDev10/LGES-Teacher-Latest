import 'dart:convert';

SectionsModel sectionsModelFromJson(dynamic json) =>
    SectionsModel.fromJson(json);

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
  int sectionIdFk;
  int classIdFk;
  int schoolIdFk;
  String classSection;
  String className;
  bool isActive;

  Section({
    required this.sectionIdFk,
    required this.classIdFk,
    required this.schoolIdFk,
    required this.classSection,
    required this.className,
    required this.isActive,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionIdFk: json["SectionIdFk"],
    classIdFk: json["ClassIdFk"],
    schoolIdFk: json["SchoolIdFk"],
    classSection: json["ClassSection"] ?? '',
    className: json["ClassName"] ?? '',
    isActive: json["isActive"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "SectionIdFk": sectionIdFk,
    "ClassIdFk": classIdFk,
    "SchoolIdFk": schoolIdFk,
    "ClassSection": classSection,
    "ClassName": className,
    "isActive": isActive,
  };
}
