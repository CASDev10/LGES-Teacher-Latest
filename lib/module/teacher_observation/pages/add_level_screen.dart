import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/loading_indicator.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/observation_level_cubit/observation_level_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/widgets/level_tile.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/text_view.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../cubit/add_update_delete_level_cubit/add_update_delete_level_cubit.dart';
import '../cubit/add_update_delete_level_cubit/add_update_delete_level_state.dart';

class AddLevelScreen extends StatefulWidget {
  const AddLevelScreen({super.key});

  @override
  State<AddLevelScreen> createState() => _AddLevelScreenState();
}

class _AddLevelScreenState extends State<AddLevelScreen> {
  TextEditingController addLevelTextController = TextEditingController();
  String crudOperationStatus = "add";

  @override
  void initState() {
    super.initState();
    context.read<ObservationLevelCubit>()..getObservationLevels();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CustomAppbar('Add Level', centerTitle: true),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ObservationLevelCubit, ObservationLevelState>(
          builder: (context, observationLevelState) {
            if (observationLevelState.observationLevelStatus ==
                ObservationLevelStatus.loading) {
              return Center(child: LoadingIndicator());
            } else if (observationLevelState.observationLevelStatus ==
                ObservationLevelStatus.success) {
              return Column(
                children: [
                  SizedBox(height: 5),
                  BlocConsumer<
                    AddUpdateDeleteLevelCubit,
                    AddUpdateDeleteLevelState
                  >(
                    listener: (context, levelState) {
                      if (levelState.levelStatus ==
                          AddUpdateDeleteLevelStatus.loading) {
                        DisplayUtils.showLoader();
                      } else if (levelState.levelStatus ==
                          AddUpdateDeleteLevelStatus.success) {
                        DisplayUtils.removeLoader();
                        NavRouter.pop(context);
                        if (crudOperationStatus == "add") {
                          DisplayUtils.showToast(
                            context,
                            "Level Added Successfully!",
                          );
                        } else if (crudOperationStatus == "edit") {
                          DisplayUtils.showToast(
                            context,
                            "Level Updated Successfully!",
                          );
                        } else {
                          DisplayUtils.showToast(
                            context,
                            "Level Deleted Successfully!",
                          );
                        }
                        context.read<ObservationLevelCubit>()
                          ..getObservationLevels();
                      } else if (levelState.levelStatus ==
                          AddUpdateDeleteLevelStatus.failure) {
                        DisplayUtils.removeLoader();
                        DisplayUtils.showToast(
                          context,
                          levelState.failure.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Expanded(
                        child: observationLevelState.levels.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  return ObservationLevelTile(
                                    observationLevelModel:
                                        observationLevelState.levels[index],
                                    onButtonPressYes: (value) {
                                      if (value) {
                                        showAddLevel(
                                          context,
                                          observationLevelState
                                              .levels[index]
                                              .level,
                                          observationLevelState
                                              .levels[index]
                                              .levelId
                                              .toString(),
                                          true,
                                          onButtonPressYes: (value) {
                                            context
                                                .read<ObservationLevelCubit>()
                                              ..getObservationLevels();
                                          },
                                        );
                                      } else {
                                        DialogUtils.confirmationDialog(
                                          context: context,
                                          title: 'Confirmation!',
                                          content:
                                              'Are you sure you want to delete the level?',
                                          onPressYes: () {
                                            crudOperationStatus = "delete";
                                            context
                                                .read<
                                                  AddUpdateDeleteLevelCubit
                                                >()
                                              ..deleteObservationLevel(
                                                observationLevelState
                                                    .levels[index]
                                                    .levelId
                                                    .toString(),
                                              );
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                                itemCount: observationLevelState.levels.length,
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 30,
                                ),
                              )
                            : Center(child: Text("Levels not found")),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onPressed: () {
                      showAddLevel(
                        context,
                        "",
                        "",
                        false,
                        onButtonPressYes: (value) {
                          context.read<ObservationLevelCubit>()
                            ..getObservationLevels();
                        },
                      );
                    },
                    title: 'Add Level',
                    height: 50,
                    width: 170,
                  ),
                  SizedBox(height: 30),
                ],
              );
            } else if (observationLevelState.observationLevelStatus ==
                ObservationLevelStatus.failure) {
              return Center(child: Text(observationLevelState.failure.message));
            }
            return SizedBox();
          },
        ),
      ),
      hMargin: 0,
    );
  }

  void showAddLevel(
    BuildContext context,
    String level,
    String levelId,
    bool isEditButtonClick, {
    void Function(bool val)? onButtonPressYes,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        addLevelTextController.text = level;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: Container(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextView(
                    'Add Level',
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
                    hintText: 'Level',
                    height: 50,
                    bottomMargin: 0,
                    controller: addLevelTextController,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    inputType: TextInputType.text,
                    fillColor: AppColors.lightGreyColor,
                    hintColor: AppColors.grey,
                  ),
                ),
                SizedBox(height: 24),
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
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomButton(
                          onPressed: () {
                            if (addLevelTextController.text
                                .trim()
                                .toString()
                                .isNotEmpty) {
                              if (isEditButtonClick) {
                                crudOperationStatus = "edit";
                                context.read<AddUpdateDeleteLevelCubit>()
                                  ..updateObservationLevel(
                                    addLevelTextController.text
                                        .trim()
                                        .toString(),
                                    levelId,
                                  );
                              } else {
                                crudOperationStatus = "add";
                                context.read<AddUpdateDeleteLevelCubit>()
                                  ..addObservationLevel(
                                    addLevelTextController.text
                                        .trim()
                                        .toString(),
                                  );
                              }
                            } else {
                              DisplayUtils.showToast(
                                context,
                                "Please add level",
                              );
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
