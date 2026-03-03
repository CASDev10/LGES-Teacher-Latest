import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/components/custom_textfield.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/add_diary_cubit/add_diary_cubit.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/add_diary_cubit/add_diary_state.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/subject_cubit/subjects_cubit.dart';
import 'package:lges_teacher_app/module/daily_diary/models/add_diary_input.dart';
import 'package:lges_teacher_app/module/daily_diary/models/subjects_response.dart';
import 'package:lges_teacher_app/module/daily_diary/models/update_diary_input.dart';
import 'package:lges_teacher_app/utils/custom_date_time_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../components/generic_drop_down.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../../utils/display/display_utils.dart';
import '../../auth/repo/auth_repository.dart';
import '../../class_section/cubit/classes_cubit/classes_cubit.dart';
import '../../class_section/cubit/sections_cubit/sections_cubit.dart';
import '../../class_section/model/classes_model.dart';
import '../../class_section/model/sections_model.dart';
import '../../file_sharing/cubits/get_students/get_students_cubit.dart';
import '../models/diary_list_response.dart';

class AddDailyDiaryScreen extends StatefulWidget {
  final DiaryModel? diary;
  const AddDailyDiaryScreen({Key? key, this.diary}) : super(key: key);
  @override
  State<AddDailyDiaryScreen> createState() => _AddDailyDiaryScreenState();
}

