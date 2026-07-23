class LeaveTypeList {
  int entityLeaveTypeId;
  String leaveTypeName;

  LeaveTypeList({required this.entityLeaveTypeId, required this.leaveTypeName});

  factory LeaveTypeList.fromJson(Map<String, dynamic> json) => LeaveTypeList(
    entityLeaveTypeId: json["EntityLeaveTypeId"],
    leaveTypeName: json["LeaveTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "EntityLeaveTypeId": entityLeaveTypeId,
    "LeaveTypeName": leaveTypeName,
  };
}
