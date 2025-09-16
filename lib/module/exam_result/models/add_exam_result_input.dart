// To parse this JSON data, do
//
//     final addExamResultInput = addExamResultInputFromJson(jsonString);

import 'dart:convert';

AddExamResultInput addExamResultInputFromJson(String str) => AddExamResultInput.fromJson(json.decode(str));

String addExamResultInputToJson(AddExamResultInput data) => json.encode(data.toJson());

class AddExamResultInput {
  String ucEntityId;
  String ucLoginUserId;
  String ucSchoolId;
  String classId;
  String sectionId;
  String monthYear;
  List<ResultSheetFixDataModel> fixData;
  List<ResultSheetDynamicSubjectModel> dynamicSubject;

  AddExamResultInput({
    required this.ucEntityId,
    required this.ucLoginUserId,
    required this.ucSchoolId,
    required this.classId,
    required this.sectionId,
    required this.monthYear,
    required this.fixData,
    required this.dynamicSubject,
  });

  factory AddExamResultInput.fromJson(Map<String, dynamic> json) => AddExamResultInput(
    ucEntityId: json["UC_EntityId"],
    ucLoginUserId: json["UC_LoginUserId"],
    ucSchoolId: json["UC_SchoolId"],
    classId: json["ClassId"],
    sectionId: json["SectionId"],
    monthYear: json["MonthYear"],
    fixData: List<ResultSheetFixDataModel>.from(json["FixData"].map((x) => ResultSheetFixDataModel.fromJson(x))),
    dynamicSubject: List<ResultSheetDynamicSubjectModel>.from(json["DynamicSubject"].map((x) => ResultSheetDynamicSubjectModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UC_EntityId": ucEntityId,
    "UC_LoginUserId": ucLoginUserId,
    "UC_SchoolId": ucSchoolId,
    "ClassId": classId,
    "SectionId": sectionId,
    "MonthYear": monthYear,
    "FixData": List<dynamic>.from(fixData.map((x) => x.toJson())),
    "DynamicSubject": List<dynamic>.from(dynamicSubject.map((x) => x.toJson())),
  };
}

class ResultSheetDynamicSubjectModel {
  String studentId;
  String biology;
  String chemistry;
  String englishLanguage;
  String islamiyat;
  String mathematics;
  String pakistanStudies;
  String physics;
  String urdu;

  ResultSheetDynamicSubjectModel({
    required this.studentId,
    required this.biology,
    required this.chemistry,
    required this.englishLanguage,
    required this.islamiyat,
    required this.mathematics,
    required this.pakistanStudies,
    required this.physics,
    required this.urdu,
  });

  factory ResultSheetDynamicSubjectModel.fromJson(Map<String, dynamic> json) => ResultSheetDynamicSubjectModel(
    studentId: json["StudentId"],
    biology: json["Biology"],
    chemistry: json["Chemistry"],
    englishLanguage: json["English Language"],
    islamiyat: json["Islamiyat"],
    mathematics: json["Mathematics"],
    pakistanStudies: json["Pakistan Studies"],
    physics: json["Physics"],
    urdu: json["Urdu"],
  );

  Map<String, dynamic> toJson() => {
    "StudentId": studentId,
    "Biology": biology,
    "Chemistry": chemistry,
    "English Language": englishLanguage,
    "Islamiyat": islamiyat,
    "Mathematics": mathematics,
    "Pakistan Studies": pakistanStudies,
    "Physics": physics,
    "Urdu": urdu,
  };
}

class ResultSheetFixDataModel {
  String studentId;
  String fileNo;
  String obtainedMarks;
  String maxMarks;
  String percentage;

  ResultSheetFixDataModel({
    required this.studentId,
    required this.fileNo,
    required this.obtainedMarks,
    required this.maxMarks,
    required this.percentage,
  });

  factory ResultSheetFixDataModel.fromJson(Map<String, dynamic> json) => ResultSheetFixDataModel(
    studentId: json["StudentId"],
    fileNo: json["FileNo"],
    obtainedMarks: json["ObtainedMarks"],
    maxMarks: json["MaxMarks"],
    percentage: json["Percentage"],
  );

  Map<String, dynamic> toJson() => {
    "StudentId": studentId,
    "FileNo": fileNo,
    "ObtainedMarks": obtainedMarks,
    "MaxMarks": maxMarks,
    "Percentage": percentage,
  };
}
