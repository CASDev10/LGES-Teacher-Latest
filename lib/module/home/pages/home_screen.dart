import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/components/custom_dropdown.dart';
import 'package:lges_teacher_app/config/routes/nav_router.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/constants/app_data.dart';
import 'package:lges_teacher_app/constants/keys.dart';
import 'package:lges_teacher_app/module/auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:lges_teacher_app/module/auth/pages/login_screen.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/daily_diary/pages/daily_diary_screen.dart';
import 'package:lges_teacher_app/module/evaluation/models/student_evaluation_areas_input.dart';
import 'package:lges_teacher_app/module/evaluation/pages/student_evaluation_screen.dart';
import 'package:lges_teacher_app/module/exam_result/pages/exam_result_screen.dart';
import 'package:lges_teacher_app/module/exam_result/pages/process_result_screen.dart';
import 'package:lges_teacher_app/module/exam_result/pages/show_result_screen.dart';
import 'package:lges_teacher_app/module/home/app_config_cubit/app_config_cubit.dart';
import 'package:lges_teacher_app/module/home/app_config_cubit/app_config_state.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/submit_observation_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/teacher_observation_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/teacher_remarks_screen.dart';
import 'package:lges_teacher_app/utils/display/dialogs/dialog_utils.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../auth/models/auth_response.dart';
import '../../auth/models/user_schools_model.dart';
import '../../class_section/pages/class_section_screen.dart';
import '../../evaluation/cubit/evaluation_areas_cubit/evaluation_areas_cubit.dart';
import '../../evaluation/cubit/evaluation_areas_cubit/evaluation_areas_state.dart';
import '../../evaluation/cubit/evaluation_remarks_cubit/evaluation_remarks_cubit.dart';
import '../repo/home_repo.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthRepository _repository = sl<AuthRepository>();
  String? dropdownValueCampuses;

  List<String> campusesDropDownItems = [];
  List<String> userPrivileges = [];
  HomeRepository homeRepository = sl<HomeRepository>();
  TextEditingController studentIdTextController = TextEditingController();

  @override
  void initState() {
    print(_repository.user.toJson());
    super.initState();
    if (_repository.user.userPrivileges?.isNotEmpty == true) {
      userPrivileges = _repository.user.userPrivileges.toString().split(',');
    }
  }

  void _gotoAttendance() {
    if (userPrivileges.isNotEmpty) {
      bool exists = false;
      for (var i = 0; i < userPrivileges.length; i++) {
        if (userPrivileges[i].toInt() == StorageKeys.loadAttendanceId) {
          exists = true;
          break;
        } else {
          exists = false;
        }
      }
      if (exists) {
        NavRouter.push(context, ClassSectionScreen());
      } else {
        Fluttertoast.showToast(msg: "You are not allowed to mark Attendance!");
      }
    } else {
      Fluttertoast.showToast(msg: "You are not allowed to mark Attendance!");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppConfigCubit(sl())..getAppConfig()),
      ],
      child: BaseScaffold(
        hMargin: 0,
        body: BlocBuilder<AppConfigCubit, AppConfigState>(
          builder: (context, state) {
            if (state.appConfigStatus == AppConfigStatus.loading) {
              return Center(child: LoadingIndicator());
            } else if (state.appConfigStatus == AppConfigStatus.success) {
              return SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 351,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/png/bg_home_top_view.png",
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/svg/ic_profile.svg",
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextView(
                                            _repository.user.fullName
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            fontSize: 15,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          TextView(
                                            _repository.user.schoolName
                                                .toString(),
                                            textAlign: TextAlign.left,
                                            fontSize: 11,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.logout,
                                        color: AppColors.whiteColor,
                                      ),
                                      onPressed: () {
                                        DialogUtils.confirmationDialog(
                                          context: context,
                                          title: 'Confirmation!',
                                          content:
                                              'Are you sure you want to logout from the app?',
                                          onPressYes: () {
                                            context.read<AuthCubit>()..logout();
                                            NavRouter.pushAndRemoveUntil(
                                              context,
                                              LoginScreen(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    height: 150,
                                    "assets/images/png/app_logo.png",
                                    width: 150,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextView(
                                      "Our services".toUpperCase(),
                                      color: AppColors.primaryDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextView(
                                          "see all".toUpperCase(),
                                          textAlign: TextAlign.end,
                                          color: AppColors.darkGreyColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 5),
                                        SvgPicture.asset(
                                          "assets/images/svg/ic_forward_arrow.svg",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _gotoAttendance();
                                      },
                                      child: HomeTabCard(
                                        isSvg: false,
                                        homeTabModel: HomeTabModel(
                                          "Attendance",
                                          "assets/images/png/attendance.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: AppColors.dividerColor,
                                    height: 200,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        NavRouter.push(
                                          context,
                                          DailyDiaryScreen(),
                                        );
                                      },
                                      child: HomeTabCard(
                                        homeTabModel: HomeTabModel(
                                          "Daily Diary",
                                          "assets/images/svg/ic_daily_diary.svg",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                color: AppColors.dividerColor,
                                height: 1,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      child: HomeTabCard(
                                        homeTabModel: HomeTabModel(
                                          "Student Evaluation",
                                          "assets/images/svg/ic_student_evaluation_tab.svg",
                                        ),
                                      ),
                                      onTap: () {
                                        showStudentEvaluationAreas(context);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: AppColors.dividerColor,
                                    height: 200,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        DisplayUtils.showToast(
                                          context,
                                          'Coming Soon',
                                        );
                                      },
                                      child: HomeTabCard(
                                        homeTabModel: HomeTabModel(
                                          "TIME TABLE",
                                          "assets/images/svg/ic_time_table.svg",
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: GestureDetector(
                                  //     child: HomeTabCard(
                                  //       homeTabModel: HomeTabModel(
                                  //         "Teacher Observation",
                                  //         "assets/images/svg/ic_teacher_observation.svg",
                                  //       ),
                                  //     ),
                                  //     onTap: () {
                                  //       NavRouter.push(
                                  //         context,
                                  //         TeacherObservationScreen(),
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                color: AppColors.dividerColor,
                                height: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavRouter.push(context, ExamResultScreen());
                                },
                                child: HomeTabCard(
                                  homeTabModel: HomeTabModel(
                                    "Exam Result",
                                    "assets/images/svg/ic_exam_result.svg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state.appConfigStatus == AppConfigStatus.failure) {
              return Center(child: Text(state.failure.message));
            }

            return SizedBox();
          },
        ),
      ),
    );
  }

  void showStudentEvaluationAreas(
    BuildContext context, {
    void Function(bool val)? onButtonPressYes,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: Container(
            height: 240,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextView(
                    'Enter Student ID',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(height: 1, color: AppColors.dividerColor),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CustomTextField(
                    hintText: 'Student ID',
                    height: 50,
                    bottomMargin: 0,
                    controller: studentIdTextController,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    inputType: TextInputType.number,
                    fillColor: AppColors.lightGreyColor,
                    hintColor: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        child: CustomButton(
                          isOutlinedButton: true,
                          onPressed: () {
                            NavRouter.pop(context);
                          },
                          width: 80,
                          title: 'Close',
                          fontSize: 14,
                          height: 45,
                          textColor: AppColors.primaryDark,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child:
                            BlocConsumer<
                              EvaluationAreasCubit,
                              EvaluationAreasState
                            >(
                              listener: (context, evaluationAreasState) {
                                if (evaluationAreasState
                                        .evaluationAreasStatus ==
                                    EvaluationAreasStatus.loading) {
                                  DisplayUtils.showLoader();
                                } else if (evaluationAreasState
                                        .evaluationAreasStatus ==
                                    EvaluationAreasStatus.success) {
                                  DisplayUtils.removeLoader();
                                  NavRouter.pop(context);
                                  NavRouter.push(
                                    context,
                                    StudentEvaluationScreen(
                                      studentEvaluationAreaModel:
                                          evaluationAreasState.evaluationAreas!,
                                      studentId: studentIdTextController.text
                                          .trim(),
                                    ),
                                  );
                                } else if (evaluationAreasState
                                        .evaluationAreasStatus ==
                                    EvaluationAreasStatus.failure) {
                                  DisplayUtils.removeLoader();
                                  DisplayUtils.showSnackBar(
                                    context,
                                    evaluationAreasState.failure.message,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  onPressed: () {
                                    if (studentIdTextController.text
                                        .trim()
                                        .isNotEmpty) {
                                      context.read<EvaluationAreasCubit>()
                                        ..fetchEvaluationAreas(
                                          StudentEvaluationAreasInput(
                                            studentIdfK: studentIdTextController
                                                .text
                                                .trim()
                                                .toString(),
                                          ),
                                        );
                                    } else {
                                      DisplayUtils.showSnackBar(
                                        context,
                                        "Enter student ID",
                                      );
                                    }
                                  },
                                  width: 80,
                                  fontSize: 14,
                                  title: 'Submit',
                                  height: 45,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeTabCard extends StatelessWidget {
  final HomeTabModel homeTabModel;
  final bool isSvg;

  const HomeTabCard({Key? key, required this.homeTabModel, this.isSvg = true})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          isSvg
              ? SvgPicture.asset(
                  homeTabModel.imagePath,
                  height: 120,
                  width: double.infinity,
                )
              : Image.asset(homeTabModel.imagePath),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/png/bg_home_tabs.png"),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                homeTabModel.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
