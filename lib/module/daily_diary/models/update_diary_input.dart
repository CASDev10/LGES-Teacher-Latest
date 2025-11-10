import 'package:dio/dio.dart';

class UpdateDiaryInput {
  int diaryId;
  String text;
  String ucSchoolId;
  String ucLoginUserId;
  MultipartFile? file;

  UpdateDiaryInput({
    required this.diaryId,
    required this.text,
    required this.ucSchoolId,
    required this.ucLoginUserId,
    this.file,
  });

  factory UpdateDiaryInput.fromJson(Map<String, dynamic> json) =>
      UpdateDiaryInput(
        diaryId: json["DiaryId"],
        text: json["Text"],
        ucSchoolId: json["UC_SchoolId"],
        ucLoginUserId: json["UC_LoginUserId"],
      );

  Map<String, dynamic> toJson() => {
    "DiaryId": diaryId,
    "Text": text,
    "UC_SchoolId": ucSchoolId,
    "UC_LoginUserId": ucLoginUserId,
  };
}
