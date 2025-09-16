import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/auth/models/forget_password_input.dart';
import 'package:lges_teacher_app/module/auth/models/forget_password_response.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/base_resposne_model.dart';

import '../../../../core/api_result.dart';
import '../../../../core/failures/base_failures/base_failure.dart';
import '../../../../core/failures/high_priority_failure.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._repository) : super(ForgetPasswordState.initial());

  AuthRepository _repository;
  void toggleShowPassword() => emit(
    state.copyWith(
      isPasswordVisible: !state.isPasswordHidden,
      forgetPasswordStatus: ForgetPasswordStatus.none,
    ),
  );

  void enableAutoValidateMode() => emit(
    state.copyWith(
      isAutoValidate: true,
      forgetPasswordStatus: ForgetPasswordStatus.none,
    ),
  );

  Future forgetPassword(ForgetPasswordInput input) async {
    emit(state.copyWith(forgetPasswordStatus: ForgetPasswordStatus.loading));
    try {
      BaseResponseModel response =
          await _repository.forgetPassword(input);
      if (response.result == ApiResult.success) {
        emit(state.copyWith(
          forgetPasswordStatus: ForgetPasswordStatus.success,
        ));
      } else {
        emit(state.copyWith(
            forgetPasswordStatus: ForgetPasswordStatus.failure,
            failure: HighPriorityException(response.message)));
      }
    } on BaseFailure catch (e) {
      emit(state.copyWith(
          forgetPasswordStatus: ForgetPasswordStatus.failure,
          failure: HighPriorityException(e.message)));
    } catch (_) {}
  }
}
