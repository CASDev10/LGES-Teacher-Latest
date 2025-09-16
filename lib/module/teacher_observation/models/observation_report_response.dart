// To parse this JSON data, do
//
//     final observationReportResponse = observationReportResponseFromJson(jsonString);

import 'dart:convert';

ObservationReportResponse observationReportResponseFromJson(dynamic json) => ObservationReportResponse.fromJson(json);

String observationReportResponseToJson(ObservationReportResponse data) => json.encode(data.toJson());

class ObservationReportResponse {
  String result;
  String message;
  List<ObservationReportModel> data;

  ObservationReportResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ObservationReportResponse.fromJson(Map<String, dynamic> json) => ObservationReportResponse(
    result: json["result"],
    message: json["message"],
    data: List<ObservationReportModel>.from(json["data"].map((x) => ObservationReportModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ObservationReportModel {
  int srNo;
  String submitDate;
  String level;
  String headName;
  String teacherName;
  String feedBack;
  String communicationSkills;
  String contributionInWholeSchoolProgrammes;
  String dutiesPerformedModBreakDisciplineEtc;
  String notebookChecking;
  String punctuality;
  String qualityOfTeaching;
  String supportProvidedToLrLs;

  ObservationReportModel({
    required this.srNo,
    required this.submitDate,
    required this.level,
    required this.headName,
    required this.teacherName,
    required this.feedBack,
    required this.communicationSkills,
    required this.contributionInWholeSchoolProgrammes,
    required this.dutiesPerformedModBreakDisciplineEtc,
    required this.notebookChecking,
    required this.punctuality,
    required this.qualityOfTeaching,
    required this.supportProvidedToLrLs,
  });

  factory ObservationReportModel.fromJson(Map<String, dynamic> json) => ObservationReportModel(
    srNo: json["SrNo"],
    submitDate: json["SubmitDate"],
    level: json["Level"],
    headName: json["HeadName"],
    teacherName: json["TeacherName"],
    feedBack: json["FeedBack"],
    communicationSkills: json["Communication Skills"],
    contributionInWholeSchoolProgrammes: json["Contribution in Whole School Programmes"],
    dutiesPerformedModBreakDisciplineEtc: json["Duties Performed (MOD,BREAK,DISCIPLINE etc)"],
    notebookChecking: json["Notebook Checking"],
    punctuality: json["Punctuality"],
    qualityOfTeaching: json["Quality of Teaching"],
    supportProvidedToLrLs: json["Support Provided to LRLs "],
  );

  Map<String, dynamic> toJson() => {
    "SrNo": srNo,
    "SubmitDate": submitDate,
    "Level": level,
    "HeadName": headName,
    "TeacherName": teacherName,
    "FeedBack": feedBack,
    "Communication Skills": communicationSkills,
    "Contribution in Whole School Programmes": contributionInWholeSchoolProgrammes,
    "Duties Performed (MOD,BREAK,DISCIPLINE etc)": dutiesPerformedModBreakDisciplineEtc,
    "Notebook Checking": notebookChecking,
    "Punctuality": punctuality,
    "Quality of Teaching": qualityOfTeaching,
    "Support Provided to LRLs ": supportProvidedToLrLs,
  };
}
