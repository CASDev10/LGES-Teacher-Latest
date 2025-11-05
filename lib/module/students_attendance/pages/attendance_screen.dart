import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/h_padding.dart';
import 'package:lges_teacher_app/components/loading_indicator.dart';
import 'package:lges_teacher_app/components/search_textfield.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/core/di/service_locator.dart';
import 'package:lges_teacher_app/module/home/repo/home_repo.dart';
import 'package:lges_teacher_app/module/students_attendance/cubit/student_attendance_cubit/student_attendance_cubit.dart';
import 'package:lges_teacher_app/module/students_attendance/cubit/submit_attendance_cubit/submit_attendance_cubit.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_reponse.dart';
import 'package:lges_teacher_app/module/students_attendance/models/submit_attendance_input.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/custom_button.dart';
import '../../../constants/keys.dart';
import '../../../utils/display/display_utils.dart';
import '../../auth/repo/auth_repository.dart';
import '../cubit/student_attendance_cubit/student_attendance_state.dart';
import '../widget/attendance_tile.dart';

class AttendanceScreen extends StatefulWidget {
  final AttendanceInput attendanceInput;

  const AttendanceScreen({super.key, required this.attendanceInput});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  HomeRepository homeRepository = sl<HomeRepository>();
  List<AttendanceModel> filterStudentAttendanceList = [];
  List<AttendanceModel> studentAttendanceList = [];
  AuthRepository authRepository = sl<AuthRepository>();
  List<String> userPrivileges = [];

  @override
  void initState() {
    super.initState();
    if (authRepository.user.userPrivileges?.isNotEmpty == true) {
      userPrivileges = authRepository.user.userPrivileges.toString().split(',');
    }
  }

  bool canSubmitAttendance() {
    if (userPrivileges.isNotEmpty) {
      bool exists = false;
      for (var i = 0; i < userPrivileges.length; i++) {
        if (userPrivileges[i].toInt() == StorageKeys.addAttendanceId) {
          exists = true;
          break;
        } else {
          exists = false;
        }
      }
      return exists;
    } else {
      Fluttertoast.showToast(msg: "You are not allowed to add attendance!");
      return false;
    }
  }

  bool isAttendanceTimeRemaining() {
    List<String> startTimeString = homeRepository
        .appConfigModel
        .attendanceTime
        .first
        .attendanceStartTime
        .split(":");
    List<String> endTimeString = homeRepository
        .appConfigModel
        .attendanceTime
        .first
        .attendanceEndTime
        .split(":");
    int startTimeHours = int.parse(startTimeString[0]);
    int startTimeMinutes = int.parse(startTimeString[1]);

    int endTimeHours = int.parse(endTimeString[0]);
    int endTimeMinutes = int.parse(endTimeString[1]);
    // Create a TimeOfDay object
    TimeOfDay startTime = TimeOfDay(
      hour: startTimeHours,
      minute: startTimeMinutes,
    );
    TimeOfDay endTime = TimeOfDay(hour: endTimeHours, minute: endTimeMinutes);

    DateTime currentDateTime = DateTime.now();
    DateTime startDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      startTime.hour,
      startTime.minute,
    );

