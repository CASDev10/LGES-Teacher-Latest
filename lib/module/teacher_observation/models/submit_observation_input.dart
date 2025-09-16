
class SubmitObservationInput {
  int empId;
  String submitDate;
  int levelIdFk;
  String feedBack;
  List<AreaRemark> areaRemarks;
  int ucLoginUserId;
  String ucUserFullName;
  int ucEntityId;
  int ucSchoolId;

  SubmitObservationInput({
    required this.empId,
    required this.submitDate,
    required this.levelIdFk,
    required this.feedBack,
    required this.areaRemarks,
    required this.ucLoginUserId,
    required this.ucUserFullName,
    required this.ucEntityId,
    required this.ucSchoolId,
  });

  factory SubmitObservationInput.fromJson(Map<String, dynamic> json) => SubmitObservationInput(
    empId: json["EmpId"],
    submitDate: json["SubmitDate"],
    levelIdFk: json["LevelIdFk"],
    feedBack: json["FeedBack"],
    areaRemarks: List<AreaRemark>.from(json["AreaRemarks"].map((x) => AreaRemark.fromJson(x))),
    ucLoginUserId: json["UC_LoginUserId"],
    ucUserFullName: json["UC_UserFullName"],
    ucEntityId: json["UC_EntityId"],
    ucSchoolId: json["UC_SchoolId"],
  );

  Map<String, dynamic> toJson() => {
    "EmpId": empId,
    "SubmitDate": submitDate,
    "LevelIdFk": levelIdFk,
    "FeedBack": feedBack,
    "AreaRemarks": List<dynamic>.from(areaRemarks.map((x) => x.toJson())),
    "UC_LoginUserId": ucLoginUserId,
    "UC_UserFullName": ucUserFullName,
    "UC_EntityId": ucEntityId,
    "UC_SchoolId": ucSchoolId,
  };
}

class AreaRemark {
  int areaId;
  int remarksId;

  AreaRemark({
    required this.areaId,
    required this.remarksId,
  });

  factory AreaRemark.fromJson(Map<String, dynamic> json) => AreaRemark(
    areaId: json["AreaId"],
    remarksId: json["RemarksId"],
  );

  Map<String, dynamic> toJson() => {
    "AreaId": areaId,
    "RemarksId": remarksId,
  };
}
