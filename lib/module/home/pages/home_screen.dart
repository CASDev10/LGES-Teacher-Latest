import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
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
import 'package:lges_teacher_app/module/home/cubit/app_config_cubit/app_config_cubit.dart';
import 'package:lges_teacher_app/module/home/cubit/app_config_cubit/app_config_state.dart';
import 'package:lges_teacher_app/module/home/cubit/dashboard_state_cubit/dashboard_state_cubit.dart';
import 'package:lges_teacher_app/module/home/cubit/dashboard_state_cubit/dashboard_state_state.dart';
import 'package:lges_teacher_app/module/leaves/pages/leaves_screen.dart';
import 'package:lges_teacher_app/utils/display/dialogs/dialog_utils.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../chat/pages/conversation_screen.dart';
import '../../class_section/pages/class_section_screen.dart';
import '../../evaluation/cubit/evaluation_areas_cubit/evaluation_areas_cubit.dart';
import '../../evaluation/cubit/evaluation_areas_cubit/evaluation_areas_state.dart';
import '../../events/pages/events_screen.dart';
import '../../file_sharing/pages/file_sharing_screen.dart';
import '../../students_attendance/pages/attendance_filter_screen.dart';
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

  void _showAttendanceDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Title
                  const Text(
                    "Attendance Options",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    title: "Mark Attendance",
                    borderRadius: 12,
                    onPressed: () {
                      Navigator.pop(context);
                      _gotoAttendance();
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    title: "Attendance History",
                    borderRadius: 12,
                    onPressed: () {
                      Navigator.pop(context);
                      NavRouter.push(context, AttendanceFilterScreen());
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    title: "Cancel",
                    borderRadius: 12,
                    isOutlinedButton: true,
                    textColor: AppColors.primaryDark,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        BlocProvider(
          create: (context) => DashboardStateCubit(sl())..fetchDashboardStats(),
          lazy: false,
        ),
      ],
      child: BaseScaffold(
        hMargin: 0,
        body: BlocBuilder<AppConfigCubit, AppConfigState>(
          builder: (context, state) {
            if (state.appConfigStatus == AppConfigStatus.loading) {
              return Center(child: LoadingIndicator());
            } else if (state.appConfigStatus == AppConfigStatus.success) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container( 
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        bottom: 8,
                      ),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage(
                        //     "assets/images/png/bg_home_top_view.png",
                        //   ),
                        // ),
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
                                        _repository.user.fullName.toString(),
                                        textAlign: TextAlign.left,
                                        fontSize: 15,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      TextView(
                                        _repository.user.schoolName.toString(),
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
                            const SizedBox(height: 10),
                            BlocBuilder<DashboardStateCubit, DashboardStateState>(
                              builder: (context, dashboardState) {
                                if (dashboardState.dashboardStateStatus == DashboardStateStatus.loading) {
                                  return const SizedBox(
                                    height: 160,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  );
                                }

                                if (dashboardState.dashboardStateStatus == DashboardStateStatus.success && dashboardState.dashboardStats != null) {
                                  final stats = dashboardState.dashboardStats!;
                                  final studentStat = stats.studentAttendanceStatList != null && stats.studentAttendanceStatList!.isNotEmpty
                                      ? stats.studentAttendanceStatList!.first
                                      : null;
                                  final teacherStat = stats.employeeAtteandanceStatList != null && stats.employeeAtteandanceStatList!.isNotEmpty
                                      ? stats.employeeAtteandanceStatList!.first
                                      : null;

                                  if (studentStat != null || teacherStat != null) {
                                    return TodayStatsCard(
                                      studentPresent: studentStat?.presentCount ?? 0,
                                      studentAbsent: studentStat?.absentCount ?? 0,
                                      studentLeave: studentStat?.leaveCount ?? 0,
                                      teacherPresent: teacherStat?.presentCount ?? 0,
                                      teacherAbsent: teacherStat?.absentCount ?? 0,
                                      teacherLeave: teacherStat?.leaveCount ?? 0,
                                      studentTotal:studentStat?.totalStudent??0 ,
                                      teacherTotal: teacherStat?.totalEmployees??0,
                                      totalDiaries: dashboardState.dashboardStats?.diaryStatList?.first.diariesSent??0,
                                    );
                                  }
                                }

                                // Fallback UI (Logo) when data is null, empty, or failed
                                return Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/png/app_logo.png",
                                        height: 150,
                                        width: 150,
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showAttendanceDialog(context);
                                  },
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Attendance",
                                      "assets/images/svg/attendance2.svg",
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
                                    NavRouter.push(context, DailyDiaryScreen());
                                  },
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Daily Diary",
                                      "assets/images/svg/ic_daily_diary2.svg",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Student Evaluation",
                                      "assets/images/svg/ic_student_evaluation_tab2.svg",
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
                                    NavRouter.push(context, EventsScreen());
                                  },
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "EVENTS",
                                      "assets/images/svg/leaves1.svg",
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
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    NavRouter.push(context, ExamResultScreen());
                                  },
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Exam Result",
                                      "assets/images/svg/ic_exam_result1.svg",
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
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Notifications\n& Alerts",
                                      "assets/images/svg/notification_and_alert1.svg",
                                    ),
                                  ),
                                  onTap: () {
                                    NavRouter.push(
                                      context,
                                      const FileSharingScreen(),
                                    );
                                  },
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
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    NavRouter.push(
                                      context,
                                      ConversationsScreen(),
                                    );
                                  },
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Chat",
                                      "assets/images/svg/notification_and_alert1.svg",
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
                                  child: HomeTabCard(
                                    homeTabModel: HomeTabModel(
                                      "Leaves",
                                      "assets/images/svg/leaves1.svg",
                                    ),
                                  ),
                                  onTap: () {
                                    NavRouter.push(context, LeavesScreen());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
                                  DisplayUtils.showToast(
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
                                      DisplayUtils.showToast(
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
              : Image.asset(homeTabModel.imagePath, height: 120),
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

class TodayStatsCard extends StatelessWidget {
  final int studentPresent;
  final int studentAbsent;
  final int studentLeave;
  final int teacherPresent;
  final int teacherAbsent;
  final int teacherLeave;
  final int studentTotal;
  final int teacherTotal;
  final int totalDiaries;

  const TodayStatsCard({
    Key? key,
    required this.studentPresent,
    required this.studentAbsent,
    required this.studentLeave,
    required this.teacherPresent,
    required this.teacherAbsent,
    required this.teacherLeave,
    required this.studentTotal,
    required this.teacherTotal,
    required this.totalDiaries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with Icon, Title and Date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: AppColors.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Stats",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.darkGreyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 10),
             Text(
                      "Total Diaries: ${totalDiaries??0}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.2,
                      ),
                    ),
             ],
          ),
          const SizedBox(height: 8),
          // Subtle Divider
          Container(
            height: 1,
            color: AppColors.lightGreyColor,
          ),
          const SizedBox(height: 12),
          // Side-by-side Charts with a vertical divider
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MiniBarChart(
                  title: "Student Attendance Stats",
                  present: studentPresent,
                  absent: studentAbsent,
                  leave: studentLeave,
                  total: studentTotal,
                ),
              ),
              Container(
                width: 1,
                height: 130,
                color: AppColors.lightGreyColor,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: MiniBarChart(
                  title: "Staff Attendance Stats",
                  present: teacherPresent,
                  absent: teacherAbsent,
                  leave: teacherLeave,
                  total: teacherTotal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Divider before Legend
          Container(
            height: 1,
            color: AppColors.lightGreyColor,
          ),
          const SizedBox(height: 8),
          // Shared Legend at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFF2ECC71), "Present"),
              const SizedBox(width: 16),
              _buildLegendItem(const Color(0xFFE74C3C), "Absent"),
              const SizedBox(width: 16),
              _buildLegendItem(const Color(0xFFF39C12), "Leave"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreyColor,
          ),
        ),
      ],
    );
  }
}class MiniBarChart extends StatelessWidget {
  final String title;
  final int present;
  final int absent;
  final int leave;
  final int total;

  const MiniBarChart({
    Key? key,
    required this.title,
    required this.present,
    required this.absent,
    required this.leave,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double maxVal = [present, absent, leave].reduce((a, b) => a > b ? a : b).toDouble();
    final double maxY = maxVal > 0 ? maxVal * 1.3 : 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Total: $total",
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.greyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 4,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.toInt().toString(),
                      const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      String text = '';
                      switch (value.toInt()) {
                        case 0:
                          text = 'P';
                          break;
                        case 1:
                          text = 'A';
                          break;
                        case 2:
                          text = 'L';
                          break;
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 4,
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 18,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 8,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: (maxY / 4).clamp(1, double.infinity),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppColors.greyColor.withOpacity(0.5), width: 1),
                  bottom: BorderSide(color: AppColors.greyColor.withOpacity(0.5), width: 1),
                  top: BorderSide.none,
                  right: BorderSide.none,
                ),
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  showingTooltipIndicators: [0],
                  barRods: [
                    BarChartRodData(
                      toY: present.toDouble(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  showingTooltipIndicators: [0],
                  barRods: [
                    BarChartRodData(
                      toY: absent.toDouble(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  showingTooltipIndicators: [0],
                  barRods: [
                    BarChartRodData(
                      toY: leave.toDouble(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF39C12), Color(0xFFD35400)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}