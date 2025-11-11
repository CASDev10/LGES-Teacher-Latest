import 'dart:convert';

AuthResponse authResponseFromJson(dynamic json) => AuthResponse.fromJson(json);

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  final String result;
  final String message;
  final User user;

  AuthResponse({
    required this.result,
    required this.message,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    result: json["result"],
    message: json["message"],
    user: json["data"] == null ? User.empty : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": user.toJson(),
  };
}

class User {
  int userId;
  String fullName;
  int entityId;
  int schoolId;
  int empId;
  String? schoolName;
  String? userPrivileges;

  User({
    required this.userId,
    required this.fullName,
    required this.entityId,
    required this.schoolId,
    required this.schoolName,
    required this.userPrivileges,
    required this.empId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["UC_LoginUserId"],
    fullName: json["UC_UserFullName"],
    entityId: json["UC_EntityId"],
    schoolId: json["UC_SchoolId"],
    schoolName: json["UC_CompanyName"],
    empId: json["EmpId"],
    userPrivileges: json["UserPrivileges"],
  );

  Map<String, dynamic> toJson() => {
    "UC_LoginUserId": userId,
    "UC_UserFullName": fullName,
    "UC_EntityId": entityId,
    "UC_SchoolId": schoolId,
    "UC_CompanyName": schoolName,
    "EmpId": empId,
    "UserPrivileges": userPrivileges,
  };

  static User empty = User(
    userId: -1,
    fullName: "",
    entityId: -1,
    schoolId: -1,
    schoolName: "",
    empId: -1,
    userPrivileges: "",
  );
}
