import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/evaluation/cubit/add_evaluation_cubit/add_evaluation_cubit.dart';
import 'package:lges_teacher_app/module/evaluation/cubit/add_evaluation_cubit/add_evaluation_state.dart';
import 'package:lges_teacher_app/module/evaluation/cubit/add_evaluation_remarks_cubit/add_evaluation_remarks_cubit.dart';
import 'package:lges_teacher_app/module/evaluation/cubit/add_evaluation_remarks_cubit/add_evaluation_remarks_state.dart';
import 'package:lges_teacher_app/module/evaluation/cubit/evaluation_areas_cubit/evaluation_areas_state.dart';
import 'package:lges_teacher_app/module/evaluation/models/add_evaluation_input.dart';
import 'package:lges_teacher_app/module/evaluation/models/add_evaluation_remarks_input.dart';
import 'package:lges_teacher_app/module/evaluation/models/evaluation_areas_response.dart';
import 'package:lges_teacher_app/module/evaluation/models/student_evaluation_areas_input.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/custom_date_time_picker.dart';
import '../../../utils/display/display_utils.dart';
import '../cubit/evaluation_areas_cubit/evaluation_areas_cubit.dart';
import '../cubit/evaluation_remarks_cubit/evaluation_remarks_cubit.dart';
import '../models/evaluation_remarks_response.dart';
import '../models/student_evaluation_areas_response.dart';

class StudentEvaluationScreen extends StatefulWidget {
  final StudentEvaluationAreaModel studentEvaluationAreaModel;
  final String studentId ;

  const StudentEvaluationScreen(
      {super.key, required this.studentEvaluationAreaModel, required this.studentId});

