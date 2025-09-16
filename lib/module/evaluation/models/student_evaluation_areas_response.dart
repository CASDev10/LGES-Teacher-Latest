import 'dart:convert';

StudentEvaluationAreasResponse studentEvaluationAreasResponseFromJson(dynamic json) => StudentEvaluationAreasResponse.fromJson(json);

String studentEvaluationAreasResponseToJson(StudentEvaluationAreasResponse data) => json.encode(data.toJson());

class StudentEvaluationAreasResponse {
  String result;
  String message;
  StudentEvaluationAreaModel data;

  StudentEvaluationAreasResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory StudentEvaluationAreasResponse.fromJson(Map<String, dynamic> json) => StudentEvaluationAreasResponse(
    result: json["result"],
    message: json["message"],
    data: StudentEvaluationAreaModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class StudentEvaluationAreaModel {
  List<EvaluationArea> evaluationArea;
  List<ClassSubject> classSubject;

  StudentEvaluationAreaModel({
    required this.evaluationArea,
    required this.classSubject,
  });

  factory StudentEvaluationAreaModel.fromJson(Map<String, dynamic> json) => StudentEvaluationAreaModel(
    evaluationArea: List<EvaluationArea>.from(json["EvaluationArea"].map((x) => EvaluationArea.fromJson(x))),
    classSubject: List<ClassSubject>.from(json["ClassSubject"].map((x) => ClassSubject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "EvaluationArea": List<dynamic>.from(evaluationArea.map((x) => x.toJson())),
    "ClassSubject": List<dynamic>.from(classSubject.map((x) => x.toJson())),
  };
}

class ClassSubject {
  int subjectId;
  String subjectName;
  double marksPercent;

  ClassSubject({
    required this.subjectId,
    required this.subjectName,
    required this.marksPercent,
  });

  factory ClassSubject.fromJson(Map<String, dynamic> json) => ClassSubject(
    subjectId: json["SubjectId"],
    subjectName: json["SubjectName"],
    marksPercent: json["MarksPercent"],
  );

  Map<String, dynamic> toJson() => {
    "SubjectId": subjectId,
    "SubjectName": subjectName,
    "MarksPercent": marksPercent,
  };
}

class EvaluationArea {
  int evaluationAreaId;
  String evaluationAreaName;
  int evaluationRemarks;

  EvaluationArea({
    required this.evaluationAreaId,
    required this.evaluationAreaName,
    required this.evaluationRemarks,
  });

  factory EvaluationArea.fromJson(Map<String, dynamic> json) => EvaluationArea(
    evaluationAreaId: json["EvaluationAreaId"],
    evaluationAreaName: json["EvaluationAreaName"],
    evaluationRemarks: json["EvaluationRemarks"],
  );

  Map<String, dynamic> toJson() => {
    "EvaluationAreaId": evaluationAreaId,
    "EvaluationAreaName": evaluationAreaName,
    "EvaluationRemarks": evaluationRemarks,
  };
}
