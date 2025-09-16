// To parse this JSON data, do
//
//     final observationLevelsResponse = observationLevelsResponseFromJson(jsonString);

import 'dart:convert';

ObservationLevelsResponse observationLevelsResponseFromJson(dynamic json) => ObservationLevelsResponse.fromJson(json);

String observationLevelsResponseToJson(ObservationLevelsResponse data) => json.encode(data.toJson());

class ObservationLevelsResponse {
  String result;
  String message;
  List<ObservationLevelModel> data;

  ObservationLevelsResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ObservationLevelsResponse.fromJson(Map<String, dynamic> json) => ObservationLevelsResponse(
    result: json["result"],
    message: json["message"],
    data: List<ObservationLevelModel>.from(json["data"].map((x) => ObservationLevelModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ObservationLevelModel {
  int levelId;
  String level;
  bool isDeleted;
  int createdBy;
  DateTime createdDate;
  int? modifiedBy;
  DateTime? modifiedDate;
  int? deletedBy;
  DateTime? deletedDate;

  ObservationLevelModel({
    required this.levelId,
    required this.level,
    required this.isDeleted,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.deletedBy,
    required this.deletedDate,
  });

  factory ObservationLevelModel.fromJson(Map<String, dynamic> json) => ObservationLevelModel(
    levelId: json["LevelId"],
    level: json["Level"],
    isDeleted: json["IsDeleted"],
    createdBy: json["CreatedBy"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    modifiedBy: json["ModifiedBy"],
    modifiedDate: json["ModifiedDate"] == null ? null : DateTime.parse(json["ModifiedDate"]),
    deletedBy: json["DeletedBy"],
    deletedDate: json["DeletedDate"] == null ? null : DateTime.parse(json["DeletedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "LevelId": levelId,
    "Level": level,
    "IsDeleted": isDeleted,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "ModifiedBy": modifiedBy,
    "ModifiedDate": modifiedDate?.toIso8601String(),
    "DeletedBy": deletedBy,
    "DeletedDate": deletedDate?.toIso8601String(),
  };
}
