import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/exam_class_cubit/exam_classes_cubit.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/exam_class_sections_cubit/exam_class_sections_cubit.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/exam_class_sections_cubit/exam_class_sections_state.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/import_exam_result_cubit/import_exam_result_cubit.dart';
import 'package:lges_teacher_app/module/exam_result/cubit/import_exam_result_cubit/import_exam_result_state.dart';
import 'package:lges_teacher_app/module/exam_result/models/add_exam_result_input.dart';
import 'package:lges_teacher_app/module/exam_result/models/exam_class_sections_response.dart';
import 'package:lges_teacher_app/module/exam_result/models/import_exam_result_data_input.dart';
import 'package:lges_teacher_app/module/exam_result/models/student_model.dart';
import 'package:lges_teacher_app/utils/custom_countdown.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';
import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../auth/repo/auth_repository.dart';
import '../cubit/exam_class_cubit/exam_classes_state.dart';
import '../models/evaluation_response.dart';
import '../models/evaluation_type_response.dart';
import '../models/exam_class_response.dart';
import '../models/group_evaluation_response.dart';
import '../widget/dropdown_place_holder.dart';

class AddResultScreen extends StatefulWidget {
  const AddResultScreen({super.key});

  @override
  State<AddResultScreen> createState() => _AddResultScreenState();
}

class _AddResultScreenState extends State<AddResultScreen> {
  String? dropdownValueClass;
  String? dropdownValueSection;
  List<ExamClassSectionModel>? sections;
  AuthRepository authRepository = sl<AuthRepository>();
  FilePickerResult? result;
  TextEditingController fileNameController = TextEditingController();
  List<StudentModel> studentData = [];
  List<ResultSheetFixDataModel> fixData = [];
  List<ResultSheetDynamicSubjectModel> dynamicSubjects = [];
  String classId = '';
  String sectionId = '';
  Uint8List? excelFileBytes;
  List<Map<String, dynamic>> extractDataFromExcel({required Uint8List bytes}) {
    final excel = Excel.decodeBytes(bytes);
    final List<Map<String, dynamic>> result = [];

    if (excel.tables.isEmpty) return [];

    final sheet = excel.tables.values.first;
    if (sheet == null || sheet.rows.isEmpty) return [];

    final rows = sheet.rows;

    int headerRowIndex = -1;
    List<String> headers = [];

    // 🔍 Find header row (FileNumber + StudentName)
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i]
          .map((e) => e?.value?.toString().trim() ?? '')
          .toList();

