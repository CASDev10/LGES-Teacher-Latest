// To parse this JSON data, do
//
//     final observationAreasResponse = observationAreasResponseFromJson(jsonString);

import 'dart:convert';

ObservationAreasResponse observationAreasResponseFromJson(dynamic json) => ObservationAreasResponse.fromJson(json);

String observationAreasResponseToJson(ObservationAreasResponse data) => json.encode(data.toJson());

class ObservationAreasResponse {
  String result;
  String message;
  ObservationModel data;

  ObservationAreasResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ObservationAreasResponse.fromJson(Map<String, dynamic> json) => ObservationAreasResponse(
    result: json["result"],
    message: json["message"],
    data: ObservationModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data.toJson(),
  };
}

class ObservationModel {
  List<ObservationArea> observationArea;
  List<ObservationLevel> observationLevel;
  List<ObservationRemark> observationRemarks;

  ObservationModel({
    required this.observationArea,
    required this.observationLevel,
    required this.observationRemarks,
  });

  factory ObservationModel.fromJson(Map<String, dynamic> json) => ObservationModel(
    observationArea: List<ObservationArea>.from(json["Observation_Area"].map((x) => ObservationArea.fromJson(x))),
    observationLevel: List<ObservationLevel>.from(json["Observation_Level"].map((x) => ObservationLevel.fromJson(x))),
    observationRemarks: List<ObservationRemark>.from(json["Observation_Remarks"].map((x) => ObservationRemark.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Observation_Area": List<dynamic>.from(observationArea.map((x) => x.toJson())),
    "Observation_Level": List<dynamic>.from(observationLevel.map((x) => x.toJson())),
    "Observation_Remarks": List<dynamic>.from(observationRemarks.map((x) => x.toJson())),
  };
}

class ObservationArea {
  int areaId;
  String areaName;

  ObservationArea({
    required this.areaId,
    required this.areaName,
  });

  factory ObservationArea.fromJson(Map<String, dynamic> json) => ObservationArea(
    areaId: json["AreaId"],
    areaName: json["AreaName"],
  );

  Map<String, dynamic> toJson() => {
    "AreaId": areaId,
    "AreaName": areaName,
  };
}

class ObservationLevel {
  int levelId;
  String level;
  bool isDeleted;
  int createdBy;
  DateTime createdDate;
  dynamic modifiedBy;
  dynamic modifiedDate;
  dynamic deletedBy;
  dynamic deletedDate;

  ObservationLevel({
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

  factory ObservationLevel.fromJson(Map<String, dynamic> json) => ObservationLevel(
    levelId: json["LevelId"],
    level: json["Level"],
    isDeleted: json["IsDeleted"],
    createdBy: json["CreatedBy"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    modifiedBy: json["ModifiedBy"],
    modifiedDate: json["ModifiedDate"],
    deletedBy: json["DeletedBy"],
    deletedDate: json["DeletedDate"],
  );

  Map<String, dynamic> toJson() => {
    "LevelId": levelId,
    "Level": level,
    "IsDeleted": isDeleted,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "ModifiedBy": modifiedBy,
    "ModifiedDate": modifiedDate,
    "DeletedBy": deletedBy,
    "DeletedDate": deletedDate,
  };
}

class ObservationRemark {
  int remarksId;
  String remarks;
  int areaId;
  String areaName;

  ObservationRemark({
    required this.remarksId,
    required this.remarks,
    required this.areaId,
    required this.areaName,
  });

  factory ObservationRemark.fromJson(Map<String, dynamic> json) => ObservationRemark(
    remarksId: json["RemarksId"],
    remarks: json["Remarks"],
    areaId: json["AreaId"],
    areaName: json["AreaName"],
  );

  Map<String, dynamic> toJson() => {
    "RemarksId": remarksId,
    "Remarks": remarks,
    "AreaId": areaId,
    "AreaName": areaName,
  };
}