class _AddDailyDiaryScreenState extends State<AddDailyDiaryScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController textBoxController = TextEditingController();
  TextEditingController fileNameController = TextEditingController(
    text: 'No file selected',
  );

  String? dropdownValueClass;
  String? dropdownValueSection;
  String? dropdownValueSubject;

  String? classId;
  String? sectionId;
  String? subjectId;

  List<Section>? sections;
  List<SubjectModel>? subjects;

  AuthRepository authRepository = sl<AuthRepository>();
  FilePickerResult? result;
  File? file;
  String fileUrl = '';

  AddDiaryInput _onSaveButtonPressed() {
    DateTime fromDate = DateFormat("dd/MM/yyyy").parse(fromDateController.text);
    DateTime toDate = DateFormat("dd/MM/yyyy").parse(toDateController.text);
    AddDiaryInput input = AddDiaryInput(
      dateFrom: DateFormat("yyyy-MM-dd").format(fromDate),
      dateTo: DateFormat("yyyy-MM-dd").format(toDate),
      sectionIdFk: sectionId.toString(),
      classIdFk: classId.toString(),
      subjectIdFk: subjectId.toString(),
      text: textBoxController.text,
      ucSchoolId: authRepository.user.schoolId.toString(),
      ucLoginUserId: authRepository.user.userId.toString(),
    );
    return input;
  }

  Widget buildFilePreview() {
    if (file != null) {
      final path = file!.path.toLowerCase();
      final isImage =
          path.endsWith(".jpg") ||
          path.endsWith(".jpeg") ||
          path.endsWith(".png") ||
          path.endsWith(".gif");
      final isPDF = path.endsWith(".pdf");

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  isPDF ? CupertinoIcons.doc_text_fill : CupertinoIcons.photo,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fileNameController.text,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomButton(
                  height: 40,
                  width: 90,
                  borderRadius: 10,
                  onPressed: () {
                    DialogUtils.confirmationDialog(
                      context: context,
                      title: 'Confirmation!',
                      content: 'Are you sure you want to remove the file?',
                      onPressYes: () {
                        fileNameController.text = 'No file selected';
                        result = null;
                        file = null;
                        setState(() {});
                        NavRouter.pop(context);
                      },
                    );
                  },
                  title: 'Remove',
                  isEnabled: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else if (isPDF)
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGreyColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PDFView(
                  filePath: file!.path,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                  backgroundColor: Colors.white,
                  onError: (error) => debugPrint('PDF error: $error'),
                ),
              ),
            )
          else
            const Text(
              'Preview not available for this file type',
              style: TextStyle(color: AppColors.primaryDark, fontSize: 13),
            ),
        ],
      );
    }
    // -------- File URL preview (including PDF) --------
    else if (fileUrl.isNotEmpty) {
      final lowerUrl = fileUrl.toLowerCase();
      final isImage =
          lowerUrl.endsWith(".jpg") ||
          lowerUrl.endsWith(".jpeg") ||
          lowerUrl.endsWith(".png") ||
          lowerUrl.endsWith(".gif");
      final isPDF = lowerUrl.endsWith(".pdf");

      return FutureBuilder<File?>(
        future: isPDF ? _downloadPdfFromUrl(fileUrl) : Future.value(null),
        builder: (context, snapshot) {
          Widget previewWidget;

          if (snapshot.connectionState == ConnectionState.waiting && isPDF) {
            previewWidget = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            previewWidget = const Text(
              'Error loading preview',
              style: TextStyle(color: Colors.red),
            );
          } else if (isImage) {
            previewWidget = ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fileUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Unable to load image preview',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (isPDF && snapshot.hasData && snapshot.data != null) {
            previewWidget = Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.lightGreyColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PDFView(
                  filePath: snapshot.data!.path,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                  backgroundColor: Colors.white,
                  onError: (error) => debugPrint('PDF error: $error'),
                ),
              ),
            );
          } else {
            previewWidget = const Text(
              'Preview not available for this file type',
              style: TextStyle(color: AppColors.primaryDark, fontSize: 13),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPDF
                          ? CupertinoIcons.doc_text_fill
                          : CupertinoIcons.photo,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fileUrl.split('/').last,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.arrow_up_right,
                      size: 18,
                      color: AppColors.primaryDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              previewWidget,
            ],
          );
        },
      );
    }
    // --- No file selected ---
    else {
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
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
          ],
        ),
      );
    }
  }

  // --- Helper to download PDF from URL ---
  Future<File?> _downloadPdfFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp.pdf');
        await file.writeAsBytes(bytes, flush: true);
        return file;
      }
    } catch (e) {
      debugPrint('PDF download error: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.diary != null) {
      fromDateController.text = widget.diary!.dateFromString;
      toDateController.text = widget.diary!.dateToString;
      textBoxController.text = widget.diary!.text;
      dropdownValueClass = widget.diary!.className;
      dropdownValueSection = widget.diary!.sectionName;
      dropdownValueSubject = widget.diary!.subjectName;
      classId = widget.diary!.classIdFk.toString();
      sectionId = widget.diary!.sectionIdFk.toString();
      subjectId = widget.diary!.subjectIdFk.toString();
      fileUrl = widget.diary!.systemFileName;
      print("File url $fileUrl");
    }
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
        BlocProvider(create: (context) => SubjectsCubit(sl())),
        BlocProvider(create: (context) => AddDiaryCubit(sl())),
        BlocProvider(create: (context) => GetStudentsCubit(sl())),
      ],
      child: BaseScaffold(
        appBar: CustomAppbar(
          '${widget.diary != null ? 'Update' : 'Add'} Diary Work',
          centerTitle: true,
        ),
        body: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 20) +
              const EdgeInsets.symmetric(vertical: 30),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'From Date',
                  height: 50,
                  inputType: TextInputType.text,
                  fillColor: AppColors.lightGreyColor,
                  hintColor: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                  readOnly: true,
                  fontSize: 16,
                  suffixWidget: SvgPicture.asset(
                    'assets/images/svg/ic_drop_down.svg',
                    color: AppColors.primaryDark,
                  ),
                  onTap: widget.diary == null
                      ? () async {
                          fromDateController.text =
                              await CustomDateTimePicker.selectDiaryDate(
                                context,
                              );
                        }
                      : null,
                  controller: fromDateController,
                ),
                CustomTextField(
                  hintText: 'To Date',
                  height: 50,
                  fontSize: 16,
                  inputType: TextInputType.text,
                  fillColor: AppColors.lightGreyColor,
                  hintColor: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                  readOnly: true,
                  suffixWidget: SvgPicture.asset(
                    'assets/images/svg/ic_drop_down.svg',
                    color: AppColors.primaryDark,
                  ),
                  onTap: widget.diary == null
                      ? () async {
                          toDateController.text =
                              await CustomDateTimePicker.selectDiaryDate(
                                context,
                              );
                        }
                      : null,
                  controller: toDateController,
                ),
                BlocConsumer<ClassesCubit, ClassesState>(
                  listener: (context, classState) {
                    if (classState.classesStatus == ClassesStatus.loading) {
                      DisplayUtils.showLoader();
                    } else if (classState.classesStatus ==
                        ClassesStatus.success) {
                      DisplayUtils.removeLoader();
                    } else if (classState.classesStatus ==
                        ClassesStatus.failure) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showToast(
                        context,
                        classState.failure.message,
                      );
                    }
                  },
                  builder: (context, classState) {
                    return GestureDetector(
                      onTap: widget.diary != null
                          ? () {
                              DisplayUtils.showToast(
                                context,
                                "You can't change class while updating diary.",
                              );
                            }
                          : null,
                      child: AbsorbPointer(
                        absorbing: widget.diary != null,
                        child: GenericDropDown<Class>(
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
                              dropdownValueSubject = null;
                              sections = [];
                              subjects = [];
                              classId = value.classId.toString();
                            });
                            context.read<SectionsCubit>().fetchSections(
                              classId.toString(),
                            );
                          },
                          getLabel: (classModel) => classModel.className,
                        ),
                      ),
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
                      DisplayUtils.showToast(
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
                              DisplayUtils.showToast(
                                context,
                                "Please select Class First",
                              );
                            }
                          : null,
                      child: AbsorbPointer(
                        absorbing: widget.diary != null,
                        child: GenericDropDown<Section>(
                          allPadding: 0,
                          horizontalPadding: 15,
                          isOutline: false,
                          hintColor: AppColors.primaryDark,
                          iconColor: AppColors.primaryDark,
                          suffixIconPath: '',
                          hint: dropdownValueSection ?? 'Select Section',
                          items: sectionStatus.sections,
                          onSelect: (Section value) {
                            setState(() {
                              dropdownValueSection = value.classSection;
                              dropdownValueSubject = null;
                              subjects = [];
                              sectionId = value.sectionIdFk.toString();
                            });
                            context.read<SubjectsCubit>().fetchSubjects(
                              classId!,
                              sectionId!,
                            );
                          },
                          getLabel: (section) => section.classSection,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                BlocConsumer<SubjectsCubit, SubjectsState>(
                  listener: (context, subjectsState) {
                    if (subjectsState.subjectsStatus ==
                        SectionsStatus.loading) {
                      DisplayUtils.showLoader();
                    } else if (subjectsState.subjectsStatus ==
                        SectionsStatus.success) {
                      DisplayUtils.removeLoader();
                    } else if (subjectsState.subjectsStatus ==
                        SectionsStatus.failure) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showToast(
                        context,
                        subjectsState.failure.message,
                      );
                    }
                  },
                  builder: (context, subjectsState) {
                    subjects = subjectsState.subjects;
                    return GestureDetector(
                      onTap: dropdownValueSection == null
                          ? () {
                              DisplayUtils.showToast(
                                context,
                                "Please select section First",
                              );
                            }
                          : null,
                      child: AbsorbPointer(
                        absorbing: widget.diary != null,
                        child: GenericDropDown<SubjectModel>(
                          allPadding: 0,
                          horizontalPadding: 15,
                          isOutline: false,
                          hintColor: AppColors.primaryDark,
                          iconColor: AppColors.primaryDark,
                          suffixIconPath: '',
                          hint: dropdownValueSubject ?? 'Select Subjects',
                          items: subjectsState.subjects,
                          onSelect: (SubjectModel value) {
                            setState(() {
                              dropdownValueSubject = value.subjectName;
                              subjectId = value.subjectId.toString();
                            });
                          },
                          getLabel: (section) => section.subjectName,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                buildFilePreview(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomButton(
                    height: 50,
                    width: 180,
                    borderRadius: 15,
                    onPressed: () async {
                      result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                      );
                      if (result == null) {
                        DisplayUtils.showToast(context, "No file selected");
                      } else {
                        file = File(result!.files.single.path.toString());
                        fileNameController.text = result!.files.single.name;
                        setState(() {});
                      }
                    },
                    title: 'Upload Picture',
                    isEnabled: true,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Diary Description',
                  height: 230,
                  inputType: TextInputType.text,
                  fillColor: AppColors.lightGreyColor,
                  maxLines: 14,
                  controller: textBoxController,
                  hintColor: AppColors.grey,
                ),
                const SizedBox(height: 20),
                BlocConsumer<AddDiaryCubit, AddDiaryState>(
                  listener: (context, state) {
                    if (state.addDiaryStatus == AddDiaryStatus.loading) {
                      DisplayUtils.showLoader();
                    } else if (state.addDiaryStatus == AddDiaryStatus.success) {
                      DisplayUtils.removeLoader();
                      Fluttertoast.showToast(
                        msg:
                            "Diary ${widget.diary != null ? 'updated' : 'added'} successfully!",
                      );
                      NavRouter.pop(context);
                    } else if (state.addDiaryStatus == AddDiaryStatus.failure) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showToast(context, state.failure.message);
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      height: 50,
                      borderRadius: 15,
                      onPressed: () {
                        if (widget.diary != null) {
                          UpdateDiaryInput input = UpdateDiaryInput(
                            diaryId: widget.diary!.diaryId,
                            text: textBoxController.text,
                            ucSchoolId: authRepository.user.schoolId.toString(),
                            ucLoginUserId: authRepository.user.userId
                                .toString(),
                          );
                          context.read<AddDiaryCubit>().updateDiary(
                            input,
                            file,
                          );
                        } else {
                          AddDiaryInput input = _onSaveButtonPressed();
                          print(input.toJson());
                          context.read<AddDiaryCubit>().addDiary(input, file);
                        }
                      },
                      title: widget.diary != null ? 'Update' : 'Save',
                      isEnabled: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: AppColors.primaryDark,
        hMargin: 0,
      ),
    );
  }
}
