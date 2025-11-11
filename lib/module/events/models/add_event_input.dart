class AddEventInput {
  final int ucLoginUserId;
  final int ucEntityId;
  final String day;
  final int status;
  final String description;
  final int ucSchoolId;
  final int classIdFk;
  final int sectionIdFk;

  AddEventInput({
    required this.ucLoginUserId,
    required this.ucEntityId,
    required this.day,
    required this.status,
    required this.description,
    required this.ucSchoolId,
    required this.classIdFk,
    required this.sectionIdFk,
  });

  factory AddEventInput.fromJson(Map<String, dynamic> json) => AddEventInput(
    ucLoginUserId: json["UC_LoginUserId"],
    ucEntityId: json["UC_EntityId"],
    day: json["Day"],
    status: json["Status"],
    description: json["Description"],
    ucSchoolId: json["UC_SchoolId"],
    classIdFk: json["ClassIdFk"],
    sectionIdFk: json["SectionIdFk"],
  );

  Map<String, dynamic> toJson() => {
    "UC_LoginUserId": ucLoginUserId,
    "UC_EntityId": ucEntityId,
    "Day": day,
    "Status": status,
    "Description": description,
    "UC_SchoolId": ucSchoolId,
    "ClassIdFk": classIdFk,
    "SectionIdFk": sectionIdFk,
  };
}
