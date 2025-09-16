// To parse this JSON data, do
//
//     final forgetPasswordInput = forgetPasswordInputFromJson(jsonString);

import 'dart:convert';

class ForgetPasswordInput {
  String userId;
  String password;
  String userMobile;

  ForgetPasswordInput({
    required this.userId,
    required this.password,
    required this.userMobile,
  });

  factory ForgetPasswordInput.fromJson(Map<String, dynamic> json) => ForgetPasswordInput(
    userId: json["UserId"],
    password: json["Password"],
    userMobile: json["UserMobile"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "Password": password,
    "UserMobile": userMobile,
  };
}
