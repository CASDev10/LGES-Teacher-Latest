import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/text_view.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/storage_service/storage_service.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../../utils/display/display_utils.dart';
import '../../class_section/cubit/classes_cubit/classes_cubit.dart';
import '../../class_section/cubit/sections_cubit/sections_cubit.dart';
import '../../class_section/model/classes_model.dart';
import '../../class_section/model/sections_model.dart';
import '../cubits/file_sharing_cubit.dart';
import '../cubits/file_sharing_state.dart';

class FileSharingScreen extends StatefulWidget {
  const FileSharingScreen({super.key});

  @override
  State<FileSharingScreen> createState() => _FileSharingScreenState();
}

class _FileSharingScreenState extends State<FileSharingScreen> {
  String? dropdownValueClass;
  String? dropdownValueSection;
  String? dropdownValueSubject;
  String? classId;
  String? sectionId;
  List<Section>? sections;
  AuthRepository authRepository = sl<AuthRepository>();
  FilePickerResult? result;
  TextEditingController fileNameController = TextEditingController(
    text: 'No file selected',
  );
  TextEditingController descriptionController = TextEditingController();
  File? file;
  final StorageService _storageService = sl<StorageService>();

  @override
  Widget build(BuildContext context) {
    // var dummy = _storageService.getIsDummyLoginForTeacher();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClassesCubit(sl())
                ..fetchClasses(authRepository.user.schoolId.toString()),
        ),
        BlocProvider(create: (context) => SectionsCubit(sl())),
        BlocProvider(create: (context) => FileSharingCubit(sl())),
      ],
      child: BaseScaffold(
        appBar: const CustomAppbar('File Sharing', centerTitle: true),
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
                return const Center(child: LoadingIndicator());
              }
              if (classState.classesStatus == ClassesStatus.success) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            CustomDropDown(
                              allPadding: 0,
                              horizontalPadding: 15,
                              isOutline: false,
                              hintColor: AppColors.primaryDark,
                              iconColor: AppColors.primaryDark,
                              suffixIconPath: '',
                              hint: 'Class',
                              items: classState.classes
                                  .map((selectClass) => selectClass.className)
                                  .toList(),
                              onSelect: (String value) {
                                Class selectedClass = classState.classes
                                    .firstWhere(
                                      (element) => element.className == value,
                                    );
                                setState(() {
                                  classId = selectedClass.classId.toString();
                                  dropdownValueClass = value;
                                  context.read<SectionsCubit>().fetchSections(
                                    selectedClass.classId.toString(),
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
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
                              builder: (context, sectionState) {
                                sections = sectionState.sections;
                                return GestureDetector(
                                  onTap: dropdownValueClass == null
                                      ? () {
                                          DisplayUtils.showSnackBar(
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
                                    hint: 'Section',
                                    items: sectionState.sections
                                        .map((section) => section.sectionName)
                                        .toList(),
                                    onSelect: (String value) {
                                      setState(() {
                                        dropdownValueSection = value;
                                        Section selectedSection = sectionState
                                            .sections
                                            .firstWhere(
                                              (element) =>
                                                  element.sectionName == value,
                                            );
                                        sectionId = selectedSection.sectionId
                                            .toString();
                                        Class selectedClass = classState.classes
                                            .firstWhere(
                                              (element) =>
                                                  element.className ==
                                                  dropdownValueClass,
                                            );
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const Align(
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
                                  if (fileNameController.text.isNotEmpty &&
                                      fileNameController.text
                                              .trim()
                                              .toString() !=
                                          'No file selected')
                                    CustomButton(
                                      height: 50,
                                      width: 110,
                                      borderRadius: 15,
                                      onPressed: () {
                                        if (result != null) {
                                          DialogUtils.confirmationDialog(
                                            context: context,
                                            title: 'Confirmation!',
                                            content:
                                                'Are you sure you want to remove the file?',
                                            onPressYes: () {
                                              fileNameController.text =
                                                  'No file selected';
                                              result = null;
                                              setState(() {});
                                              NavRouter.pop(context);
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
                                      'pdf',
                                      'doc',
                                      'docx',
                                      'txt',
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'xlsx',
                                      'xlsm',
                                      'xlsb',
                                      'xltx',
                                      'ppt',
                                      'pptx',
                                    ],
                                  );
                                  if (result == null) {
                                    DisplayUtils.showToast(
                                      context,
                                      "No file selected",
                                    );
                                  } else {
                                    file = File(
                                      result!.files.single.path.toString(),
                                    );
                                    fileNameController.text =
                                        result!.files.single.name;
                                    setState(() {});
                                  }
                                },
                                title: 'Browse',
                                isEnabled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'Description',
                              height: 230,
                              inputType: TextInputType.text,
                              fillColor: AppColors.lightGreyColor,
                              maxLines: 7,
                              controller: descriptionController,
                              hintColor: AppColors.primaryDark,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    BlocConsumer<FileSharingCubit, FileSharingState>(
                      listener: (context, fileSharingState) {
                        if (fileSharingState.status ==
                            FileSharingStatus.loading) {
                          DisplayUtils.showLoader();
                        } else if (fileSharingState.status ==
                            FileSharingStatus.success) {
                          DisplayUtils.removeLoader();
                          DisplayUtils.showToast(
                            context,
                            "File uploaded successfully!",
                          );
                          NavRouter.pop(context);
                        } else if (fileSharingState.status ==
                            FileSharingStatus.failure) {
                          DisplayUtils.removeLoader();
                          DisplayUtils.showSnackBar(
                            context,
                            fileSharingState.failure.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomButton(
                            height: 50,
                            borderRadius: 15,
                            onPressed: () {
                              /*if (!dummy) {
                                if (sectionId != null) {
                                  if (file != null) {
                                    var input = FileSharingInput(
                                        description: descriptionController.text
                                            .trim()
                                            .toString(),
                                        classId: classId,
                                        sectionId: sectionId);
                                    print(input.toJson());
                                    context
                                        .read<FileSharingCubit>()
                                        .uploadTeacherFile(input, file);
                                  } else {
                                    DisplayUtils.showSnackBar(
                                        context, "Please select a file!");
                                    return;
                                  }
                                } else {
                                  DisplayUtils.showSnackBar(
                                      context, "Please select section first!");
                                  return;
                                }
                              } else {
                                DisplayUtils.showSnackBar(
                                    context, "File upload successfully");
                              }*/
                            },
                            title: 'Submit',
                            isEnabled: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              if (classState.classesStatus == ClassesStatus.failure) {
                return Center(child: Text(classState.failure.message));
              }
              return const SizedBox();
            },
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }
}
