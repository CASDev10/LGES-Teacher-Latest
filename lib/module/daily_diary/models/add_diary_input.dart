
class AddDiaryInput {
  String dateFrom;
  String dateTo;
  String sectionIdFk;
  String classIdFk;
  String subjectIdFk;
  String text;
  String ucSchoolId;
  String ucLoginUserId;

  AddDiaryInput({
    required this.dateFrom,
    required this.dateTo,
    required this.sectionIdFk,
    required this.classIdFk,
    required this.subjectIdFk,
    required this.text,
    required this.ucSchoolId,
    required this.ucLoginUserId,
  });

  factory AddDiaryInput.fromJson(Map<String, dynamic> json) => AddDiaryInput(
    dateFrom: json["DateFrom"],
    dateTo: json["DateTo"],
    sectionIdFk: json["SectionIdFk"],
    classIdFk: json["ClassIdFk"],
    subjectIdFk: json["SubjectIdFk"],
    text: json["Text"],
    ucSchoolId: json["UC_SchoolId"],
    ucLoginUserId: json["UC_LoginUserId"],
  );

  Map<String, dynamic> toJson() => {
    "DateFrom": dateFrom,
    "DateTo": dateTo,
    "SectionIdFk": sectionIdFk,
    "ClassIdFk": classIdFk,
    "SubjectIdFk": subjectIdFk,
    "Text": text,
    "UC_SchoolId": ucSchoolId,
    "UC_LoginUserId": ucLoginUserId,
  };
}