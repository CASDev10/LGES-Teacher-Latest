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

class NotificationInput {
  int? ucLoginUserId;
  String? notificationText;
  String? notificationTitle;
  int? notificationTypeId;
  String? fileIds;
  String? studentIds;
  String? startDate;
  String? endDate;

  NotificationInput({
    required this.ucLoginUserId,
    required this.notificationText,
    required this.notificationTitle,
    required this.notificationTypeId,
    required this.fileIds,
    required this.studentIds,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
    'UC_LoginUserId': ucLoginUserId,
    'NotificationText': notificationText,
    'NotificationTitle': notificationTitle,
    'NotificationTypeId': notificationTypeId,
    'FileIds': fileIds, // Can be empty string ""
    'StudentIds': studentIds,
    'StartDate': startDate,
    'EndDate': endDate,
  };
}
