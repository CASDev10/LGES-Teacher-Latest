// To parse this JSON data, do
//
//     final importExamResultDataInput = importExamResultDataInputFromJson(jsonString);

import 'dart:convert';

ImportExamResultDataInput importExamResultDataInputFromJson(String str) => ImportExamResultDataInput.fromJson(json.decode(str));

String importExamResultDataInputToJson(ImportExamResultDataInput data) => json.encode(data.toJson());

class ImportExamResultDataInput {
  String ucEntityId;
  String ucLoginUserId;
  String ucSchoolId;
  String classId;
  String sectionId;
  String monthYear;
  String fixData;
  String dynamicSubject;

  ImportExamResultDataInput({
    required this.ucEntityId,
    required this.ucLoginUserId,
    required this.ucSchoolId,
    required this.classId,
    required this.sectionId,
    required this.monthYear,
    required this.fixData,
    required this.dynamicSubject,
  });

  factory ImportExamResultDataInput.fromJson(Map<String, dynamic> json) => ImportExamResultDataInput(
    ucEntityId: json["UC_EntityId"],
    ucLoginUserId: json["UC_LoginUserId"],
    ucSchoolId: json["UC_SchoolId"],
    classId: json["ClassId"],
    sectionId: json["SectionId"],
    monthYear: json["MonthYear"],
    fixData: json["FixData"],
    dynamicSubject: json["DynamicSubject"],
  );

  Map<String, dynamic> toJson() => {
    "UC_EntityId": ucEntityId,
    "UC_LoginUserId": ucLoginUserId,
    "UC_SchoolId": ucSchoolId,
    "ClassId": classId,
    "SectionId": sectionId,
    "MonthYear": monthYear,
    "FixData": fixData,
    "DynamicSubject": dynamicSubject,
  };
}
