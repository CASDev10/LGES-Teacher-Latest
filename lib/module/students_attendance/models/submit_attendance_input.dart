
import 'dart:convert';

class SubmitAttendanceInput {
  String ucEntityId;
  String ucLoginUserId;
  Attendance attendance;
  List<AttendanceListModel> attendanceList;

  SubmitAttendanceInput({
    required this.ucEntityId,
    required this.ucLoginUserId,
    required this.attendance,
    required this.attendanceList,
  });

  factory SubmitAttendanceInput.fromJson(Map<String, dynamic> json) => SubmitAttendanceInput(
    ucEntityId: json["UC_EntityId"],
    ucLoginUserId: json["UC_LoginUserId"],
    attendance: Attendance.fromJson(json["Attendance"]),
    attendanceList: List<AttendanceListModel>.from(json["AttendanceList"].map((x) => AttendanceListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UC_EntityId": ucEntityId,
    "UC_LoginUserId": ucLoginUserId,
    "Attendance": attendance.toJson(),
    "AttendanceList": List<dynamic>.from(attendanceList.map((x) => x.toJson())),
  };
}

class Attendance {
  String classIdFk;
  String schoolIdFk;
  String sectionIdFk;
  String attendanceDate;

  Attendance({
    required this.classIdFk,
    required this.schoolIdFk,
    required this.sectionIdFk,
    required this.attendanceDate,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    classIdFk: json["ClassIdFk"],
    schoolIdFk: json["SchoolIdFk"],
    sectionIdFk: json["SectionIdFk"],
    attendanceDate: json["AttendanceDate"],
  );

  Map<String, dynamic> toJson() => {
    "ClassIdFk": classIdFk,
    "SchoolIdFk": schoolIdFk,
    "SectionIdFk": sectionIdFk,
    "AttendanceDate": attendanceDate,
  };
}

class AttendanceListModel {
  String attendanceStatusIdFk;
  String studentIdFk;

  AttendanceListModel({
    required this.attendanceStatusIdFk,
    required this.studentIdFk,
  });

  factory AttendanceListModel.fromJson(Map<String, dynamic> json) => AttendanceListModel(
    attendanceStatusIdFk: json["AttendanceStatusIdFk"],
    studentIdFk: json["StudentIdFk"],
  );

  Map<String, dynamic> toJson() => {
    "AttendanceStatusIdFk": attendanceStatusIdFk,
    "StudentIdFk": studentIdFk,
  };
}
