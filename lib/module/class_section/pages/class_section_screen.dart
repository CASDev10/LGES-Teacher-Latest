import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/config/routes/nav_router.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/class_section/cubit/classes_cubit/classes_cubit.dart';
import 'package:lges_teacher_app/module/class_section/cubit/sections_cubit/sections_cubit.dart';
import 'package:lges_teacher_app/module/class_section/model/sections_model.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_input.dart';
import 'package:lges_teacher_app/widgets/calendar_view.dart';

import '../../../components/custom_button.dart';
import '../../../components/generic_drop_down.dart';
import '../../../components/loading_indicator.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../students_attendance/pages/attendance_screen.dart';
import '../model/classes_model.dart';

class ClassSectionScreen extends StatefulWidget {
  @override
  State<ClassSectionScreen> createState() => _ClassSectionScreenState();
}

class _ClassSectionScreenState extends State<ClassSectionScreen> {
  String? dropdownValueClass;
  String? dropdownValueSection;
  List<Section>? sections;

  bool loadFromManual = true;

  AuthRepository authRepository = sl<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d, MMMM yyyy').format(now);
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
          child: BlocBuilder<ClassesCubit, ClassesState>(
            builder: (context, classState) {
              if (classState.classesStatus == ClassesStatus.loading) {
                return Center(child: LoadingIndicator());
              }
              if (classState.classesStatus == ClassesStatus.success) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20) +
                      const EdgeInsets.symmetric(vertical: 30),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
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
                          const SizedBox(height: 35),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: HorizontalCalendarView(),
                          ),
                          const SizedBox(height: 25),
                          GenericDropDown<Class>(
                            allPadding: 0,
                            horizontalPadding: 15,
                            isOutline: false,
                            hintColor: AppColors.primaryDark,
                            iconColor: AppColors.primaryDark,
                            suffixIconPath: '',
                            hint: 'Select Class',
                            items: classState.classes,
                            onSelect: (Class value) {
                              setState(() {
                                setState(() {
                                  dropdownValueClass = value.className;
                                  dropdownValueSection = null;
                                  sections = [];
                                });
                              });
                              context.read<SectionsCubit>().fetchSections(
                                value.classId.toString(),
                              );
                            },
                            getLabel: (classModel) => classModel.className,
                          ),
                          const SizedBox(height: 25),
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
                                    });
                                  },
                                  getLabel: (section) => section.sectionName,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 22),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                loadFromManual = !loadFromManual;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: AppColors.lightGreyColor,
                                    ),
                                    color: AppColors.lightGreyColor,
                                  ),
                                  height: 28,
                                  width: 28,
                                  margin: EdgeInsets.only(left: 5),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: loadFromManual
                                          ? AppColors.primaryDark
                                          : Colors.transparent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const TextView(
                                  'Load from Manual',
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CustomButton(
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
                              DisplayUtils.showSnackBar(
                                context,
                                "Please select Class",
                              );
                            } else if (dropdownValueSection == null) {
                              DisplayUtils.showSnackBar(
                                context,
                                "Please select Section",
                              );
                            } else {
                              print("Class --- $dropdownValueClass");
                              print("Section --- $dropdownValueSection");

                              Class selectedClass = classState.classes
                                  .firstWhere(
                                    (element) =>
                                        element.className == dropdownValueClass,
                                  );
                              Section? selectedSection = sections?.firstWhere(
                                (element) =>
                                    element.sectionName == dropdownValueSection,
                              );
                              AttendanceInput attendanceInput = AttendanceInput(
                                sectionIdFk: selectedSection?.sectionId
                                    .toString(),
                                classIdFk: selectedClass.classId.toString(),
                                attendanceDate: DateFormat(
                                  'yyyy-MM-dd',
                                ).format(now),
                                isOnRollStudents: loadFromManual,
                                uCSchoolId: authRepository.user.schoolId
                                    .toString(),
                                uCEntityId: authRepository.user.entityId
                                    .toString(),
                              );

                              print(
                                'Student attendance ${attendanceInput.toJson()}',
                              );
                              NavRouter.push(
                                context,
                                AttendanceScreen(
                                  attendanceInput: attendanceInput,
                                ),
                              );
                            }
                          },
                          title: 'Submit',
                          isEnabled: true,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (classState.classesStatus == ClassesStatus.failure) {
                return Center(child: Text(classState.failure.message));
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
