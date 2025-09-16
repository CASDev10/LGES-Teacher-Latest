// To parse this JSON data, do
//
//     final addEvaluationInput = addEvaluationInputFromJson(jsonString);

import 'dart:convert';

AddEvaluationInput addEvaluationInputFromJson(String str) => AddEvaluationInput.fromJson(json.decode(str));

String addEvaluationInputToJson(AddEvaluationInput data) => json.encode(data.toJson());

class AddEvaluationInput {
  String ucEntityId;
  String ucLoginUserId;
  String ucSchoolId;
  String studentIdfK;
  String evaluationDate;
  String remarks;
  List<EvaluationLogBookDetail1> evaluationLogBookDetail1;
  List<EvaluationLogBookDetail2> evaluationLogBookDetail2;

  AddEvaluationInput({
    required this.ucEntityId,
    required this.ucLoginUserId,
    required this.ucSchoolId,
    required this.studentIdfK,
    required this.evaluationDate,
    required this.remarks,
    required this.evaluationLogBookDetail1,
    required this.evaluationLogBookDetail2,
  });

  factory AddEvaluationInput.fromJson(Map<String, dynamic> json) => AddEvaluationInput(
    ucEntityId: json["UC_EntityId"],
    ucLoginUserId: json["UC_LoginUserId"],
    ucSchoolId: json["UC_SchoolId"],
    studentIdfK: json["StudentIdfK"],
    evaluationDate: json["EvaluationDate"],
    remarks: json["Remarks"],
    evaluationLogBookDetail1: List<EvaluationLogBookDetail1>.from(json["EvaluationLogBookDetail1"].map((x) => EvaluationLogBookDetail1.fromJson(x))),
    evaluationLogBookDetail2: List<EvaluationLogBookDetail2>.from(json["EvaluationLogBookDetail2"].map((x) => EvaluationLogBookDetail2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UC_EntityId": ucEntityId,
    "UC_LoginUserId": ucLoginUserId,
    "UC_SchoolId": ucSchoolId,
    "StudentIdfK": studentIdfK,
    "EvaluationDate": evaluationDate,
    "Remarks": remarks,
    "EvaluationLogBookDetail1": List<dynamic>.from(evaluationLogBookDetail1.map((x) => x.toJson())),
    "EvaluationLogBookDetail2": List<dynamic>.from(evaluationLogBookDetail2.map((x) => x.toJson())),
  };
}

class EvaluationLogBookDetail1 {
  int subjectId;
  double marksPercent;

  EvaluationLogBookDetail1({
    required this.subjectId,
    required this.marksPercent,
  });

  factory EvaluationLogBookDetail1.fromJson(Map<String, dynamic> json) => EvaluationLogBookDetail1(
    subjectId: json["SubjectId"],
    marksPercent: json["MarksPercent"],
  );

  Map<String, dynamic> toJson() => {
    "SubjectId": subjectId,
    "MarksPercent": marksPercent,
  };
}

class EvaluationLogBookDetail2 {
  int evaluationAreaId;
  int evaluationRemarksId;

  EvaluationLogBookDetail2({
    required this.evaluationAreaId,
    required this.evaluationRemarksId,
  });

  factory EvaluationLogBookDetail2.fromJson(Map<String, dynamic> json) => EvaluationLogBookDetail2(
    evaluationAreaId: json["EvaluationAreaId"],
    evaluationRemarksId: json["EvaluationRemarksId"],
  );

  Map<String, dynamic> toJson() => {
    "EvaluationAreaId": evaluationAreaId,
    "EvaluationRemarksId": evaluationRemarksId,
  };
}
