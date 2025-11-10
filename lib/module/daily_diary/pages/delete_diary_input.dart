class DeleteDiaryInput {
  int diaryId;
  String ucSchoolId;
  String ucLoginUserId;

  DeleteDiaryInput({
    required this.diaryId,
    required this.ucSchoolId,
    required this.ucLoginUserId,
  });

  factory DeleteDiaryInput.fromJson(Map<String, dynamic> json) =>
      DeleteDiaryInput(
        diaryId: json["DiaryId"],
        ucSchoolId: json["UC_SchoolId"],
        ucLoginUserId: json["UC_LoginUserId"],
      );

  Map<String, dynamic> toJson() => {
    "DiaryId": diaryId,
    "UC_SchoolId": ucSchoolId,
    "UC_LoginUserId": ucLoginUserId,
  };
}
