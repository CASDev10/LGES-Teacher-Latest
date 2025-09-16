


class AddEvaluationRemarksInput {
  String evaluationRemarks;
  String evaluationAreaIdFk;
  String ucLoginUserId;

  AddEvaluationRemarksInput({
    required this.evaluationRemarks,
    required this.evaluationAreaIdFk,
    required this.ucLoginUserId,
  });

  factory AddEvaluationRemarksInput.fromJson(Map<String, dynamic> json) => AddEvaluationRemarksInput(
    evaluationRemarks: json["EvaluationRemarks"],
    evaluationAreaIdFk: json["EvaluationAreaIdFk"],
    ucLoginUserId: json["UC_LoginUserId"],
  );

  Map<String, dynamic> toJson() => {
    "EvaluationRemarks": evaluationRemarks,
    "EvaluationAreaIdFk": evaluationAreaIdFk,
    "UC_LoginUserId": ucLoginUserId,
  };
}