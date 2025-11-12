import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/subject_cubit/subjects_cubit.dart';
import 'package:lges_teacher_app/module/file_sharing/cubits/notification_types/notification_types_state.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/generic_drop_down.dart';
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
import '../../daily_diary/models/subjects_response.dart';
import '../cubits/file_sharing_cubit.dart';
import '../cubits/file_sharing_state.dart';
import '../cubits/get_students/get_students_cubit.dart';
import '../cubits/notification_types/notification_types_cubit.dart';
import '../models/notification_types_response.dart';

class FileSharingScreen extends StatefulWidget {
  const FileSharingScreen({super.key});

  @override
  State<FileSharingScreen> createState() => _FileSharingScreenState();
}

class _FileSharingScreenState extends State<FileSharingScreen> {
  String? dropdownValueClass;
  String? dropdownValueSection;
  String? dropdownValueSubject;
  String? dropdownValueNotificationType;
  String? classId;
  String? sectionId;
  String? subjectId;
  String? notificationTypeId;
  AuthRepository authRepository = sl<AuthRepository>();
  FilePickerResult? result;
  TextEditingController fileNameController = TextEditingController(
    text: 'No file selected',
  );
  TextEditingController descriptionController = TextEditingController();
  File? file;
  final StorageService _storageService = sl<StorageService>();

  /// 🔹 Helper: Reset dependent fields
  void resetClassData() {
    dropdownValueClass = null;
    dropdownValueSection = null;
    dropdownValueSubject = null;
    classId = null;
    sectionId = null;
    subjectId = null;
  }

  void resetSectionData() {
    dropdownValueSection = null;
    dropdownValueSubject = null;
    sectionId = null;
    subjectId = null;
  }

  void resetSubjectData() {
    dropdownValueSubject = null;
    subjectId = null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ClassesCubit(sl())),
        BlocProvider(create: (context) => SectionsCubit(sl())),
        BlocProvider(create: (context) => SubjectsCubit(sl())),
        BlocProvider(create: (context) => FileSharingCubit(sl())),
        BlocProvider(create: (context) => GetStudentsCubit(sl())),
        BlocProvider(
          create: (context) =>
              NotificationTypeCubit(sl())..getNotificationTypes(),
        ),
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // 🔹 Notification Type Dropdown
                      BlocBuilder<NotificationTypeCubit, NotificationTypeState>(
                        builder: (context, notificationTypeState) {
                          if (notificationTypeState.status ==
                              NotificationTypeStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (notificationTypeState.status ==
                              NotificationTypeStatus.success) {
                            return GenericDropDown<NotificationTypeModel>(
                              allPadding: 0,
                              horizontalPadding: 15,
                              isOutline: false,
                              hintColor: AppColors.primaryDark,
                              iconColor: AppColors.primaryDark,
                              suffixIconPath: '',
                              hint: 'Select Notification Type',
                              items: notificationTypeState.types,
                              onSelect: (NotificationTypeModel value) {
                                setState(() {
                                  dropdownValueNotificationType =
                                      value.notificationTypeName;
                                  notificationTypeId = value.notificationTypeId
                                      .toString();

                                  // 🔹 Reset dependent dropdowns
                                  resetClassData();
                                });

                                // Fetch classes
                                context.read<ClassesCubit>().fetchClasses(
                                  authRepository.user.schoolId.toString(),
                                );
                              },
                              getLabel: (model) => model.notificationTypeName,
                            );
                          }
                          if (notificationTypeState.status ==
                              NotificationTypeStatus.failure) {
                            return Center(
                              child: Text(notificationTypeState.message),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Class Dropdown
                      BlocConsumer<ClassesCubit, ClassesState>(
                        listener: (context, classState) {
                          if (classState.classesStatus ==
                              ClassesStatus.loading) {
                            DisplayUtils.showLoader();
                          } else {
                            DisplayUtils.removeLoader();
                          }
                        },
                        builder: (context, classState) {
                          return GestureDetector(
                            onTap: dropdownValueNotificationType == null
                                ? () {
                                    DisplayUtils.showSnackBar(
                                      context,
                                      "Please Select Notification Type",
                                    );
                                  }
                                : null,
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
                                  classId = value.classId.toString();

                                  // 🔹 Reset dependent dropdowns
                                  resetSectionData();
                                });

                                // Fetch sections
                                context.read<SectionsCubit>().fetchSections(
                                  classId!,
                                );
                              },
                              getLabel: (classModel) => classModel.className,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Section Dropdown
                      BlocConsumer<SectionsCubit, SectionsState>(
                        listener: (context, sectionStatus) {
                          if (sectionStatus.sectionsStatus ==
                              SectionsStatus.loading) {
                            DisplayUtils.showLoader();
                          } else {
                            DisplayUtils.removeLoader();
                          }
                        },
                        builder: (context, sectionStatus) {
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
                              hint: dropdownValueSection ?? 'Select Section',
                              items: sectionStatus.sections,
                              onSelect: (Section value) {
                                setState(() {
                                  dropdownValueSection = value.sectionName;
                                  sectionId = value.sectionId.toString();

                                  // 🔹 Reset dependent dropdown
                                  resetSubjectData();
                                });

                                // Fetch subjects
                                context.read<SubjectsCubit>().fetchSubjects(
                                  classId!,
                                );
                              },
                              getLabel: (section) => section.sectionName,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Subject Dropdown
                      BlocConsumer<SubjectsCubit, SubjectsState>(
                        listener: (context, subjectsState) {
                          if (subjectsState.subjectsStatus ==
                              SectionsStatus.loading) {
                            DisplayUtils.showLoader();
                          } else {
                            DisplayUtils.removeLoader();
                          }
                        },
                        builder: (context, subjectsState) {
                          return GestureDetector(
                            onTap: dropdownValueSection == null
                                ? () {
                                    DisplayUtils.showSnackBar(
                                      context,
                                      "Please select Section First",
                                    );
                                  }
                                : null,
                            child: GenericDropDown<SubjectModel>(
                              allPadding: 0,
                              horizontalPadding: 15,
                              isOutline: false,
                              hintColor: AppColors.primaryDark,
                              iconColor: AppColors.primaryDark,
                              suffixIconPath: '',
                              hint: dropdownValueSubject ?? 'Select Subject',
                              items: subjectsState.subjects,
                              onSelect: (SubjectModel value) {
                                setState(() {
                                  dropdownValueSubject = value.subjectName;
                                  subjectId = value.subjectId.toString();
                                });

                                context
                                    .read<GetStudentsCubit>()
                                    .getGetStudents();
                              },
                              getLabel: (subject) => subject.subjectName,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // 🔹 File Upload Section
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
                            if (fileNameController.text.isNotEmpty &&
                                fileNameController.text.trim() !=
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
                                'jpg',
                                'jpeg',
                                'png',
                                'gif',
                                'pdf',
                              ],
                            );
                            if (result == null) {
                              DisplayUtils.showToast(
                                context,
                                "No file selected",
                              );
                            } else {
                              file = File(result!.files.single.path.toString());
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

              // 🔹 Submit Button
              BlocConsumer<FileSharingCubit, FileSharingState>(
                listener: (context, fileSharingState) {
                  if (fileSharingState.status == FileSharingStatus.loading) {
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
                        // Your upload logic here
                      },
                      title: 'Submit',
                      isEnabled: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        hMargin: 0,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }
}
