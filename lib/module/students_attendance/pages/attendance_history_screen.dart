import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/loading_indicator.dart';
import 'package:lges_teacher_app/components/search_textfield.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/core/di/service_locator.dart';
import 'package:lges_teacher_app/module/home/repo/home_repo.dart';
import 'package:lges_teacher_app/module/students_attendance/cubit/student_attendance_cubit/student_attendance_cubit.dart';
import 'package:lges_teacher_app/module/students_attendance/cubit/submit_attendance_cubit/submit_attendance_cubit.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_reponse.dart';

import '../cubit/student_attendance_cubit/student_attendance_state.dart';
import '../widget/attendance_tile.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  final AttendanceInput attendanceInput;

  const AttendanceHistoryScreen({super.key, required this.attendanceInput});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  HomeRepository homeRepository = sl<HomeRepository>();
  List<AttendanceModel> filterStudentAttendanceList = [];
  List<AttendanceModel> studentAttendanceList = [];
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    print('Attendance input ${widget.attendanceInput.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateFormat(
      "yyyy-MM-dd",
    ).parse(widget.attendanceInput.attendanceDate!);
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
          child: Padding(
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
                          SvgPicture.asset("assets/images/svg/ic_calendar.svg"),
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
                    context.read<StudentAttendanceCubit>().filterSearchResults(
                      value,
                    );
                  },
                ),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
                            builder: (context, state) {
                              if (state.studentAttendanceStatus ==
                                  StudentAttendanceStatus.loading) {
                                return Center(child: LoadingIndicator());
                              } else if (state.studentAttendanceStatus ==
                                  StudentAttendanceStatus.success) {
                                studentAttendanceList =
                                    List.from(state.attendanceList)..sort(
                                      (a, b) =>
                                          a.studentName.toLowerCase().compareTo(
                                            b.studentName.toLowerCase(),
                                          ),
                                    );

                                filterStudentAttendanceList = List.from(
                                  studentAttendanceList,
                                );
                                return Container(
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
                                              enableSelection: false,
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
                                );
                              } else if (state.studentAttendanceStatus ==
                                  StudentAttendanceStatus.failure) {
                                return Center(
                                  child: Text(state.failure.message),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }
}
