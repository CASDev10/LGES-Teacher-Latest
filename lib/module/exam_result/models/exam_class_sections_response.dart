// To parse this JSON data, do
//
//     final examClassSectionsResponse = examClassSectionsResponseFromJson(jsonString);

import 'dart:convert';

ExamClassSectionsResponse examClassSectionsResponseFromJson(dynamic json) => ExamClassSectionsResponse.fromJson(json);

String examClassSectionsResponseToJson(ExamClassSectionsResponse data) => json.encode(data.toJson());

class ExamClassSectionsResponse {
  String result;
  String message;
  List<ExamClassSectionModel> data;

  ExamClassSectionsResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ExamClassSectionsResponse.fromJson(Map<String, dynamic> json) => ExamClassSectionsResponse(
    result: json["result"],
    message: json["message"],
    data: List<ExamClassSectionModel>.from(json["data"].map((x) => ExamClassSectionModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ExamClassSectionModel {
  int sectionId;
  String sessionName;
  String sectionName;
  String sectionCode;
  int sessionIdFk;

  ExamClassSectionModel({
    required this.sectionId,
    required this.sessionName,
    required this.sectionName,
    required this.sectionCode,
    required this.sessionIdFk,
  });

  factory ExamClassSectionModel.fromJson(Map<String, dynamic> json) => ExamClassSectionModel(
    sectionId: json["SectionId"],
    sessionName: json["SessionName"],
    sectionName: json["SectionName"],
    sectionCode: json["SectionCode"],
    sessionIdFk: json["SessionIdFk"],
  );

  Map<String, dynamic> toJson() => {
    "SectionId": sectionId,
    "SessionName": sessionName,
    "SectionName": sectionName,
    "SectionCode": sectionCode,
    "SessionIdFk": sessionIdFk,
  };
}
