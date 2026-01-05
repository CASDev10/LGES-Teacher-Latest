import 'dart:convert';

ImportExamResultDataInput importExamResultDataInputFromJson(String str) =>
    ImportExamResultDataInput.fromJson(json.decode(str));

String importExamResultDataInputToJson(ImportExamResultDataInput data) =>
    json.encode(data.toJson());

class ImportExamResultDataInput {
  int classId;
  int sectionId;
  int evaluationGroupId;
  int evaluationIdFk;
  int ucLoginUserId;

  ImportExamResultDataInput({
    required this.classId,
    required this.sectionId,
    required this.evaluationGroupId,
    required this.evaluationIdFk,
    required this.ucLoginUserId,
  });

  factory ImportExamResultDataInput.fromJson(Map<String, dynamic> json) =>
      ImportExamResultDataInput(
        classId: json["ClassId"],
        sectionId: json["SectionId"],
        evaluationGroupId: json["EvaluationGroupId"],
        evaluationIdFk: json["EvaluationIdFk"],
        ucLoginUserId: json["UC_LoginUserId"],
      );

  Map<String, dynamic> toJson() => {
    "ClassId": classId,
    "SectionId": sectionId,
    "EvaluationGroupId": evaluationGroupId,
    "EvaluationIdFk": evaluationIdFk,
    "UC_LoginUserId": ucLoginUserId,
  };
}
