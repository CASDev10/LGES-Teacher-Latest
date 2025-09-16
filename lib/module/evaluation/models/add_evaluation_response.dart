import 'dart:convert';

AddEvaluationResponse addEvaluationResponseFromJson(dynamic json) => AddEvaluationResponse.fromJson(json);

String addEvaluationResponseToJson(AddEvaluationResponse data) => json.encode(data.toJson());

class AddEvaluationResponse {
  String result;
  String message;
  Data data;

  AddEvaluationResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory AddEvaluationResponse.fromJson(Map<String, dynamic> json) => AddEvaluationResponse(
    result: json["result"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data(
  );

  Map<String, dynamic> toJson() => {
  };
}