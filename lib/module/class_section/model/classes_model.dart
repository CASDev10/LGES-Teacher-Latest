import 'dart:convert';

ClassesModel classesModelFromJson(dynamic json) => ClassesModel.fromJson(json);

String classesModelToJson(ClassesModel data) => json.encode(data.toJson());

class ClassesModel {
  String result;
  String message;
  List<Class> data;

  ClassesModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory ClassesModel.fromJson(Map<String, dynamic> json) => ClassesModel(
    result: json["result"],
    message: json["message"],
    data: List<Class>.from(json["data"].map((x) => Class.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Class {
  int classId;
  String className;
  bool isActive;

  Class({
    required this.classId,
    required this.className,
    required this.isActive,
  });

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    classId: json["ClassId"],
    className: json["ClassName"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "ClassId": classId,
    "ClassName": className,
    "isActive": isActive,
  };
}