  @override
  State<StudentEvaluationScreen> createState() =>
      _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState extends State<StudentEvaluationScreen> {
  TextEditingController evaluationRemarks = TextEditingController();
  TextEditingController evaluationDateController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  AuthRepository authRepository = sl<AuthRepository>();
  String? dropdownValueAreaId;
  String? communicationSkillsRemarksId;
  String? strengthRemarksId;
  String? weakAreaRemarksId;
  String? behaviourIssueRemarksId;
  String? parentInvolvementRemarksId;
  String? healthIssueRemarksId;
  List<TextEditingController> subjectPercentageControllers = [];

  @override
  void initState() {
    super.initState();
    for (var element in widget.studentEvaluationAreaModel.classSubject) {
      subjectPercentageControllers
          .add(TextEditingController(text: element.marksPercent.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              EvaluationRemarksCubit(sl())..fetchEvaluationRemarks(),
        ),
        BlocProvider(
          create: (context) => AddEvaluationCubit(sl()),
        ),
      ],
      child: BaseScaffold(
        appBar: const CustomAppbar(
          'Evaluation Student',
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
          child: BlocConsumer<AddEvaluationCubit, AddEvaluationState>(
            listener: (context, addEvaluationState) {
              if(addEvaluationState.addEvaluationStatus == AddEvaluationStatus.loading){
                DisplayUtils.showLoader();
              }else if(addEvaluationState.addEvaluationStatus == AddEvaluationStatus.success){
                DisplayUtils.removeLoader();
                NavRouter.pop(context);
                DisplayUtils.showToast(context, "Evaluation added successfully!");
              }else if(addEvaluationState.addEvaluationStatus == AddEvaluationStatus.failure){
                DisplayUtils.removeLoader();
                DisplayUtils.showSnackBar(context, addEvaluationState.failure.message);
              }
            },
            builder: (context, addEvaluationState) {
              return BlocBuilder<EvaluationRemarksCubit,
                  EvaluationRemarksState>(
                builder: (context, evaluationRemarksState) {
                  if (evaluationRemarksState.evaluationRemarksStatus ==
                      EvaluationRemarksStatus.loading) {
                    return Center(
                      child: LoadingIndicator(),
                    );
                  } else if (evaluationRemarksState.evaluationRemarksStatus ==
                      EvaluationRemarksStatus.success) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          CustomButton(
                            onPressed: () {
                              showAddEvaluationRemarks(
                                  context,
                                  widget.studentEvaluationAreaModel
                                      .evaluationArea,
                                  onButtonPressYes: (value) {
                                context.read<EvaluationRemarksCubit>()
                                  ..fetchEvaluationRemarks();
                              });
                            },
                            title: 'Add Evaluation Remarks',
                            height: 50,
                            width: 250,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomButton(
                                    onPressed: () {},
                                    title: 'Area',
                                    height: 50,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomButton(
                                  onPressed: () {},
                                  title: 'Remarks',
                                  height: 50,
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText: 'Communication Skills',
                                    maxLines: 2,
                                    bottomMargin: 0,
                                    readOnly: true,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  height: 65,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains("Communication Skills"
                                              .toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget.studentEvaluationAreaModel
                                            .evaluationArea[0]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText: 'Strength',
                                    height: 50,
                                    bottomMargin: 0,
                                    readOnly: true,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains("Strength".toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget
                                            .studentEvaluationAreaModel
                                            .evaluationArea[1]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText: 'Weak Area',
                                    height: 50,
                                    bottomMargin: 0,
                                    readOnly: true,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains("Weak Area".toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget
                                            .studentEvaluationAreaModel
                                            .evaluationArea[2]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText: 'Behaviour Issue/ Discipline',
                                    height: 50,
                                    readOnly: true,
                                    bottomMargin: 0,
                                    maxLines: 2,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  height: 65,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              "Behaviour Issue/ Discipline"
                                                  .toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget
                                            .studentEvaluationAreaModel
                                            .evaluationArea[3]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText:
                                        'Parent Involvement and Cooperation',
                                    height: 50,
                                    readOnly: true,
                                    bottomMargin: 0,
                                    maxLines: 2,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  height: 65,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              "Parent Involvement and Cooperation"
                                                  .toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget
                                            .studentEvaluationAreaModel
                                            .evaluationArea[4]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomTextField(
                                    hintText: 'Health Issue',
                                    readOnly: true,
                                    height: 50,
                                    bottomMargin: 0,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  items: evaluationRemarksState
                                      .evaluationRemarks
                                      .where((item) => item.evaluationArea
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              "Health Issue".toLowerCase()))
                                      .toList()
                                      .map((remarks) =>
                                          remarks.evaluationRemarks)
                                      .toList(),
                                  hint: 'Select Remarks',
                                  onSelect: (String value) {
                                    EvaluationRemarksModel
                                        evaluationRemarksModel =
                                        evaluationRemarksState.evaluationRemarks
                                            .firstWhere((element) =>
                                                element.evaluationRemarks ==
                                                value);
                                    widget
                                            .studentEvaluationAreaModel
                                            .evaluationArea[5]
                                            .evaluationRemarks =
                                        evaluationRemarksModel
                                            .evaluationRemarksId;
                                  },
                                ),
                              ))
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CustomButton(
                                    onPressed: () {},
                                    title: 'Subject',
                                    height: 50,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CustomButton(
                                  onPressed: () {},
                                  title: 'Marks\nPercentage',
                                  fontSize: 14,
                                  height: 50,
                                ),
                              ))
                            ],
                          ),
                          Column(
                            children: List.generate(
                                widget.studentEvaluationAreaModel.classSubject
                                    .length, (index) {
                              ClassSubject classSubject = widget
                                  .studentEvaluationAreaModel
                                  .classSubject[index];

                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: CustomTextField(
                                        hintText: classSubject.subjectName,
                                        height: 50,
                                        bottomMargin: 0,
                                        readOnly: true,
                                        fontWeight: FontWeight.normal,
                                        inputType: TextInputType.text,
                                        fillColor: AppColors.lightGreyColor,
                                        hintColor: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: CustomTextField(
                                      hintText: "0.00",
                                      height: 50,
                                      bottomMargin: 0,
                                      controller:
                                          subjectPercentageControllers[index],
                                      fontWeight: FontWeight.normal,
                                      inputType: TextInputType.number,
                                      fillColor: AppColors.lightGreyColor,
                                      maxLength: 3,
                                      hintColor: AppColors.primaryDark,
                                      onChange: (value) {
                                        widget
                                            .studentEvaluationAreaModel
                                            .classSubject[index]
                                            .marksPercent = double.parse(value);
                                      },
                                    ),
                                  ))
                                ],
                              );
                            }),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                            hintText: 'Evaluation Date',
                            height: 50,
                            readOnly: true,
                            bottomMargin: 0,
                            controller: evaluationDateController,
                            fontWeight: FontWeight.normal,
                            inputType: TextInputType.text,
                            fillColor: AppColors.lightGreyColor,
                            hintColor: AppColors.grey,
                            onTap: () async {
                              String date = await CustomDateTimePicker.selectDiaryDate(
                                  context);
                              DateTime dateTime =  DateFormat("dd/MM/yyyy").parse(date);
                              evaluationDateController.text = DateFormat("MM/dd/yyyy").format(dateTime);
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                            hintText: 'Comments',
                            bottomMargin: 0,
                            controller: commentsController,
                            maxLines: 7,
                            fontWeight: FontWeight.normal,
                            inputType: TextInputType.text,
                            fillColor: AppColors.lightGreyColor,
                            hintColor: AppColors.grey,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            onPressed: () {
                              if(evaluationDateController.text.isNotEmpty){
                                List<EvaluationLogBookDetail1> evaluationLogBookDetail1 = [];
                                List<EvaluationLogBookDetail2> evaluationLogBookDetail2 = [];
                                for(var element in widget.studentEvaluationAreaModel.classSubject){
                                  evaluationLogBookDetail1.add(EvaluationLogBookDetail1(subjectId: element.subjectId,marksPercent: element.marksPercent));
                                }
                                for(var element in widget.studentEvaluationAreaModel.evaluationArea){
                                  evaluationLogBookDetail2.add(EvaluationLogBookDetail2(evaluationAreaId: element.evaluationAreaId, evaluationRemarksId: element.evaluationRemarks));
                                }
                                AddEvaluationInput addEvaluationInput =
                                AddEvaluationInput(
                                    ucEntityId: authRepository.user.entityId.toString(),
                                    ucLoginUserId: authRepository.user.userId.toString(),
                                    ucSchoolId: authRepository.user.schoolId.toString(),
                                    studentIdfK:widget.studentId,
                                    evaluationDate: evaluationDateController.text.trim(),
                                    remarks: commentsController.text.trim(),
                                    evaluationLogBookDetail1: evaluationLogBookDetail1,
                                    evaluationLogBookDetail2: evaluationLogBookDetail2);
                                context.read<AddEvaluationCubit>()..addEvaluation(addEvaluationInput);
                              }else{
                                DisplayUtils.showSnackBar(context, "Select evaluation date!");
                              }
                            },
                            title: 'Save',
                            height: 50,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    );
                  } else if (evaluationRemarksState.evaluationRemarksStatus ==
                      EvaluationRemarksStatus.failure) {
                    return Center(
                      child: Text(evaluationRemarksState.failure.message),
                    );
                  }
                  return SizedBox();
                },
              );
            },
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  void showAddEvaluationRemarks(
      BuildContext context, List<EvaluationArea> evaluationAreas,
      {void Function(bool val)? onButtonPressYes}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextView(
                      'Add Evaluation Remarks',
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
                    child: CustomDropDown(
                      allPadding: 0,
                      height: 45,
                      horizontalPadding: 15,
                      isOutline: false,
                      hintColor: AppColors.primaryDark,
                      iconColor: AppColors.primaryDark,
                      suffixIconPath: '',
                      items: evaluationAreas
                          .map((areas) => areas.evaluationAreaName)
                          .toList(),
                      hint: 'Select Area',
                      onSelect: (String value) {
                        setState(() {
                          EvaluationArea evaluationArea =
                              evaluationAreas.firstWhere((element) =>
                                  element.evaluationAreaName == value);
                          dropdownValueAreaId =
                              evaluationArea.evaluationAreaId.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: CustomTextField(
                      hintText: 'Text',
                      height: 50,
                      bottomMargin: 0,
                      controller: evaluationRemarks,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      inputType: TextInputType.text,
                      fillColor: AppColors.lightGreyColor,
                      hintColor: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                          child: BlocConsumer<AddEvaluationRemarksCubit,
                              AddEvaluationRemarksState>(
                            listener: (context, state) {
                              if (state.addEvaluationRemarksStatus ==
                                  AddEvaluationRemarksStatus.loading) {
                                DisplayUtils.showLoader();
                              } else if (state.addEvaluationRemarksStatus ==
                                  AddEvaluationRemarksStatus.success) {
                                DisplayUtils.removeLoader();
                                DisplayUtils.showToast(
                                    context, "Remarks added");
                                evaluationRemarks.clear();
                                NavRouter.pop(context);
                                onButtonPressYes!(true);
                              } else if (state.addEvaluationRemarksStatus ==
                                  AddEvaluationRemarksStatus.failure) {
                                DisplayUtils.removeLoader();
                                DisplayUtils.showSnackBar(
                                    context, state.failure.message);
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                onPressed: () {
                                  AddEvaluationRemarksInput
                                      addEvaluationRemarksInput =
                                      AddEvaluationRemarksInput(
                                          evaluationRemarks:
                                              evaluationRemarks.text.trim(),
                                          evaluationAreaIdFk:
                                              dropdownValueAreaId.toString(),
                                          ucLoginUserId: authRepository
                                              .user.userId
                                              .toString());
                                  context
                                      .read<AddEvaluationRemarksCubit>()
                                      .addEvaluationRemarks(
                                          addEvaluationRemarksInput);
                                },
                                width: 80,
                                fontSize: 14,
                                title: 'Save',
                                height: 45,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
