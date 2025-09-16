import 'package:dio/dio.dart';

class LoginInput {
  final String username;
  final String password;

  LoginInput({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "UserId": username,
        "Password": password,
      };

  FormData toFormData() => FormData.fromMap({
        "UserId": username,
        "Password": password,
      });
}
