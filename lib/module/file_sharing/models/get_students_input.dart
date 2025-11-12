class GetStudentInput {
  String statusId;
  String uCSchoolId;
  String uCEntityId;

  GetStudentInput({
    required this.statusId,
    required this.uCSchoolId,
    required this.uCEntityId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusId'] = this.statusId;
    data['UC_SchoolId'] = this.uCSchoolId;
    data['UC_EntityId'] = this.uCEntityId;
    return data;
  }
}
