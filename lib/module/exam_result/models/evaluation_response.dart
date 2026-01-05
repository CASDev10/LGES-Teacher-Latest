import 'dart:convert';

EvaluationResponse evaluationResponseFromJson(dynamic json) =>
    EvaluationResponse.fromJson(json);

String evaluationResponseToJson(EvaluationResponse data) =>
    json.encode(data.toJson());

class EvaluationResponse {
  String result;
  String message;
  List<EvaluationModel> data;

  EvaluationResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory EvaluationResponse.fromJson(Map<String, dynamic> json) =>
      EvaluationResponse(
        result: json["result"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<EvaluationModel>.from(
                json["data"].map((x) => EvaluationModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class EvaluationModel {
  int evaluationId;
  String name;
  int evaluationTypeId;
  String evaluationType;
  int orderNumber;
  DateTime? lastDate; // ✅ FIXED

  EvaluationModel({
    required this.evaluationId,
    required this.name,
    required this.evaluationTypeId,
    required this.evaluationType,
    required this.orderNumber,
    this.lastDate,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) =>
      EvaluationModel(
        evaluationId: json["EvaluationId"],
        name: json["Name"],
        evaluationTypeId: json["EvaluationTypeId"],
        evaluationType: json["EvaluationType"],
        orderNumber: json["OrderNumber"],
        lastDate: json["LastDate"] == null
            ? null
            : DateTime.parse(json["LastDate"]),
      );

  Map<String, dynamic> toJson() => {
    "EvaluationId": evaluationId,
    "Name": name,
    "EvaluationTypeId": evaluationTypeId,
    "EvaluationType": evaluationType,
    "OrderNumber": orderNumber,
    "LastDate": lastDate?.toIso8601String(),
  };
}
