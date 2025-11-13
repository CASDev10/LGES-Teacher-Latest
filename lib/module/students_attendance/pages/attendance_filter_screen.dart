import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/class_section/cubit/classes_cubit/classes_cubit.dart';
import 'package:lges_teacher_app/module/class_section/cubit/sections_cubit/sections_cubit.dart';
import 'package:lges_teacher_app/module/class_section/model/sections_model.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';

import '../../../components/custom_button.dart';
import '../../../components/generic_drop_down.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../class_section/model/classes_model.dart';
import '../../leave_request/widgets/custom_calander_widget.dart';
import 'attendance_history_screen.dart';

class AttendanceFilterScreen extends StatefulWidget {
  @override
  State<AttendanceFilterScreen> createState() => _AttendanceFilterScreenState();
}

class _AttendanceFilterScreenState extends State<AttendanceFilterScreen> {
  String? dropdownValueClass;
  String? dropdownValueSection;
  List<Section>? sections;
  TextEditingController fromDateController = TextEditingController();
  String formattedDate = '';
  AuthRepository authRepository = sl<AuthRepository>();
  String? classId;
  String? sectionId;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClassesCubit(sl())
                ..fetchClasses(authRepository.user.schoolId.toString()),
        ),
        BlocProvider(create: (context) => SectionsCubit(sl())),
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
                const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomCalendarWidget(
                        onDaySelected: (selectedDate) {
                          fromDateController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(selectedDate);
                          formattedDate = fromDateController.text;
                        },
                        firstDay: DateTime(2000, 1, 1),
                        lastDay: DateTime.now(),
                      ),
                      const SizedBox(height: 40),
                      BlocConsumer<ClassesCubit, ClassesState>(
                        listener: (context, classState) {
                          if (classState.classesStatus ==
                              ClassesStatus.loading) {
                            DisplayUtils.showLoader();
                          } else if (classState.classesStatus ==
                              ClassesStatus.success) {
                            DisplayUtils.removeLoader();
                          } else if (classState.classesStatus ==
                              ClassesStatus.failure) {
                            DisplayUtils.removeLoader();
                            DisplayUtils.showSnackBar(
                              context,
                              classState.failure.message,
                            );
                          }
                        },
                        builder: (context, classState) {
                          return GenericDropDown<Class>(
                            allPadding: 0,
                            horizontalPadding: 15,
                            isOutline: false,
                            hintColor: AppColors.primaryDark,
                            iconColor: AppColors.primaryDark,
                            suffixIconPath: '',
                            hint: dropdownValueClass ?? 'Select Class',
                            items: classState.classes,
                            onSelect: (Class value) {
                              setState(() {
                                dropdownValueClass = value.className;
                                dropdownValueSection = null;
                                classId = value.classId.toString();
                              });
                              context.read<SectionsCubit>().fetchSections(
                                classId.toString(),
                              );
                            },
                            getLabel: (classModel) => classModel.className,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      BlocConsumer<SectionsCubit, SectionsState>(
                        listener: (context, sectionStatus) {
                          if (sectionStatus.sectionsStatus ==
                              SectionsStatus.loading) {
                            DisplayUtils.showLoader();
                          } else if (sectionStatus.sectionsStatus ==
                              SectionsStatus.success) {
                            DisplayUtils.removeLoader();
                          } else if (sectionStatus.sectionsStatus ==
                              SectionsStatus.failure) {
                            DisplayUtils.removeLoader();
                            DisplayUtils.showSnackBar(
                              context,
                              sectionStatus.failure.message,
                            );
                          }
                        },
                        builder: (context, sectionStatus) {
                          sections = sectionStatus.sections;
                          return GestureDetector(
                            onTap: dropdownValueClass == null
                                ? () {
                                    DisplayUtils.showSnackBar(
                                      context,
                                      "Please select Class First",
                                    );
                                  }
                                : null,
                            child: GenericDropDown<Section>(
                              allPadding: 0,
                              horizontalPadding: 15,
                              isOutline: false,
                              hintColor: AppColors.primaryDark,
                              iconColor: AppColors.primaryDark,
                              suffixIconPath: '',
                              hint: 'Select Section',
                              items: sectionStatus.sections,
                              onSelect: (Section value) {
                                setState(() {
                                  dropdownValueSection = value.sectionName;
                                  sectionId = value.sectionId.toString();
                                });
                              },
                              getLabel: (section) => section.sectionName,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
                CustomButton(
                  height: 50,
                  borderRadius: 15,
                  onPressed: () {
                    if (dropdownValueSection == null &&
                        dropdownValueClass == null) {
                      DisplayUtils.showSnackBar(
                        context,
                        "Please select Class & Section",
                      );
                    } else if (dropdownValueClass == null) {
                      DisplayUtils.showSnackBar(context, "Please select Class");
                    } else if (dropdownValueSection == null) {
                      DisplayUtils.showSnackBar(
                        context,
                        "Please select Section",
                      );
                    } else {
                      print("Class --- $dropdownValueClass");
                      print("Section --- $dropdownValueSection");
                      AttendanceInput attendanceInput = AttendanceInput(
                        sectionIdFk: sectionId.toString(),
                        classIdFk: classId.toString(),
                        attendanceDate: formattedDate,
                        isOnRollStudents: true,
                        uCSchoolId: authRepository.user.schoolId.toString(),
                        uCEntityId: authRepository.user.entityId.toString(),
                      );

                      print('Student attendance ${attendanceInput.toJson()}');
                      NavRouter.push(
                        context,
                        AttendanceHistoryScreen(
                          attendanceInput: attendanceInput,
                        ),
                      );
                    }
                  },
                  title: 'Show',
                  isEnabled: true,
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
