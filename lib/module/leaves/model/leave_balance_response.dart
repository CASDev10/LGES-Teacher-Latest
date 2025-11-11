import 'dart:convert';

LeaveBalanceResponse leaveBalanceResponseFromJson(dynamic json) =>
    LeaveBalanceResponse.fromJson(json);

String leaveBalanceResponseToJson(LeaveBalanceResponse data) =>
    json.encode(data.toJson());

class LeaveBalanceResponse {
  String result;
  String message;
  List<LeaveModel> data;

  LeaveBalanceResponse({
    required this.result,
    required this.message,
    required this.data,
  });

  LeaveBalanceResponse copyWith({
    String? result,
    String? message,
    List<LeaveModel>? data,
  }) => LeaveBalanceResponse(
    result: result ?? this.result,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory LeaveBalanceResponse.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceResponse(
        result: json["result"],
        message: json["message"],
        data: List<LeaveModel>.from(
          json["data"].map((x) => LeaveModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaveModel {
  int leaveTypeId;
  int balance;
  String leaveTypeName;
  String validFromDate;
  String validToDate;

  LeaveModel({
    required this.leaveTypeId,
    required this.balance,
    required this.leaveTypeName,
    required this.validFromDate,
    required this.validToDate,
  });

  LeaveModel copyWith({
    int? leaveTypeId,
    int? balance,
    String? leaveTypeName,
    String? validFromDate,
    String? validToDate,
  }) => LeaveModel(
    leaveTypeId: leaveTypeId ?? this.leaveTypeId,
    balance: balance ?? this.balance,
    leaveTypeName: leaveTypeName ?? this.leaveTypeName,
    validFromDate: validFromDate ?? this.validFromDate,
    validToDate: validToDate ?? this.validToDate,
  );

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
    leaveTypeId: json["LeaveTypeId"],
    balance: json["BalanceLeaves"],
    leaveTypeName: json["Name"],
    validFromDate: json["ValidLeaveFrom"],
    validToDate: json["ValidLeaveTo"],
  );

  Map<String, dynamic> toJson() => {
    "LeaveTypeId": leaveTypeId,
    "BalanceLeaves": balance,
    "Name": leaveTypeName,
    "ValidLeaveFrom": validFromDate,
    "ValidLeaveTo": validToDate,
  };
}
