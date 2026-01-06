import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/add_update_delete_remarks_cubit/add_update_delete_remarks_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_areas_cubit/fetch_observation_areas_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_remarks_cubit/fetch_observation_remarks_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/fetch_observation_remarks_cubit/fetch_observation_remarks_state.dart';
import 'package:lges_teacher_app/module/teacher_observation/widgets/teacher_remarks_tile.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../models/observation_areas_response.dart';

class TeacherRemarksScreen extends StatefulWidget {
  final List<ObservationArea> areas ;
  const TeacherRemarksScreen({super.key, required this.areas});

  @override
  State<TeacherRemarksScreen> createState() => _TeacherRemarksScreenState();
}

class _TeacherRemarksScreenState extends State<TeacherRemarksScreen> {
  TextEditingController teacherRemarksTextController = TextEditingController();
  String? dropdownValueArea;
  String? areaId;
  String crudOperationStatus = "add";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                FetchObservationRemarksCubit(sl())..getObservationRemarks()),
        BlocProvider(create: (context) => AddUpdateDeleteRemarksCubit(sl())),
      ],
      child: BaseScaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: const CustomAppbar(
          'Observation Remarks',
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
          child: BlocBuilder<FetchObservationRemarksCubit,
              FetchObservationRemarksState>(
            builder: (context, observationRemarksState) {
              if (observationRemarksState.fetchObservationRemarksStatus ==
                  FetchObservationRemarksStatus.loading) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (observationRemarksState
                      .fetchObservationRemarksStatus ==
                  FetchObservationRemarksStatus.success) {
                return Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    BlocConsumer<AddUpdateDeleteRemarksCubit,
                        AddUpdateDeleteRemarksState>(
                      listener: (context, remarksState) {
                        if (remarksState.remarksStatus ==
                            AddUpdateDeleteRemarksStatus.loading) {
                          DisplayUtils.showLoader();
                        } else if (remarksState.remarksStatus ==
                            AddUpdateDeleteRemarksStatus.success) {
                          DisplayUtils.removeLoader();
                          NavRouter.pop(context);
                          if (crudOperationStatus == "add") {
                            DisplayUtils.showToast(
                                context, "Level Added Successfully!");
                          } else if (crudOperationStatus == "edit") {
                            DisplayUtils.showToast(
                                context, "Level Updated Successfully!");
                          } else {
                            DisplayUtils.showToast(
                                context, "Level Deleted Successfully!");
                          }
                          context.read<FetchObservationRemarksCubit>()
                            ..getObservationRemarks();
                        } else if (remarksState.remarksStatus ==
                            AddUpdateDeleteRemarksStatus.failure) {
                          DisplayUtils.removeLoader();
                          DisplayUtils.showToast(
                              context, remarksState.failure.message);
                        }
                      },
                      builder: (context, state) {
                        return Expanded(
                            child: ListView.builder(
                          itemBuilder: (context, index) {
                            return TeacherRemarksTile(
                              observationRemarksModel:
                                  observationRemarksState.remarks[index],
                              onButtonPressYes: (value) {
                                if (value) {
                                  showAddTeacherRemarks(
                                      context,
                                      observationRemarksState
                                          .remarks[index].remarks,
                                      observationRemarksState
                                          .remarks[index].remarksId
                                          .toString(),
                                      observationRemarksState
                                          .remarks[index].areaIdFk
                                          .toString(),
                                      observationRemarksState
                                          .remarks[index].areaName
                                          .toString(),
                                      true);
                                } else {
                                  DialogUtils.confirmationDialog(
                                      context: context,
                                      title: 'Confirmation!',
                                      content:
                                          'Are you sure you want to delete the level?',
                                      onPressYes: () {
                                        crudOperationStatus = "delete";
                                        context
                                            .read<AddUpdateDeleteRemarksCubit>()
                                          ..deleteObservationRemarks(
                                              observationRemarksState
                                                  .remarks[index].remarksId
                                                  .toString());
                                      });
                                }
                              },
                            );
                          },
                          itemCount: observationRemarksState.remarks.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                        ));
                      },
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      onPressed: () {
                        crudOperationStatus = "add";
                        showAddTeacherRemarks(
                            context,
                            "",
                            "","","",
                            false,);
                      },
                      title: 'Add Remarks',
                      height: 50,
                      width: 170,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              } else if (observationRemarksState
                      .fetchObservationRemarksStatus ==
                  FetchObservationRemarksStatus.failure) {
                return Center(
                  child: Text(observationRemarksState.failure.message),
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

  void showAddTeacherRemarks(
      BuildContext parentContext, String remarks, String remarksId, String selectedAreaId ,String areaName, bool isEditButtonClick) async {
    showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          teacherRemarksTextController.text = remarks;
          areaId = selectedAreaId;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              // height: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextView(
                      'Add Teacher Remarks',
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
                      items: widget.areas.map((area) => area.areaName).toList(),
                      hint: areaName.isNotEmpty? areaName : 'Select Area',
                      onSelect: (String value) {
                        setState(() {
                          ObservationArea selectedArea = widget.areas.firstWhere(
                              (element) => element.areaName == value);
                          areaId = selectedArea.areaId.toString();
                          dropdownValueArea = value;
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
                      hintText: 'Remarks',
                      height: 50,
                      bottomMargin: 0,
                      controller: teacherRemarksTextController,
                      fontSize: 14,
                      maxLines: 8,
                      fontWeight: FontWeight.normal,
                      inputType: TextInputType.text,
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
                          child: CustomButton(
                            onPressed: () {
                              if (dropdownValueArea.toString().isNotEmpty) {
                                if (teacherRemarksTextController.text
                                    .trim()
                                    .toString()
                                    .isNotEmpty) {
                                  if (isEditButtonClick) {
                                    crudOperationStatus = "edit";
                                    parentContext.read<AddUpdateDeleteRemarksCubit>()
                                      ..updateObservationRemarks(
                                          teacherRemarksTextController.text
                                              .trim()
                                              .toString(),
                                          areaId.toString(),
                                          remarksId);
                                  } else {
                                    crudOperationStatus = "add";
                                    parentContext.read<AddUpdateDeleteRemarksCubit>()
                                      ..addObservationRemarks(
                                          teacherRemarksTextController.text
                                              .trim()
                                              .toString(),
                                          areaId.toString());
                                  }
                                } else {
                                  DisplayUtils.showToast(
                                      context, "Please add remarks");
                                }
                              } else {
                                DisplayUtils.showToast(
                                    context, "Please select area!");
                              }
                            },
                            width: 80,
                            fontSize: 14,
                            title: 'Save',
                            height: 45,
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
