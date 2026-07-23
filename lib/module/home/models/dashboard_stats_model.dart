import 'dart:convert';

DashboardStatsModel dashboardStatsModelFromJson(dynamic str) =>
    DashboardStatsModel.fromJson(str);

String dashboardStatsModelToJson(DashboardStatsModel data) =>
    json.encode(data.toJson());

class DashboardStatsModel {
  String? result;
  String? message;
  List<NdanceStatList>? studentAttendanceStatList;
  List<NdanceStatList>? employeeAtteandanceStatList;
  List<DiaryStatList>? diaryStatList;
  dynamic ucUser;
  int? ucLoginUserId;
  dynamic ucUserFullName;
  int? ucEntityId;
  int? ucSchoolId;
  int? ucPrivilegeId;
  int? ucIsAllowed;
  int? ucMessageId;
  dynamic ucMessage;
  dynamic ucCompanyName;
  dynamic ucDbConnectionString;
  bool? ucIsAdminUser;
  int? ucFiscalYearId;

  DashboardStatsModel({
    this.result,
    this.message,
    this.studentAttendanceStatList,
    this.employeeAtteandanceStatList,
    this.diaryStatList,
    this.ucUser,
    this.ucLoginUserId,
    this.ucUserFullName,
    this.ucEntityId,
    this.ucSchoolId,
    this.ucPrivilegeId,
    this.ucIsAllowed,
    this.ucMessageId,
    this.ucMessage,
    this.ucCompanyName,
    this.ucDbConnectionString,
    this.ucIsAdminUser,
    this.ucFiscalYearId,
  });

  DashboardStatsModel copyWith({
    String? result,
    String? message,
    List<NdanceStatList>? studentAttendanceStatList,
    List<NdanceStatList>? employeeAtteandanceStatList,
    List<DiaryStatList>? diaryStatList,
    dynamic ucUser,
    int? ucLoginUserId,
    dynamic ucUserFullName,
    int? ucEntityId,
    int? ucSchoolId,
    int? ucPrivilegeId,
    int? ucIsAllowed,
    int? ucMessageId,
    dynamic ucMessage,
    dynamic ucCompanyName,
    dynamic ucDbConnectionString,
    bool? ucIsAdminUser,
    int? ucFiscalYearId,
  }) => DashboardStatsModel(
    result: result ?? this.result,
    message: message ?? this.message,
    studentAttendanceStatList:
        studentAttendanceStatList ?? this.studentAttendanceStatList,
    employeeAtteandanceStatList:
        employeeAtteandanceStatList ?? this.employeeAtteandanceStatList,
    diaryStatList: diaryStatList ?? this.diaryStatList,
    ucUser: ucUser ?? this.ucUser,
    ucLoginUserId: ucLoginUserId ?? this.ucLoginUserId,
    ucUserFullName: ucUserFullName ?? this.ucUserFullName,
    ucEntityId: ucEntityId ?? this.ucEntityId,
    ucSchoolId: ucSchoolId ?? this.ucSchoolId,
    ucPrivilegeId: ucPrivilegeId ?? this.ucPrivilegeId,
    ucIsAllowed: ucIsAllowed ?? this.ucIsAllowed,
    ucMessageId: ucMessageId ?? this.ucMessageId,
    ucMessage: ucMessage ?? this.ucMessage,
    ucCompanyName: ucCompanyName ?? this.ucCompanyName,
    ucDbConnectionString: ucDbConnectionString ?? this.ucDbConnectionString,
    ucIsAdminUser: ucIsAdminUser ?? this.ucIsAdminUser,
    ucFiscalYearId: ucFiscalYearId ?? this.ucFiscalYearId,
  );

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      DashboardStatsModel(
        result: json["result"],
        message: json["message"],
        studentAttendanceStatList: json["StudentAttendanceStatList"] == null
            ? null
            : List<NdanceStatList>.from(
                json["StudentAttendanceStatList"].map(
                  (x) => NdanceStatList.fromJson(x),
                ),
              ),
        employeeAtteandanceStatList: json["EmployeeAtteandanceStatList"] == null
            ? null
            : List<NdanceStatList>.from(
                json["EmployeeAtteandanceStatList"].map(
                  (x) => NdanceStatList.fromJson(x),
                ),
              ),
        diaryStatList: json["DiaryStatList"] == null
            ? null
            : List<DiaryStatList>.from(
                json["DiaryStatList"].map((x) => DiaryStatList.fromJson(x)),
              ),
        ucUser: json["UC_User"],
        ucLoginUserId: json["UC_LoginUserId"],
        ucUserFullName: json["UC_UserFullName"],
        ucEntityId: json["UC_EntityId"],
        ucSchoolId: json["UC_SchoolId"],
        ucPrivilegeId: json["UC_PrivilegeId"],
        ucIsAllowed: json["UC_isAllowed"],
        ucMessageId: json["UC_MessageId"],
        ucMessage: json["UC_Message"],
        ucCompanyName: json["UC_CompanyName"],
        ucDbConnectionString: json["UC_DBConnectionString"],
        ucIsAdminUser: json["UC_isAdminUser"],
        ucFiscalYearId: json["UC_FiscalYearId"],
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "StudentAttendanceStatList": studentAttendanceStatList == null
        ? null
        : List<dynamic>.from(studentAttendanceStatList!.map((x) => x.toJson())),
    "EmployeeAtteandanceStatList": employeeAtteandanceStatList == null
        ? null
        : List<dynamic>.from(
            employeeAtteandanceStatList!.map((x) => x.toJson()),
          ),
    "DiaryStatList": diaryStatList == null
        ? null
        : List<dynamic>.from(diaryStatList!.map((x) => x.toJson())),
    "UC_User": ucUser,
    "UC_LoginUserId": ucLoginUserId,
    "UC_UserFullName": ucUserFullName,
    "UC_EntityId": ucEntityId,
    "UC_SchoolId": ucSchoolId,
    "UC_PrivilegeId": ucPrivilegeId,
    "UC_isAllowed": ucIsAllowed,
    "UC_MessageId": ucMessageId,
    "UC_Message": ucMessage,
    "UC_CompanyName": ucCompanyName,
    "UC_DBConnectionString": ucDbConnectionString,
    "UC_isAdminUser": ucIsAdminUser,
    "UC_FiscalYearId": ucFiscalYearId,
  };
}

