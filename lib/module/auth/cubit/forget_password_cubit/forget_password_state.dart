

import '../../../../core/failures/base_failures/base_failure.dart';

enum ForgetPasswordStatus {
  none,
  loading,
  success,
  failure,
}

class ForgetPasswordState {
  final ForgetPasswordStatus forgetPasswordStatus;
  final bool isPasswordHidden;
  final bool isAutoValidate;
  final BaseFailure failure;

  ForgetPasswordState({
    required this.forgetPasswordStatus,
    required this.isPasswordHidden,
    required this.isAutoValidate,
    required this.failure,
  });

  factory ForgetPasswordState.initial() {
    return ForgetPasswordState(
        forgetPasswordStatus: ForgetPasswordStatus.none,
        isPasswordHidden: true,
        isAutoValidate: false,
        failure: const BaseFailure()
    );
  }

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? forgetPasswordStatus,
    bool? isPasswordVisible,
    bool? isAutoValidate,
    BaseFailure? failure,
  }) {
    return ForgetPasswordState(
        forgetPasswordStatus: forgetPasswordStatus ?? this.forgetPasswordStatus,
        isPasswordHidden: isPasswordVisible ?? isPasswordHidden,
        isAutoValidate: isAutoValidate ?? this.isAutoValidate,
        failure: failure ?? this.failure
    );
  }
}