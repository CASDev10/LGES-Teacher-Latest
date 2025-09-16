import 'dart:convert';

StudentEvaluationAreasInput studentEvaluationAreasInputFromJson(String str) => StudentEvaluationAreasInput.fromJson(json.decode(str));

String studentEvaluationAreasInputToJson(StudentEvaluationAreasInput data) => json.encode(data.toJson());

class StudentEvaluationAreasInput {
  String studentIdfK;

  StudentEvaluationAreasInput({
    required this.studentIdfK,
  });

  factory StudentEvaluationAreasInput.fromJson(Map<String, dynamic> json) => StudentEvaluationAreasInput(
    studentIdfK: json["StudentIdfK"],
  );

  Map<String, dynamic> toJson() => {
    "StudentIdfK": studentIdfK,
  };
}