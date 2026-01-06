import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/components/custom_dropdown.dart';
import 'package:lges_teacher_app/components/custom_textfield.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/config/routes/nav_router.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/cubit/user_schools_cubit/user_schools_cubit.dart';
import 'package:lges_teacher_app/module/auth/pages/forget_password_screen.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/campus/pages/campuses_screen.dart';
import 'package:lges_teacher_app/module/home/pages/home_screen.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../cubit/login_cubit/login_cubit.dart';
import '../models/auth_response.dart';
import '../models/login_input.dart';
import '../models/user_schools_model.dart';
import '../widget/password_suffix_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isKeepMeLoggedIn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  String? dropdownValueCampuses;

  List<String> campusesDropDownItems = [];

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      LoginInput loginInput = LoginInput(
        username: emailController.text.trim(),
        password: passwordController.text,
      );
      context.read<LoginCubit>().login(loginInput, isKeepMeLoggedIn);
    } else {
      context.read<LoginCubit>().enableAutoValidateMode();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  List<String> generateSchoolsList(List<UserSchool> userSchool) {
    List<String> schoolsList = [];
    for (var student in userSchool) {
      schoolsList.add(student.schoolName);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSchoolsCubit(sl()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.submitting) {
            DisplayUtils.showLoader();
          } else if (state.loginStatus == LoginStatus.success) {
            DisplayUtils.removeLoader();
            AuthRepository authRepository = sl<AuthRepository>();
            print(authRepository.user.userId);
            print(authRepository.user.entityId);
            NavRouter.pushAndRemoveUntil(context, HomeScreen());
            Fluttertoast.showToast(msg: 'Logged in Successfully');
          } else if (state.loginStatus == LoginStatus.failure) {
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
                    const TextView('Login Account',
                        textAlign: TextAlign.center,
                        color: AppColors.primaryDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                    const SizedBox(height: 14),
                    const TextView('Hello, Welcome Back',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey4),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 245,
                      width: 330,
                      child: SvgPicture.asset(
                          "assets/images/svg/ic_login_screen.svg"),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      hintText: 'User Name',
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      fillColor: AppColors.lightGreyColor,
                      onValidate: (val) =>
                          ValidationUtils.validateUserName(val),
                    ),
                    const SizedBox(height: 4),
                    CustomTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      fillColor: AppColors.lightGreyColor,
                      inputType: TextInputType.visiblePassword,
                      obscureText: state.isPasswordHidden,
                      onValidate: (val) =>
                          ValidationUtils.validatePassword(val),
                      suffixWidget: PasswordSuffixWidget(
                        isPasswordVisible: state.isPasswordHidden,
                        onTap: () {
                          context.read<LoginCubit>().toggleShowPassword();
                        },
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          child: TextButton(
                            onPressed: () {
                              NavRouter.push(context, ForgetPasswordScreen());
                            },
                            child: TextView(
                              'Forget password ?',
                              fontSize: 14,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          right: 0,
                          top: -18,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isKeepMeLoggedIn = !isKeepMeLoggedIn;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColors.lightGreyColor),
                                    color: AppColors.lightGreyColor),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: isKeepMeLoggedIn
                                        ? AppColors.primaryDark
                                        : Colors.transparent,
                                    size: 20,
                                  ),
                                ),
                                height: 28,
                                width: 28,
                                margin: EdgeInsets.only(left: 5),
                              ),
                              const SizedBox(width: 12),
                              const TextView(
                                'Remember me',
                                fontSize: 14,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 44),
                    CustomButton(
                      height: 54,
                      title: 'Login',
                      onPressed: () {
                        _onLoginButtonPressed();
                        //_showCampusesDialog();
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
    );
  }
}
