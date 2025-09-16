


class SubjectsInput {
  String ucEntityId;
  String ucSchoolId;
  String classIdFk;

  SubjectsInput({
    required this.ucEntityId,
    required this.ucSchoolId,
    required this.classIdFk,
  });

  factory SubjectsInput.fromJson(Map<String, dynamic> json) =>
      SubjectsInput(
        ucEntityId: json["UC_EntityId"],
        ucSchoolId: json["UC_SchoolId"],
        classIdFk: json["ClassIdFk"],
      );

  Map<String, dynamic> toJson() => {
        "UC_EntityId": ucEntityId,
        "UC_SchoolId": ucSchoolId,
        "ClassIdFk": classIdFk,
      };
}
