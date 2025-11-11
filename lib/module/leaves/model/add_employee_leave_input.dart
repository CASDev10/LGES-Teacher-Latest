class AddEmployeeLeaveInput {
  int id;
  int ucEntityId;
  int empId;
  int entityLeaveTypeId;
  String fromDate;
  String toDate;
  int days;
  String reason;
  int ucLoginUserId;
  String leaveSponsorship;

  AddEmployeeLeaveInput({
    required this.id,
    required this.ucEntityId,
    required this.empId,
    required this.entityLeaveTypeId,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.reason,
    required this.ucLoginUserId,
    required this.leaveSponsorship,
  });

  Map<String, dynamic> toJson() => {
    "ID": id,
    "UC_EntityId": ucEntityId,
    "EmpId": empId,
    "EntityLeaveTypeId": entityLeaveTypeId,
    "FromDate": fromDate,
    "ToDate": toDate,
    "Days": days,
    "Reason": reason,
    "UC_LoginUserId": ucLoginUserId,
    "LeaveSponsorship": leaveSponsorship,
  };
}
