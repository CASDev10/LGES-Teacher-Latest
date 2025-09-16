// To parse this JSON data, do
//
//     final observationRemarksResponse = observationRemarksResponseFromJson(jsonString);

import 'dart:convert';

ObservationRemarksResponse observationRemarksResponseFromJson(dynamic json) => ObservationRemarksResponse.fromJson(json);

String observationRemarksResponseToJson(ObservationRemarksResponse data) => json.encode(data.toJson());

class ObservationRemarksResponse {
  String result;
  String message;
  List<ObservationRemarksModel> data;

  ObservationRemarksResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ObservationRemarksResponse.fromJson(Map<String, dynamic> json) => ObservationRemarksResponse(
    result: json["result"],
    message: json["message"],
    data: List<ObservationRemarksModel>.from(json["data"].map((x) => ObservationRemarksModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ObservationRemarksModel {
  int remarksId;
  String remarks;
  int areaIdFk;
  bool isDeleted;
  int createdBy;
  DateTime createdDate;
  int? modifiedBy;
  DateTime? modifiedDate;
  dynamic deletedBy;
  dynamic deletedDate;
  String areaName;

  ObservationRemarksModel({
    required this.remarksId,
    required this.remarks,
    required this.areaIdFk,
    required this.isDeleted,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.deletedBy,
    required this.deletedDate,
    required this.areaName,
  });

  factory ObservationRemarksModel.fromJson(Map<String, dynamic> json) => ObservationRemarksModel(
    remarksId: json["RemarksId"],
    remarks: json["Remarks"],
    areaIdFk: json["AreaIdFk"],
    isDeleted: json["IsDeleted"],
    createdBy: json["CreatedBy"],
    createdDate: DateTime.parse(json["CreatedDate"]),
    modifiedBy: json["ModifiedBy"],
    modifiedDate: json["ModifiedDate"] == null ? null : DateTime.parse(json["ModifiedDate"]),
    deletedBy: json["DeletedBy"],
    deletedDate: json["DeletedDate"],
    areaName: json["AreaName"],
  );

  Map<String, dynamic> toJson() => {
    "RemarksId": remarksId,
    "Remarks": remarks,
    "AreaIdFk": areaIdFk,
    "IsDeleted": isDeleted,
    "CreatedBy": createdBy,
    "CreatedDate": createdDate.toIso8601String(),
    "ModifiedBy": modifiedBy,
    "ModifiedDate": modifiedDate?.toIso8601String(),
    "DeletedBy": deletedBy,
    "DeletedDate": deletedDate,
    "AreaName": areaName,
  };
}
