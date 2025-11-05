import 'package:dio/dio.dart';

class FileSharingInput {
  String? description;
  String? classId;
  String? sectionId;
  MultipartFile? file;

  FileSharingInput({
    required this.description,
    required this.classId,
    required this.sectionId,
    this.file,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'classId': classId,
        'sectionId': sectionId,
      };
}