      if (row.contains('FileNumber') && row.contains('StudentName')) {
        headerRowIndex = i;
        headers = row;
        break;
      }
    }

    if (headerRowIndex == -1) {
      debugPrint('❌ Header row not found');
      return [];
    }

    debugPrint('✅ Header found at row: $headerRowIndex');
    debugPrint('HEADERS: $headers');

    // 🔁 Read data rows
    for (int i = headerRowIndex + 1; i < rows.length; i++) {
      final row = rows[i];
      final Map<String, dynamic> rowData = {};
      bool hasData = false;

      for (int j = 0; j < headers.length; j++) {
        if (j >= row.length) continue;

        final header = headers[j];
        final cell = row[j]?.value;

        if (header.isEmpty || cell == null) continue;

        rowData[header] = cell.toString();
        hasData = true;
      }

      // skip empty rows
      if (hasData && rowData['FileNumber'] != null) {
        result.add(rowData);
      }
    }

    return result;
  }

  EvaluationGroupModel? selectedEvaluatedGroup;
  EvaluationTypeModel? selectedEvaluatedType;
  EvaluationModel? selectedEvaluated;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ExamClassesCubit(sl())
                ..fetchClasses(authRepository.user.schoolId.toString()),
        ),
        BlocProvider(
          create: (context) =>
              ExamClassSectionsCubit(sl())..fetchEvaluationType(),
        ),
        BlocProvider(create: (context) => ImportExamResultCubit(sl())),
      ],
      child: BaseScaffold(
        appBar: const CustomAppbar('Exam Result', centerTitle: true),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: BlocBuilder<ExamClassesCubit, ExamClassesState>(
            builder: (context, stateClass) {
              if (stateClass.examClassesStatus == ExamClassesStatus.loading) {
                return Center(child: LoadingIndicator());
              } else if (stateClass.examClassesStatus ==
                  ExamClassesStatus.success) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20) +
                      const EdgeInsets.symmetric(vertical: 30),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          CustomDropDown(
                            allPadding: 0,
                            horizontalPadding: 15,
                            isOutline: false,
                            hintColor: AppColors.primaryDark,
                            iconColor: AppColors.primaryDark,
                            suffixIconPath: '',
                            hint: 'Select Class',
                            items: stateClass.classes
                                .map((selectClass) => selectClass.className)
                                .toList(),
                            onSelect: (String value) {
                              ExamClassModel selectedClass = stateClass.classes
                                  .firstWhere(
                                    (element) => element.className == value,
                                  );
                              setState(() {
                                dropdownValueClass = value;
                                classId = selectedClass.classId.toString();
                                context
                                    .read<ExamClassSectionsCubit>()
                                    .fetchClassSections(
                                      selectedClass.classId.toString(),
                                    );
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocConsumer<
                            ExamClassSectionsCubit,
                            ExamClassSectionsState
                          >(
                            listener: (context, examClassSectionsState) {
                              if (examClassSectionsState
                                      .examClassSectionsStatus ==
                                  ExamClassSectionsStatus.loading) {
                                DisplayUtils.showLoader();
                              } else if (examClassSectionsState
                                      .examClassSectionsStatus ==
                                  ExamClassSectionsStatus.success) {
                                DisplayUtils.removeLoader();
                              } else if (examClassSectionsState
                                      .examClassSectionsStatus ==
                                  ExamClassSectionsStatus.failure) {
                                DisplayUtils.removeLoader();
                                DisplayUtils.showToast(
                                  context,
                                  examClassSectionsState.failure.message,
                                );
                              }
                            },
                            builder: (context, examClassSectionsState) {
                              sections = examClassSectionsState.classSections;
                              return GestureDetector(
                                onTap: dropdownValueClass == null
                                    ? () {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Class First",
                                        );
                                      }
                                    : null,
                                child: CustomDropDown(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  hint: 'Select Section',
                                  items: examClassSectionsState.classSections
                                      .map((section) => section.sectionName)
                                      .toList(),
                                  onSelect: (String value) {
                                    ExamClassSectionModel selectedSection =
                                        examClassSectionsState.classSections
                                            .firstWhere(
                                              (element) =>
                                                  element.sectionName == value,
                                            );
                                    setState(() {
                                      sectionId = selectedSection.sectionId
                                          .toString();
                                      dropdownValueSection = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          BlocConsumer<
                            ExamClassSectionsCubit,
                            ExamClassSectionsState
                          >(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  state.examClassSectionsStatus ==
                                          ExamClassSectionsStatus.loading
                                      ? DropdownPlaceHolder(
                                          name: selectedEvaluatedType != null
                                              ? selectedEvaluatedType!.name
                                              : "Select Evaluation Type",
                                        )
                                      : GeneralCustomDropDown<
                                          EvaluationTypeModel
                                        >(
                                          allPadding: 0,
                                          selectedValue: selectedEvaluatedType,
                                          horizontalPadding: 15,
                                          isOutline: false,
                                          hintColor: AppColors.primaryDark,
                                          iconColor: AppColors.primaryDark,
                                          suffixIconPath: '',
                                          displayField: (item) => item.name,
                                          hint: 'Select Evaluation Type',
                                          items: state.evaluationTypes,
                                          onSelect: (value) {
                                            setState(() {
                                              setState(() {
                                                selectedEvaluatedGroup = null;
                                                selectedEvaluated = null;
                                                selectedEvaluatedType = value;
                                              });
                                              context
                                                  .read<
                                                    ExamClassSectionsCubit
                                                  >()
                                                  .fetchEvaluation(
                                                    evaluationTypeId:
                                                        value.evaluationTypeId,
                                                  )
                                                  .then((_) {
                                                    if (value
                                                            .evaluationTypeId ==
                                                        2) {
                                                      context
                                                          .read<
                                                            ExamClassSectionsCubit
                                                          >()
                                                          .fetchGroupEvaluation(
                                                            evaluationTypeId: 0,
                                                          );
                                                    }
                                                  });
                                            });
                                          },
                                        ),
                                  SizedBox(height: 12.0),
                                  state.examClassSectionsStatus ==
                                          ExamClassSectionsStatus.loading
                                      ? DropdownPlaceHolder(
                                          name: selectedEvaluated != null
                                              ? selectedEvaluated!.name
                                              : "Select Evaluation",
                                        )
                                      : GeneralCustomDropDown<EvaluationModel>(
                                          allPadding: 0,
                                          selectedValue: selectedEvaluated,
                                          horizontalPadding: 15,
                                          isOutline: false,
                                          hintColor: AppColors.primaryDark,
                                          iconColor: AppColors.primaryDark,
                                          suffixIconPath: '',
                                          displayField: (item) => item.name,
                                          hint: 'Select Evaluation',
                                          items: state.evaluations,
                                          onSelect: (value) {
                                            setState(() {
                                              setState(() {
                                                selectedEvaluated = value;
                                              });
                                            });
                                          },
                                        ),
                                  SizedBox(height: 12.0),
                                  selectedEvaluatedType?.evaluationTypeId
                                              .toInt() ==
                                          2
                                      ? //Group Evaluation Type Dropdown
                                        state.examClassSectionsStatus ==
                                                ExamClassSectionsStatus.loading
                                            ? DropdownPlaceHolder(
                                                name:
                                                    selectedEvaluatedGroup
                                                        ?.name ??
                                                    "Select Group Evaluation Type",
                                              )
                                            : GeneralCustomDropDown<
                                                EvaluationGroupModel
                                              >(
                                                allPadding: 0,
                                                selectedValue:
                                                    selectedEvaluatedGroup,
                                                horizontalPadding: 15,
                                                isOutline: false,
                                                hintColor:
                                                    AppColors.primaryDark,
                                                iconColor:
                                                    AppColors.primaryDark,
                                                suffixIconPath: '',
                                                displayField: (item) =>
                                                    item.name,
                                                hint:
                                                    'Select Group Evaluation Type',
                                                items: state.evaluationsGroups,
                                                onSelect: (value) {
                                                  setState(() {
                                                    selectedEvaluatedGroup =
                                                        value;
                                                  });
                                                },
                                              )
                                      : SizedBox(),
                                ],
                              );
                            },
                          ),
                          // selectedEvaluatedType?.evaluationTypeId.toInt() == 2
                          //     ? SizedBox(height: 12)
                          //     : SizedBox(),
                          // CustomTextField(
                          //   hintText: 'Month / Year',
                          //   height: 50,
                          //   readOnly: true,
                          //   bottomMargin: 0,
                          //   suffixWidget: SvgPicture.asset(
                          //     'assets/images/svg/ic_drop_down.svg',
                          //     color: AppColors.primaryDark,
                          //   ),
                          //   controller: monthYearDateController,
                          //   fontWeight: FontWeight.normal,
                          //   inputType: TextInputType.text,
                          //   fillColor: AppColors.lightGreyColor,
                          //   hintColor: AppColors.primaryDark,
                          //   onTap: () async {
                          //     String date =
                          //         await CustomDateTimePicker.selectMonthYear(
                          //             context);
                          //     DateTime dateTime =
                          //         DateFormat("dd/MM/yyyy").parse(date);
                          //     monthYearDateController.text =
                          //         DateFormat("MM-yyyy").format(dateTime);
                          //   },
                          // ),
                          const SizedBox(height: 90),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: TextView(
                                'Upload Attachment',
                                color: AppColors.primaryDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: '',
                                    height: 50,
                                    readOnly: true,
                                    bottomMargin: 0,
                                    fontSize: 14,
                                    controller: fileNameController,
                                    fontWeight: FontWeight.normal,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                  ),
                                ),
                                CustomButton(
                                  height: 50,
                                  width: 90,
                                  borderRadius: 15,
                                  onPressed: () {
                                    if (result != null) {
                                      DialogUtils.confirmationDialog(
                                        context: context,
                                        title: 'Confirmation!',
                                        content:
                                            'Are you sure you want to remove the file?',
                                        onPressYes: () {
                                          fileNameController.clear();
                                          result = null;
                                          setState(() {});
                                        },
                                      );
                                    }
                                  },
                                  title: 'Remove',
                                  isEnabled: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomButton(
                              height: 50,
                              width: 120,
                              borderRadius: 15,
                              onPressed: () async {
                                result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  allowedExtensions: [
                                    'xlsx',
                                    // 'xls',
                                    'xlsm',
                                    'xlsb',
                                    'xltx',
                                  ],
                                );
                                if (result == null) {
                                  DisplayUtils.showToast(
                                    context,
                                    "No file selected",
                                  );
                                } else {
                                  File file = File(
                                    result!.files.single.path.toString(),
                                  );
                                  fileNameController.text =
                                      result!.files.single.name;
                                  setState(() {});
                                  // var bytes = file.readAsBytesSync();
                                  // List<Map<String, dynamic>> finalResult =
                                  //     extractDataFromExcel(bytes: bytes);
                                  // String jsonString = json.encode(finalResult);
                                  // studentData =
                                  //     (json.decode(jsonString) as List)
                                  //         .map((data) => studentFromJson(data))
                                  //         .toList();

                                  final bytes = file.readAsBytesSync();
                                  excelFileBytes = bytes;
                                  final excelData = extractDataFromExcel(
                                    bytes: bytes,
                                  );

                                  studentData = excelData
                                      .map((e) => StudentModel.fromJson(e))
                                      .toList();

                                  print(
                                    'STUDENTS COUNT: ${studentData.length}',
                                  );
                                }
                              },
                              title: 'Browse',
                              isEnabled: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child:
                            BlocConsumer<
                              ImportExamResultCubit,
                              ImportExamResultState
                            >(
                              listener: (context, examResultState) {
                                if (examResultState.importExamResultStatus ==
                                    ImportExamResultStatus.loading) {
                                  DisplayUtils.showLoader();
                                } else if (examResultState
                                        .importExamResultStatus ==
                                    ImportExamResultStatus.success) {
                                  DisplayUtils.removeLoader();
                                  DisplayUtils.showToast(
                                    context,
                                    "Exam result added successfully!",
                                  );
                                  NavRouter.pop(context);
                                } else if (examResultState
                                        .importExamResultStatus ==
                                    ImportExamResultStatus.failure) {
                                  DisplayUtils.removeLoader();
                                  DisplayUtils.showToast(
                                    context,
                                    examResultState.failure.message,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  height: 50,
                                  borderRadius: 15,
                                  onPressed: () {
                                    bool _validateFields() {
                                      if (dropdownValueClass == null ||
                                          classId.isEmpty) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Class",
                                        );
                                        return false;
                                      }
                                      if (dropdownValueSection == null ||
                                          sectionId.isEmpty) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Section",
                                        );
                                        return false;
                                      }
                                      if (selectedEvaluatedType == null) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Evaluation Type",
                                        );
                                        return false;
                                      }
                                      if (selectedEvaluated == null) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Evaluation",
                                        );
                                        return false;
                                      }
                                      if (selectedEvaluatedType
                                                  ?.evaluationTypeId ==
                                              2 &&
                                          selectedEvaluatedGroup == null) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please select Group Evaluation Type",
                                        );
                                        return false;
                                      }
                                      if (result == null ||
                                          excelFileBytes == null) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Please upload the exam report",
                                        );
                                        return false;
                                      }
                                      if (studentData.isEmpty) {
                                        DisplayUtils.showToast(
                                          context,
                                          "Exam report is empty!",
                                        );
                                        return false;
                                      }
                                      return true;
                                    }

                                    if (_validateFields()) {
                                      ImportExamResultDataInput input =
                                          _submitButtonPress();
                                      context.read<ImportExamResultCubit>()
                                        ..importExamResult(
                                          input,
                                          excelFileBytes!,
                                          fileNameController.text,
                                        );
                                    }
                                  },

                                  title: 'Submit',
                                  isEnabled: true,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                );
              }
              // else if (state.examClassesStatus == ExamClassesStatus.failure) {
              //   return Center(child: TextView(state.failure.message));
              // }
              return SizedBox();
            },
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  ImportExamResultDataInput _submitButtonPress() {
    fixData.clear();
    dynamicSubjects.clear();

    for (StudentModel model in studentData) {
      fixData.add(
        ResultSheetFixDataModel(
          studentId: "0", // backend handle karega
          fileNo: model.fileNo,
          obtainedMarks: model.totalObtained,
          maxMarks: model.total,
          percentage: model.percentage,
        ),
      );

      dynamicSubjects.add(
        ResultSheetDynamicSubjectModel(
          studentId: "0",
          englishLanguage: model.english,
          urdu: model.urdu,
          mathematics: model.mathematics,
          islamiyat: model.islamiyat,
          biology: model.wa, // agar WA biology ke liye use ho raha
          chemistry: model.computer,
          physics: "0",
          pakistanStudies: "0",
        ),
      );
    }

    return ImportExamResultDataInput(
      ucLoginUserId: authRepository.user.userId.toInt(),
      classId: classId.toInt(),
      sectionId: sectionId.toInt(),
      evaluationGroupId: selectedEvaluatedGroup?.evaluationGroupId ?? 0,
      evaluationIdFk: selectedEvaluated?.evaluationId ?? 0,
    );
  }
}
