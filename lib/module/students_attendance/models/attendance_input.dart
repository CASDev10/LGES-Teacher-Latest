


class AttendanceInput {
  String? sectionIdFk;
  String? classIdFk;
  String? attendanceDate;
  bool? isOnRollStudents;
  String? uCSchoolId;
  String? uCEntityId;

  AttendanceInput(
      {this.sectionIdFk,
        this.classIdFk,
        this.attendanceDate,
        this.isOnRollStudents,
        this.uCSchoolId,
        this.uCEntityId});

  AttendanceInput.fromJson(Map<String, dynamic> json) {
    sectionIdFk = json['SectionIdFk'];
    classIdFk = json['ClassIdFk'];
    attendanceDate = json['AttendanceDate'];
    isOnRollStudents = json['IsOnRollStudents'];
    uCSchoolId = json['UC_SchoolId'];
    uCEntityId = json['UC_EntityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SectionIdFk'] = this.sectionIdFk;
    data['ClassIdFk'] = this.classIdFk;
    data['AttendanceDate'] = this.attendanceDate;
    data['IsOnRollStudents'] = this.isOnRollStudents;
    data['UC_SchoolId'] = this.uCSchoolId;
    data['UC_EntityId'] = this.uCEntityId;
    return data;
  }
}