    DateTime endDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      endTime.hour,
      endTime.minute,
    );
    bool isBetween =
        currentDateTime.isAfter(startDateTime) &&
        currentDateTime.isBefore(endDateTime);
    return isBetween;
  }

  SubmitAttendanceInput _onSubmitButtonPressed() {
    Attendance attendance = Attendance(
      classIdFk: widget.attendanceInput.classIdFk.toString(),
      schoolIdFk: authRepository.user.schoolId.toString(),
      sectionIdFk: widget.attendanceInput.sectionIdFk.toString(),
      attendanceDate: widget.attendanceInput.attendanceDate.toString(),
    );
    List<AttendanceListModel> attendanceList = [];
    for (var i = 0; i < studentAttendanceList.length; i++) {
      AttendanceListModel attendanceListModel = AttendanceListModel(
        attendanceStatusIdFk: studentAttendanceList[i].attendanceStatusIdFk
            .toString(),
        studentIdFk: studentAttendanceList[i].studentId.toString(),
      );
      attendanceList.add(attendanceListModel);
    }
    SubmitAttendanceInput submitAttendanceInput = SubmitAttendanceInput(
      ucEntityId: authRepository.user.entityId.toString(),
      ucLoginUserId: authRepository.user.userId.toString(),
      attendance: attendance,
      attendanceList: attendanceList,
    );
    return submitAttendanceInput;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d, MMMM yyyy').format(now);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StudentAttendanceCubit(sl())
                ..fetchStudentAttendanceList(widget.attendanceInput),
        ),
        BlocProvider(create: (context) => SubmitAttendanceCubit(sl())),
      ],
      child: BaseScaffold(
        appBar: const CustomAppbar('Attendance', centerTitle: true),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
            builder: (context, state) {
              if (state.studentAttendanceStatus ==
                  StudentAttendanceStatus.loading) {
                return Center(child: LoadingIndicator());
              } else if (state.studentAttendanceStatus ==
                  StudentAttendanceStatus.success) {
                studentAttendanceList = List.from(state.attendanceList)
                  ..sort(
                    (a, b) => a.studentName.toLowerCase().compareTo(
                      b.studentName.toLowerCase(),
                    ),
                  );

                filterStudentAttendanceList = List.from(studentAttendanceList);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20) +
                      const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: TextView(
                              "Attendance",
                              color: AppColors.primaryDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/svg/ic_calendar.svg",
                                ),
                                const SizedBox(width: 5),
                                TextView(
                                  formattedDate,
                                  textAlign: TextAlign.end,
                                  color: AppColors.darkGreyColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SearchTextField(
                        hint: "Search Student",
                        readOnly: false,
                        onValueChange: (String value) {
                          context
                              .read<StudentAttendanceCubit>()
                              .filterSearchResults(value);
                        },
                      ).hPadding(padding: 10),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.lightGreyColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryDark,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Expanded(
                                      flex: 2,
                                      child: TextView(
                                        "Student List",
                                        textAlign: TextAlign.start,
                                        color: AppColors.whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextView(
                                        "Absent",
                                        textAlign: TextAlign.center,
                                        color: AppColors.whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextView(
                                        "Present",
                                        textAlign: TextAlign.center,
                                        color: AppColors.whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextView(
                                        "Leave",
                                        textAlign: TextAlign.center,
                                        color: AppColors.whiteColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: filterStudentAttendanceList.isNotEmpty
                                      ? ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          itemCount: filterStudentAttendanceList
                                              .length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return AttendanceTile(
                                              attendanceModel:
                                                  filterStudentAttendanceList[index],
                                              index: index + 1,
                                              onSelect: (studentStatus, studentId) {
                                                final index =
                                                    studentAttendanceList
                                                        .indexWhere(
                                                          (element) =>
                                                              element
                                                                  .studentId ==
                                                              studentId,
                                                        );
                                                studentAttendanceList[index]
                                                        .attendanceStatusIdFk =
                                                    studentStatus;
                                              },
                                            );
                                          },
                                          separatorBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                return SizedBox(height: 20);
                                              },
                                        )
                                      : Center(
                                          child: TextView(
                                            "No results found",
                                            fontSize: 24,
                                            color: AppColors.greyColor,
                                          ),
                                        ),
                                ),
                              ),
                              BlocConsumer<
                                SubmitAttendanceCubit,
                                SubmitAttendanceState
                              >(
                                listener: (context, state) {
                                  if (state.submitAttendanceStatus ==
                                      SubmitAttendanceStatus.loading) {
                                    DisplayUtils.showLoader();
                                  } else if (state.submitAttendanceStatus ==
                                      SubmitAttendanceStatus.success) {
                                    DisplayUtils.removeLoader();
                                    Fluttertoast.showToast(
                                      msg: "Attendance submitted successfully!",
                                    );
                                    NavRouter.pop(context);
                                  } else if (state.submitAttendanceStatus ==
                                      SubmitAttendanceStatus.failure) {
                                    DisplayUtils.removeLoader();
                                    DisplayUtils.showSnackBar(
                                      context,
                                      state.failure.message,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: CustomButton(
                                      height: 50,
                                      borderRadius: 10,
                                      onPressed: () {
                                        if (canSubmitAttendance()) {
                                          if (isAttendanceTimeRemaining()) {
                                            SubmitAttendanceInput
                                            submitAttendanceInput =
                                                _onSubmitButtonPressed();
                                            print(
                                              submitAttendanceInput.toJson(),
                                            );
                                            context
                                                .read<SubmitAttendanceCubit>()
                                                .submitAttendance(
                                                  submitAttendanceInput,
                                                );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Attendance time is over!",
                                            );
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "You are not allowed to add attendance!",
                                          );
                                        }
                                      },
                                      title: 'Submit',
                                      isEnabled: true,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state.studentAttendanceStatus ==
                  StudentAttendanceStatus.failure) {
                return Center(child: Text(state.failure.message));
              }
              return SizedBox();
            },
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }
}
