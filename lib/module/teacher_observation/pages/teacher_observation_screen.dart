import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/employee_detail_cubit/employee_detail_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_areas_cubit/fetch_observation_areas_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/employee_detail_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/add_level_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/observation_report_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/submit_observation_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/teacher_remarks_screen.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/text_view.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';

class TeacherObservationScreen extends StatefulWidget {
  const TeacherObservationScreen({super.key});

  @override
  State<TeacherObservationScreen> createState() =>
      _TeacherObservationScreenState();
}

class _TeacherObservationScreenState extends State<TeacherObservationScreen> {
  TextEditingController employeeIdTextController = TextEditingController();
  EmployeeModel? employeeModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchObservationAreasCubit(sl()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FetchObservationAreasCubit(sl()))
        ],
        child: BaseScaffold(
          appBar: const CustomAppbar(
            'Teacher Observation',
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20) +
                  const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: 'Add Level',
                    height: 50,
                    inputType: TextInputType.text,
                    fillColor: AppColors.lightGreyColor,
                    hintColor: AppColors.primaryDark,
                    fontWeight: FontWeight.w500,
                    readOnly: true,
                    fontSize: 16,
                    suffixWidget: SvgPicture.asset(
                      'assets/images/svg/ic_arrow_forward.svg',
                      color: AppColors.primaryDark,
                    ),
                    onTap: () async {
                      NavRouter.push(context, AddLevelScreen());
                    },
                  ),
                  BlocConsumer<FetchObservationAreasCubit,
                      FetchObservationAreasState>(
                    listener: (context, state) {
                      if (state.fetchObservationAreasStatus ==
                          FetchObservationAreasStatus.loading) {
                        DisplayUtils.showLoader();
                      } else if (state.fetchObservationAreasStatus ==
                          FetchObservationAreasStatus.success) {
                        DisplayUtils.removeLoader();
                        NavRouter.push(
                            context,
                            TeacherRemarksScreen(
                              areas: state.observationModel!.observationArea,
                            ));
                      } else if (state.fetchObservationAreasStatus ==
                          FetchObservationAreasStatus.failure) {
                        DisplayUtils.removeLoader();
                        DisplayUtils.showSnackBar(
                            context, state.failure.message);
                      }
                    },
                    builder: (context, state) {
                      return CustomTextField(
                        hintText: 'Add Teacher Remarks',
                        height: 50,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        hintColor: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                        readOnly: true,
                        fontSize: 16,
                        suffixWidget: SvgPicture.asset(
                          'assets/images/svg/ic_arrow_forward.svg',
                          color: AppColors.primaryDark,
                        ),
                        onTap: () async {
                          context.read<FetchObservationAreasCubit>()
                            ..getObservationAreas();
                        },
                      );
                    },
                  ),
                  CustomTextField(
                    hintText: 'Teacher Observation',
                    height: 50,
                    inputType: TextInputType.text,
                    fillColor: AppColors.lightGreyColor,
                    hintColor: AppColors.primaryDark,
                    fontWeight: FontWeight.w500,
                    readOnly: true,
                    fontSize: 16,
                    suffixWidget: SvgPicture.asset(
                      'assets/images/svg/ic_arrow_forward.svg',
                      color: AppColors.primaryDark,
                    ),
                    onTap: () async {
                      showEmployeeIdDialog(context, onButtonPressYes: (value) {
                        NavRouter.push(context, SubmitObservationScreen(
                          employeeModel : employeeModel!
                        ));
                      });
                    },
                  ),
                  CustomTextField(
                    hintText: 'Observation Report',
                    height: 50,
                    inputType: TextInputType.text,
                    fillColor: AppColors.lightGreyColor,
                    hintColor: AppColors.primaryDark,
                    fontWeight: FontWeight.w500,
                    readOnly: true,
                    fontSize: 16,
                    suffixWidget: SvgPicture.asset(
                      'assets/images/svg/ic_arrow_forward.svg',
                      color: AppColors.primaryDark,
                    ),
                    onTap: () async {
                      NavRouter.push(context, ObservationReportScreen());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          hMargin: 0,
          backgroundColor: AppColors.primaryDark,
        ),
      ),
    );
  }

  void showEmployeeIdDialog(BuildContext context,
      {void Function(bool val)? onButtonPressYes}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: BlocConsumer<EmployeeDetailCubit, EmployeeDetailState>(
              listener: (context, state) {
                if (state.employeeDetailStatus ==
                    EmployeeDetailStatus.loading) {
                  DisplayUtils.showLoader();
                } else if (state.employeeDetailStatus ==
                    EmployeeDetailStatus.success) {
                  employeeModel = state.employeeModel;
                  DisplayUtils.removeLoader();
                  employeeIdTextController.text = "";
                  NavRouter.pop(context);
                  onButtonPressYes!(true);
                } else if (state.employeeDetailStatus ==
                    EmployeeDetailStatus.failure) {
                  DisplayUtils.removeLoader();
                  DisplayUtils.showSnackBar(context, state.failure.message);
                }
              },
              builder: (context, state) {
                return Container(
                  height: 240,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextView(
                          'Enter Employee ID',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.dividerColor,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: CustomTextField(
                          hintText: 'Employee ID',
                          height: 50,
                          bottomMargin: 0,
                          controller: employeeIdTextController,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          inputType: TextInputType.number,
                          fillColor: AppColors.lightGreyColor,
                          hintColor: AppColors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
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
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: CustomButton(
                                onPressed: () {
                                  if (employeeIdTextController.text
                                      .trim()
                                      .isNotEmpty) {
                                    context.read<EmployeeDetailCubit>()..getEmployeeDetail(employeeIdTextController.text.trim().toString());
                                  } else {
                                    DisplayUtils.showSnackBar(
                                        context, "Enter Employee ID");
                                  }
                                },
                                width: 80,
                                fontSize: 14,
                                title: 'Submit',
                                height: 45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
