// To parse this JSON data, do
//
//     final diaryListReponseModel = diaryListReponseModelFromJson(jsonString);

import 'dart:convert';

DiaryListResponseModel diaryListResponseModelFromJson(dynamic json) =>
    DiaryListResponseModel.fromJson(json);

String diaryListResponseModelToJson(DiaryListResponseModel data) =>
    json.encode(data.toJson());

class DiaryListResponseModel {
  String result;
  String message;
  List<DiaryModel> data;

  DiaryListResponseModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory DiaryListResponseModel.fromJson(Map<String, dynamic> json) =>
      DiaryListResponseModel(
        result: json["result"],
        message: json["message"],
        data: List<DiaryModel>.from(
          json["data"].map((x) => DiaryModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DiaryModel {
  int diaryId;
  DateTime dateFrom;
  String dateFromString;
  DateTime dateTo;
  String dateToString;
  int sectionIdFk;
  String sectionName;
  int classIdFk;
  String className;
  int subjectIdFk;
  String subjectName;
  String text;
  String createdBy;
  String createdDateString;
  String mimeType;
  String userFileName;
  String systemFileName;

  DiaryModel({
    required this.diaryId,
    required this.dateFrom,
    required this.dateFromString,
    required this.dateTo,
    required this.dateToString,
    required this.sectionIdFk,
    required this.sectionName,
    required this.classIdFk,
    required this.className,
    required this.subjectIdFk,
    required this.subjectName,
    required this.text,
    required this.createdBy,
    required this.createdDateString,
    required this.mimeType,
    required this.userFileName,
    required this.systemFileName,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) => DiaryModel(
    diaryId: json["DiaryId"],
    dateFrom: DateTime.parse(json["DateFrom"]),
    dateFromString: json["DateFromString"],
    dateTo: DateTime.parse(json["DateTo"]),
    dateToString: json["DateToString"],
    sectionIdFk: json["SectionIdFk"],
    sectionName: json["SectionName"],
    classIdFk: json["ClassIdFk"],
    className: json["ClassName"],
    subjectIdFk: json["SubjectIdFk"],
    subjectName: json["SubjectName"] ?? '',
    text: json["Text"],
    createdBy: json["CreatedBy"],
    createdDateString: json["CreatedDateString"],
    mimeType: json["MIMEType"] ?? '',
    userFileName: json["UserFileName"] ?? '',
    systemFileName: json["SystemFileName"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "DiaryId": diaryId,
    "DateFrom": dateFrom.toIso8601String(),
    "DateFromString": dateFromString,
    "DateTo": dateTo.toIso8601String(),
    "DateToString": dateToString,
    "SectionIdFk": sectionIdFk,
    "SectionName": sectionName,
    "ClassIdFk": classIdFk,
    "ClassName": className,
    "SubjectIdFk": subjectIdFk,
    "SubjectName": subjectName,
    "Text": text,
    "CreatedBy": createdBy,
    "CreatedDateString": createdDateString,
    "MIMEType": mimeType,
    "UserFileName": userFileName,
    "SystemFileName": systemFileName,
  };
}
