import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_areas_cubit/fetch_observation_areas_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/submit_observation_cubit/submit_observation_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/employee_detail_response.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/submit_observation_input.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/observation_report_screen.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/custom_date_time_picker.dart';
import '../models/observation_areas_response.dart';

List<AreaRemark> areaRemarksList = [];

class SubmitObservationScreen extends StatefulWidget {
  final EmployeeModel employeeModel;

  const SubmitObservationScreen({super.key, required this.employeeModel});

  @override
  State<SubmitObservationScreen> createState() =>
      _SubmitObservationScreenState();
}

class _SubmitObservationScreenState extends State<SubmitObservationScreen> {
  TextEditingController dateTextController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  AuthRepository authRepository = sl<AuthRepository>();
  String? dropdownValueLevel;
  ObservationLevel? observationLevel;

  @override
  void initState() {
    super.initState();
    areaRemarksList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                FetchObservationAreasCubit(sl())..getObservationAreas()),
        BlocProvider(create: (context) => SubmitObservationCubit(sl())),
      ],
      child: BaseScaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: const CustomAppbar(
          'Teacher Observation',
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: BlocBuilder<FetchObservationAreasCubit,
              FetchObservationAreasState>(
            builder: (context, state) {
              if (state.fetchObservationAreasStatus ==
                  FetchObservationAreasStatus.loading) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state.fetchObservationAreasStatus ==
                  FetchObservationAreasStatus.success) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: "Search",
                        height: 50,
                        bottomMargin: 0,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30, top: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 8,
                              spreadRadius: .5,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextView(
                                    'Code',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    textAlign: TextAlign.start,
                                    color: AppColors.blackColor,
                                  )),
                                  Expanded(
                                      child: TextView(
                                    widget.employeeModel.empCode,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.end,
                                    color: AppColors.primaryDark,
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              color: AppColors.lightGreyColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextView(
                                      'Name',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.start,
                                      color: AppColors.blackColor,
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: TextView(
                                      widget.employeeModel.empName,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.end,
                                      color: AppColors.primaryDark,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              color: AppColors.lightGreyColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextView(
                                    'Department',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    textAlign: TextAlign.start,
                                    color: AppColors.blackColor,
                                  )),
                                  Expanded(
                                      child: TextView(
                                    widget.employeeModel.department,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.end,
                                    color: AppColors.primaryDark,
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextView(
                                    'Job Status',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    textAlign: TextAlign.start,
                                    color: AppColors.blackColor,
                                  )),
                                  Expanded(
                                      child: TextView(
                                    widget.employeeModel.jobStatus,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.end,
                                    color: AppColors.primaryDark,
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomButton(
                                  onPressed: () {},
                                  title: 'Area',
                                  height: 44,
                                ),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              color: AppColors.whiteColor,
                              width: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.all(2),
                              child: CustomButton(
                            width: 150,
                            onPressed: () {},
                            title: 'Remarks',
                            height: 44,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: List.generate(
                            state.observationModel!.observationArea.length,
                            (index) {
                          return AreaRemarksTile(
                              areaName: state.observationModel!
                                  .observationArea[index].areaName,
                              observationRemarks:
                                  state.observationModel!.observationRemarks,
                              observationArea:
                                  state.observationModel!.observationArea);
                        }),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CustomDropDown(
                        allPadding: 0,
                        horizontalPadding: 15,
                        isOutline: false,
                        hintColor: AppColors.primaryDark,
                        iconColor: AppColors.primaryDark,
                        suffixIconPath: '',
                        items: state.observationModel!.observationLevel
                            .map((levels) => levels.level)
                            .toList(),
                        hint: 'Select Level',
                        onSelect: (String value) {
                          observationLevel = state.observationModel!.observationLevel
                              .firstWhere((element) => element.level == value);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        hintText: 'Select Date',
                        height: 50,
                        readOnly: true,
                        bottomMargin: 0,
                        controller: dateTextController,
                        fontWeight: FontWeight.normal,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        hintColor: AppColors.primaryDark,
                        suffixWidget: SvgPicture.asset(
                          'assets/images/svg/ic_drop_down.svg',
                          color: AppColors.primaryDark,
                        ),
                        onTap: () async {
                          String date =
                              await CustomDateTimePicker.selectDiaryDate(
                                  context);
                          DateTime dateTime =
                              DateFormat("dd/MM/yyyy").parse(date);
                          dateTextController.text =
                              DateFormat("yyyy/MM/dd").format(dateTime);
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        hintText: 'Feedback',
                        bottomMargin: 0,
                        controller: feedbackController,
                        maxLines: 10,
                        fontWeight: FontWeight.normal,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        hintColor: AppColors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<SubmitObservationCubit,
                          SubmitObservationState>(
                        listener: (context, state) {
                          if(state.submitObservationStatus == SubmitObservationStatus.loading){
                            DisplayUtils.showLoader();
                          }else if(state.submitObservationStatus == SubmitObservationStatus.success){
                            DisplayUtils.removeLoader();
                            NavRouter.pop(context);
                            DisplayUtils.showToast(context, "Teacher observation added successfully!");
                          }else if(state.submitObservationStatus == SubmitObservationStatus.failure){
                            DisplayUtils.removeLoader();
                            DisplayUtils.showToast(context, state.failure.message);
                          }
                        },
                        builder: (context, state) {
                          return CustomButton(
                            onPressed: () {
                              if (areaRemarksList.isNotEmpty) {
                                if(observationLevel!= null){
                                  if (dateTextController.text.isNotEmpty) {
                                    SubmitObservationInput input =
                                    SubmitObservationInput(
                                        empId: widget.employeeModel.empId,
                                        submitDate: dateTextController.text
                                            .trim()
                                            .toString(),
                                        levelIdFk: observationLevel!.levelId,
                                        feedBack: feedbackController.text
                                            .trim()
                                            .toString(),
                                        areaRemarks: areaRemarksList,
                                        ucLoginUserId:
                                        authRepository.user.userId,
                                        ucUserFullName: "",
                                        ucEntityId:
                                        authRepository.user.entityId,
                                        ucSchoolId:
                                        authRepository.user.schoolId!);
                                    print(jsonEncode(input));
                                    context.read<SubmitObservationCubit>()..submitTeacherObservation(input);
                                  } else {
                                    DisplayUtils.showToast(
                                        context, "Please select date!");
                                  }
                                }else {
                                  DisplayUtils.showToast(
                                      context, "Please select level!");
                                }
                              } else {
                                DisplayUtils.showToast(
                                    context, "Please select remarks!");
                              }
                            },
                            title: 'Save',
                            height: 50,
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else if (state.fetchObservationAreasStatus ==
                  FetchObservationAreasStatus.loading) {
                return Center(
                  child: TextView(state.failure.message),
                );
              }
              return SizedBox();
            },
          ),
        ),
        hMargin: 0,
      ),
    );
  }
}

class AreaRemarksTile extends StatefulWidget {
  final String areaName;

  final List<ObservationRemark> observationRemarks;
  final List<ObservationArea> observationArea;

  const AreaRemarksTile({
    Key? key,
    required this.areaName,
    required this.observationRemarks,
    required this.observationArea,
  }) : super(key: key);

  @override
  State<AreaRemarksTile> createState() => _AreaRemarksTileState();
}

class _AreaRemarksTileState extends State<AreaRemarksTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child:TextView(
                  widget.areaName,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ) ,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            CustomDropDown(
              allPadding: 0,
              width: 150,
              horizontalPadding: 15,
              isOutline: false,
              hintColor: AppColors.primaryDark,
              iconColor: AppColors.primaryDark,
              suffixIconPath: '',
              items: widget.observationRemarks
                  .where((item) => item.areaName
                      .toString()
                      .toLowerCase()
                      .contains(widget.areaName.toLowerCase()))
                  .toList()
                  .map((remarks) => remarks.remarks)
                  .toList(),
              hint: 'Select Remarks',
              onSelect: (String value) {
                ObservationArea model = widget.observationArea
                    .firstWhere((element) => element.areaName == widget.areaName);
                ObservationRemark remarksModel = widget.observationRemarks
                    .firstWhere((element) => element.remarks == value);
                if (areaRemarksList.length > 0) {
                  AreaRemark areaRemark = areaRemarksList.firstWhere(
                    (element) => element.areaId == model.areaId,
                    orElse: () => AreaRemark(
                        areaId: -1,
                        remarksId: -1), // Default value when no element is found
                  );
                  if (areaRemark.areaId == -1) {
                    areaRemarksList.add(AreaRemark(
                        areaId: model.areaId, remarksId: remarksModel.remarksId));
                  } else {
                    int index = areaRemarksList
                        .indexWhere((item) => item.areaId == areaRemark.areaId);
                    areaRemarksList.removeAt(index);
                    areaRemarksList.add(AreaRemark(
                        areaId: model.areaId, remarksId: remarksModel.remarksId));
                  }
                } else {
                  areaRemarksList.add(AreaRemark(
                      areaId: model.areaId, remarksId: remarksModel.remarksId));
                }
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