class DiaryStatList {
  int? diariesSent;

  DiaryStatList({this.diariesSent});

  DiaryStatList copyWith({int? diariesSent}) =>
      DiaryStatList(diariesSent: diariesSent ?? this.diariesSent);

  factory DiaryStatList.fromJson(Map<String, dynamic> json) =>
      DiaryStatList(diariesSent: json["DiariesSent"]);

  Map<String, dynamic> toJson() => {"DiariesSent": diariesSent};
}

class NdanceStatList {
  int? totalEmployees;
  int? presentCount;
  int? absentCount;
  int? leaveCount;
  int? totalStudent;

  NdanceStatList({
    this.totalEmployees,
    this.presentCount,
    this.absentCount,
    this.leaveCount,
    this.totalStudent,
  });

  NdanceStatList copyWith({
    int? totalEmployees,
    int? presentCount,
    int? absentCount,
    int? leaveCount,
    int? totalStudent,
  }) => NdanceStatList(
    totalEmployees: totalEmployees ?? this.totalEmployees,
    presentCount: presentCount ?? this.presentCount,
    absentCount: absentCount ?? this.absentCount,
    leaveCount: leaveCount ?? this.leaveCount,
    totalStudent: totalStudent ?? this.totalStudent,
  );

  factory NdanceStatList.fromJson(Map<String, dynamic> json) => NdanceStatList(
    totalEmployees: json["TotalEmployees"],
    presentCount: json["PresentCount"],
    absentCount: json["AbsentCount"],
    leaveCount: json["LeaveCount"],
    totalStudent: json["TotalStudent"],
  );

  Map<String, dynamic> toJson() => {
    "TotalEmployees": totalEmployees,
    "PresentCount": presentCount,
    "AbsentCount": absentCount,
    "LeaveCount": leaveCount,
    "TotalStudent": totalStudent,
  };
}
