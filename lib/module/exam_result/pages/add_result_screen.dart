import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
import 'package:lges_teacher_app/module/exam_result/pages/process_result_screen.dart';
import 'package:lges_teacher_app/module/exam_result/pages/show_result_screen.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/custom_date_time_picker.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../auth/repo/auth_repository.dart';
import '../cubit/exam_class_cubit/exam_classes_state.dart';
import '../models/exam_class_response.dart';

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
  TextEditingController monthYearDateController = TextEditingController();
  List<StudentModel> studentData = [];
  List<ResultSheetFixDataModel> fixData = [];
  List<ResultSheetDynamicSubjectModel> dynamicSubjects = [];
  String classId = '';
  String sectionId = '';

  List<Map<String, dynamic>> extractDataFromExcel({required Uint8List bytes}) {
    Excel excel = Excel.decodeBytes(bytes);
    final List<Map<String, dynamic>> result = [];
    final Map<String, dynamic> createMap = {};
    final keys = <String>[];

    // get data from first sheet
    final int n = excel.tables[excel.tables.keys.first]?.rows.length ?? 0;
    debugPrint('n => $n');
    // final List<Data?> rows in excel.tables[excel.tables.keys.first]!.rows
    for (int i = 0; i < n; i++) {
      final rows = excel.tables[excel.tables.keys.first]!.rows[i];
      for (int j = 0; j < rows.length; j++) {
        // index = 0 it will show an header of sheet
        final row = rows[j];
        // Create Header(Keys) for map
        if (i == 0 && row != null) {
          // get header/key from excel and make it list
          keys.add('${row.value.toString()}'); // Store key as string
          // Default value is empty
          createMap['${row.value.toString()}'] = "";
        }
        // add value in map
        else if (i > 0 && row != null) {
          createMap[keys[j]] = row.value.toString();
        }
      }
      if (i != 0) result.add(Map<String, dynamic>.from(createMap));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExamClassesCubit(sl())
            ..fetchClasses(authRepository.user.schoolId.toString()),
        ),
        BlocProvider(
          create: (context) => ExamClassSectionsCubit(sl()),
        ),
        BlocProvider(
          create: (context) => ImportExamResultCubit(sl()),
        ),
      ],
      child: BaseScaffold(
        appBar: const CustomAppbar(
          'Exam Result',
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: BlocBuilder<ExamClassesCubit, ExamClassesState>(
            builder: (context, state) {
              if (state.examClassesStatus == ExamClassesStatus.loading) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state.examClassesStatus == ExamClassesStatus.success) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20) +
                      const EdgeInsets.symmetric(vertical: 30),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomDropDown(
                            allPadding: 0,
                            horizontalPadding: 15,
                            isOutline: false,
                            hintColor: AppColors.primaryDark,
                            iconColor: AppColors.primaryDark,
                            suffixIconPath: '',
                            hint: 'Select Class',
                            items: state.classes
                                .map((selectClass) => selectClass.className)
                                .toList(),
                            onSelect: (String value) {
                              ExamClassModel selectedClass = state.classes
                                  .firstWhere(
                                      (element) => element.className == value);
                              setState(() {
                                dropdownValueClass = value;
                                classId = selectedClass.classId.toString();
                                context
                                    .read<ExamClassSectionsCubit>()
                                    .fetchClassSections(
                                        selectedClass.classId.toString());
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          BlocConsumer<ExamClassSectionsCubit,
                              ExamClassSectionsState>(
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
                                DisplayUtils.showSnackBar(context,
                                    examClassSectionsState.failure.message);
                              }
                            },
                            builder: (context, examClassSectionsState) {
                              sections = examClassSectionsState.classSections;
                              return GestureDetector(
                                onTap: dropdownValueClass == null
                                    ? () {
                                        DisplayUtils.showSnackBar(context,
                                            "Please select Class First");
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
                                            .firstWhere((element) =>
                                                element.sectionName == value);
                                    setState(() {
                                      sectionId =
                                          selectedSection.sectionId.toString();
                                      dropdownValueSection = value;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                            hintText: 'Month / Year',
                            height: 50,
                            readOnly: true,
                            bottomMargin: 0,
                            suffixWidget: SvgPicture.asset(
                              'assets/images/svg/ic_drop_down.svg',
                              color: AppColors.primaryDark,
                            ),
                            controller: monthYearDateController,
                            fontWeight: FontWeight.normal,
                            inputType: TextInputType.text,
                            fillColor: AppColors.lightGreyColor,
                            hintColor: AppColors.primaryDark,
                            onTap: () async {
                              String date =
                                  await CustomDateTimePicker.selectMonthYear(
                                      context);
                              DateTime dateTime =
                                  DateFormat("dd/MM/yyyy").parse(date);
                              monthYearDateController.text =
                                  DateFormat("MM-yyyy").format(dateTime);
                            },
                          ),
                          const SizedBox(
                            height: 90,
                          ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
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
                                    if(result != null){
                                      DialogUtils.confirmationDialog(
                                          context: context,
                                          title: 'Confirmation!',
                                          content:
                                          'Are you sure you want to remove the file?',
                                          onPressYes: () {
                                            fileNameController.clear();
                                            result = null;
                                            setState(() {});
                                          });
                                    }
                                  },
                                  title: 'Remove',
                                  isEnabled: true,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
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
                                    'xlsm',
                                    'xlsb',
                                    'xltx'
                                  ],
                                );
                                if (result == null) {
                                  DisplayUtils.showToast(
                                      context, "No file selected");
                                } else {
                                  File file = File(
                                      result!.files.single.path.toString());
                                  fileNameController.text =
                                      result!.files.single.name;
                                  setState(() {});
                                  var bytes = file.readAsBytesSync();
                                  List<Map<String, dynamic>> finalResult =
                                      extractDataFromExcel(bytes: bytes);
                                  String jsonString = json.encode(finalResult);
                                  studentData =
                                      (json.decode(jsonString) as List)
                                          .map((data) => studentFromJson(data))
                                          .toList();
                                }
                              },
                              title: 'Browse',
                              isEnabled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: BlocConsumer<ImportExamResultCubit, ImportExamResultState>(
                          listener: (context, examResultState) {
                            if(examResultState.importExamResultStatus == ImportExamResultStatus.loading){
                              DisplayUtils.showLoader();
                            }else if(examResultState.importExamResultStatus == ImportExamResultStatus.success){
                              DisplayUtils.removeLoader();
                              DisplayUtils.showToast(context, "Exam result added successfully!");
                              NavRouter.pop(context);
                            }else if(examResultState.importExamResultStatus == ImportExamResultStatus.failure){
                              DisplayUtils.removeLoader();
                              DisplayUtils.showSnackBar(context, examResultState.failure.message);
                            }
                          },
                          builder: (context, state) {
                            return CustomButton(
                              height: 50,
                              borderRadius: 15,
                              onPressed: () {
                                if (sectionId.isNotEmpty) {
                                  if (monthYearDateController.text
                                      .toString()
                                      .isNotEmpty) {
                                    if (result != null) {
                                      if (studentData.isNotEmpty) {
                                        ImportExamResultDataInput input =
                                            _submitButtonPress();
                                        context.read<ImportExamResultCubit>()
                                          ..importExamResult(input);
                                      } else {
                                        DisplayUtils.showSnackBar(
                                            context, "Exam report is empty!");
                                      }
                                    } else {
                                      DisplayUtils.showSnackBar(context,
                                          "Please import the exam report!");
                                    }
                                  } else {
                                    DisplayUtils.showSnackBar(
                                        context, "Please select month/year!");
                                  }
                                } else {
                                  DisplayUtils.showSnackBar(
                                      context, "Please select section first!");
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
              } else if (state.examClassesStatus == ExamClassesStatus.failure) {
                return Center(
                  child: TextView(state.failure.message),
                );
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

  ImportExamResultDataInput _submitButtonPress() {
    for (StudentModel model in studentData) {
      ResultSheetFixDataModel resultSheetFixData = ResultSheetFixDataModel(
          studentId: model.studentId,
          fileNo: model.fileNo,
          obtainedMarks: model.obtainedMarks,
          maxMarks: model.maxMarks,
          percentage: model.percentage);
      fixData.add(resultSheetFixData);
      ResultSheetDynamicSubjectModel resultSheetDynamicSubject =
          ResultSheetDynamicSubjectModel(
              studentId: model.studentId,
              biology: model.biology,
              chemistry: model.chemistry,
              englishLanguage: model.englishLanguage,
              islamiyat: model.islamiyat,
              mathematics: model.mathematics,
              pakistanStudies: model.pakistanStudies,
              physics: model.physics,
              urdu: model.urdu);
      dynamicSubjects.add(resultSheetDynamicSubject);
    }

    List<Map<String, dynamic>> fixDataJsonList =
        fixData.map((model) => model.toJson()).toList();
    List<Map<String, dynamic>> dynamicSubjectJsonList =
        dynamicSubjects.map((model) => model.toJson()).toList();

    ImportExamResultDataInput input = ImportExamResultDataInput(
        ucEntityId: authRepository.user.entityId.toString(),
        ucLoginUserId: authRepository.user.userId.toString(),
        ucSchoolId: authRepository.user.schoolId.toString(),
        classId: classId,
        sectionId: sectionId,
        monthYear: monthYearDateController.text.toString(),
        fixData: jsonEncode(fixDataJsonList),
        dynamicSubject: jsonEncode(dynamicSubjectJsonList));

    return input;
  }
}
