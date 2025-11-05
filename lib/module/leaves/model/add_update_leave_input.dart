import 'package:dio/dio.dart';

import '../../../../core/di/service_locator.dart';
import '../../auth/repo/auth_repository.dart';

class AddUpdateLeaveInput {
  int id;
  int entityLeaveTypeId;
  String fromDate;
  String toDate;
  String reason;
  int days;
  MultipartFile? file;
  final AuthRepository _authRepository = sl<AuthRepository>();

  AddUpdateLeaveInput({
    required this.id,
    required this.entityLeaveTypeId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    this.file,
    required this.days,
  });

  AddUpdateLeaveInput copyWith({
    int? id,
    int? entityLeaveTypeId,
    String? fromDate,
    String? toDate,
    String? reason,
    int? days,
    MultipartFile? file,
  }) => AddUpdateLeaveInput(
    id: id ?? this.id,
    entityLeaveTypeId: entityLeaveTypeId ?? this.entityLeaveTypeId,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    reason: reason ?? this.reason,
    days: days ?? this.days,
    file: file ?? this.file,
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "UC_EntityId": _authRepository.user.entityId,
    "EntityLeaveTypeId": entityLeaveTypeId,
    "FromDate": fromDate,
    "ToDate": toDate,
    "Reason": reason,
    "EmpId": _authRepository.user.userId,
    "Days": days,
    "UC_LoginUserId": _authRepository.user.userId,
    "Approved": "false",
  };
}
