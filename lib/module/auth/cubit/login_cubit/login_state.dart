part of 'login_cubit.dart';

enum LoginStatus { none, submitting, success, failure }

class LoginState {
  final LoginStatus loginStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final BaseFailure failure;

  LoginState({
    required this.loginStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.failure,
  });

  factory LoginState.initial() {
    return LoginState(
      loginStatus: LoginStatus.none,
      isPasswordHidden: true,
      isAutoValidate: false,
      failure: const BaseFailure(),
    );
  }

  LoginState copyWith({
    LoginStatus? loginStatus,
    bool? isPasswordVisible,
    bool? isAutoValidate,
    BaseFailure? failure,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      isPasswordHidden: isPasswordVisible ?? isPasswordHidden,
      isAutoValidate: isAutoValidate ?? this.isAutoValidate,
      failure: failure ?? this.failure,
    );
  }
}
