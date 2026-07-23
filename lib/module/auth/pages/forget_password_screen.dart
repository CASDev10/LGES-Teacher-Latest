import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/module/auth/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:lges_teacher_app/module/auth/cubit/forget_password_cubit/forget_password_state.dart';
import 'package:lges_teacher_app/module/auth/models/forget_password_input.dart';
import 'package:lges_teacher_app/module/auth/pages/login_screen.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/text_view.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../widget/password_suffix_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void _onForgetButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      ForgetPasswordInput input = ForgetPasswordInput(
        userId: userNameController.text.trim(),
        password: newPasswordController.text,
        userMobile: phoneNumberController.text.trim(),
      );
      context.read<ForgetPasswordCubit>().forgetPassword(input);
    } else {
      context.read<ForgetPasswordCubit>().enableAutoValidateMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state.forgetPasswordStatus == ForgetPasswordStatus.loading) {
            DisplayUtils.showLoader();
          } else if (state.forgetPasswordStatus ==
              ForgetPasswordStatus.success) {
            DisplayUtils.removeLoader();
            NavRouter.pushAndRemoveUntil(context, LoginScreen());
            Fluttertoast.showToast(msg: 'Password Change Successfully');
          } else if (state.forgetPasswordStatus ==
              ForgetPasswordStatus.failure) {
            DisplayUtils.removeLoader();
            DisplayUtils.showToast(context, state.failure.message);
          }
        },
        builder: (context, state) {
          return BaseScaffold(
            backgroundColor: AppColors.whiteColor,
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 90),
                    const TextView(
                      'Forget Password',
                      textAlign: TextAlign.center,
                      color: AppColors.primaryDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 245,
                      width: 330,
                      child: SvgPicture.asset(
                        "assets/images/svg/ic_login_screen.svg",
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      hintText: 'User Name',
                      inputType: TextInputType.emailAddress,
                      controller: userNameController,
                      fillColor: AppColors.lightGreyColor,
                      onValidate: (val) =>
                          ValidationUtils.validateUserName(val),
                    ),
                    const SizedBox(height: 4),
                    CustomTextField(
                      hintText: 'Password',
                      controller: newPasswordController,
                      fillColor: AppColors.lightGreyColor,
                      inputType: TextInputType.visiblePassword,
                      obscureText: state.isPasswordHidden,
                      onValidate: (val) =>
                          ValidationUtils.validatePassword(val),
                      suffixWidget: PasswordSuffixWidget(
                        isPasswordVisible: state.isPasswordHidden,
                        onTap: () {
                          context
                              .read<ForgetPasswordCubit>()
                              .toggleShowPassword();
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    CustomTextField(
                      hintText: 'Phone Number',
                      controller: phoneNumberController,
                      fillColor: AppColors.lightGreyColor,
                      inputType: TextInputType.visiblePassword,
                      obscureText: state.isPasswordHidden,
                      onValidate: (val) =>
                          ValidationUtils.validatePhoneNumber(val),
                    ),
                    const SizedBox(height: 44),
                    CustomButton(
                      height: 54,
                      title: 'Forget Password',
                      onPressed: () {
                        _onForgetButtonPressed();
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      hMargin: 0,
    );
  }
}
