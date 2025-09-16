import 'dart:convert';

UserSchoolsModel userSchoolsModelFromJson(dynamic json) => UserSchoolsModel.fromJson(json);

String userSchoolsModelToJson(UserSchoolsModel data) => json.encode(data.toJson());

class UserSchoolsModel {
  String result;
  String message;
  List<UserSchool> data;

  UserSchoolsModel({
    required this.result,
    required this.message,
    required this.data,
  });

  factory UserSchoolsModel.fromJson(Map<String, dynamic> json) => UserSchoolsModel(
    result: json["result"],
    message: json["message"],
    data: List<UserSchool>.from(json["data"].map((x) => UserSchool.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserSchool {
  int schoolId;
  bool isActive;
  bool isDeleted;
  String schoolName;

  UserSchool({
    required this.schoolId,
    required this.isActive,
    required this.isDeleted,
    required this.schoolName,
  });

  factory UserSchool.fromJson(Map<String, dynamic> json) => UserSchool(
    schoolId: json["SchoolID"],
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    schoolName: json["SchoolName"],
  );

  Map<String, dynamic> toJson() => {
    "SchoolID": schoolId,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "SchoolName": schoolName,
  };
}
