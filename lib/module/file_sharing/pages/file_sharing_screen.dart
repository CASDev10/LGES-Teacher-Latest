import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/subject_cubit/subjects_cubit.dart';
import 'package:lges_teacher_app/module/file_sharing/cubits/notification_types/notification_types_state.dart';
import 'package:lges_teacher_app/utils/custom_date_time_picker.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/generic_drop_down.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
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
import '../cubits/get_students/get_students_state.dart';
import '../cubits/notification_types/notification_types_cubit.dart';
import '../models/file_sharing_input.dart';
import '../models/get_students_response.dart';
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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? file;
  List<NotificationStudentModel> selectedStudents = [];

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
        appBar: const CustomAppbar('Add Notification', centerTitle: true),
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
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                GenericDropDown<NotificationTypeModel>(
                                  allPadding: 0,
                                  horizontalPadding: 15,
                                  isOutline: false,
                                  hintColor: AppColors.primaryDark,
                                  iconColor: AppColors.primaryDark,
                                  suffixIconPath: '',
                                  hint:
                                      dropdownValueNotificationType ??
                                      'Select Notification Type',
                                  items: [],
                                  onSelect: (NotificationTypeModel value) {},
                                  getLabel: (model) =>
                                      model.notificationTypeName,
                                ),
                                CircularProgressIndicator(),
                              ],
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
                                  resetSubjectData();
                                });

                                // Fetch subjects
                                context.read<SubjectsCubit>().fetchSubjects(
                                  classId!,
                                  sectionId!,
                                );
                                selectedStudents.clear();
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
                                context.read<GetStudentsCubit>().getGetStudents(
                                  classId!,
                                  sectionId!,
                                );
                              },
                              getLabel: (subject) => subject.subjectName,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),
                      // 🔹 Students Multi-Select Dropdown
                      BlocBuilder<GetStudentsCubit, GetStudentsState>(
                        builder: (context, studentState) {
                          if (studentState.status ==
                              GetStudentsStatus.loading) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                StudentMultiSelectDropdown(
                                  students:
                                      studentState.status ==
                                          GetStudentsStatus.success
                                      ? studentState.students
                                      : [],
                                  onSelectionChanged:
                                      (
                                        List<NotificationStudentModel> selected,
                                      ) {
                                        setState(() {
                                          selectedStudents = selected;
                                        });
                                      },
                                ),
                                const CircularProgressIndicator(
                                  color: AppColors.primaryDark,
                                ),
                              ],
                            );
                          }
                          return StudentMultiSelectDropdown(
                            students: studentState.students,
                            onSelectionChanged:
                                (List<NotificationStudentModel> selected) {
                                  setState(() {
                                    selectedStudents = selected;
                                  });
                                },
                          );
                        },
                      ),
                      SizedBox(height: 12),

                      // 🔹 File Upload Section
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
                                        file = null;
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
                        hintText: 'Notification Title',
                        height: 230,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        controller: titleController,
                        hintColor: AppColors.grey,
                      ),
                      CustomTextField(
                        hintText: 'Description',
                        height: 230,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        maxLines: 7,
                        controller: descriptionController,
                        hintColor: AppColors.grey,
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
                      "Notification added successfully!",
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
                      borderRadius: 15,
                      onPressed: () {
                        // 🔹 Validation checks
                        if (dropdownValueNotificationType == null ||
                            dropdownValueNotificationType!.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select Notification Type",
                          );
                          return;
                        }
                        if (dropdownValueClass == null ||
                            dropdownValueClass!.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select Class",
                          );
                          return;
                        }
                        if (dropdownValueSection == null ||
                            dropdownValueSection!.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select Section",
                          );
                          return;
                        }
                        if (dropdownValueSubject == null ||
                            dropdownValueSubject!.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select Subject",
                          );
                          return;
                        }
                        if (selectedStudents.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select students",
                          );
                          return;
                        }
                        if (titleController.text.trim().isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please enter Notification Title",
                          );
                          return;
                        }
                        if (descriptionController.text.trim().isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please enter Description",
                          );
                          return;
                        }
                        if (selectedStudents.isEmpty) {
                          DisplayUtils.showSnackBar(
                            context,
                            "Please select at least one Student",
                          );
                          return;
                        }

                        // 🔹 All validations passed — create NotificationInput
                        NotificationInput input = NotificationInput(
                          ucLoginUserId: authRepository.user.userId,
                          notificationText: descriptionController.text.trim(),
                          notificationTitle: titleController.text.trim(),
                          notificationTypeId: int.parse(notificationTypeId!),
                          fileIds: '',
                          studentIds: selectedStudents
                              .map((model) => model.studentId.toString())
                              .join(','),
                          startDate: changeDateTimeFormat(
                            DateTime.now(),
                            'yyyy-MM-dd',
                          ),
                          endDate: changeDateTimeFormat(
                            DateTime.now(),
                            'yyyy-MM-dd',
                          ),
                        );

                        print(input.toJson());

                        // 🔹 Call Cubit to submit with file
                        context.read<FileSharingCubit>().addNotification(input, file);
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

class StudentMultiSelectDropdown extends StatefulWidget {
  final List<NotificationStudentModel> students;
  final Function(List<NotificationStudentModel>) onSelectionChanged;

  /// If true -> multiple selection allowed. If false -> single selection only.
  final bool allowMultiple;

  const StudentMultiSelectDropdown({
    super.key,
    required this.students,
    required this.onSelectionChanged,
    this.allowMultiple = true,
  });

  @override
  State<StudentMultiSelectDropdown> createState() =>
      _StudentMultiSelectDropdownState();
}

class _StudentMultiSelectDropdownState
    extends State<StudentMultiSelectDropdown> {
  final List<NotificationStudentModel> _selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.students.isNotEmpty
          ? () {
              _openStudentSelectionPopup(context);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedStudents.isEmpty
                    ? 'Select Students'
                    : _selectedStudents.map((s) => s.studentName).join(', '),
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: SvgPicture.asset('assets/images/svg/ic_drop_down.svg'),
            ),
          ],
        ),
      ),
    );
  }

  void _openStudentSelectionPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        final Set<int> tempSelectedIds = _selectedStudents
            .map((e) => e.studentId)
            .toSet();
        final TextEditingController searchController = TextEditingController();
        List<NotificationStudentModel> filteredStudents = List.from(
          widget.students,
        );

        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterList(String query) {
              setModalState(() {
                filteredStudents = widget.students
                    .where(
                      (s) => s.studentName.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                    )
                    .toList();
              });
            }

            bool allSelected =
                widget.allowMultiple &&
                tempSelectedIds.length == widget.students.length &&
                widget.students.isNotEmpty;

            void toggleSelectAll() {
              if (!widget.allowMultiple) return;
              setModalState(() {
                if (allSelected) {
                  tempSelectedIds.clear();
                } else {
                  tempSelectedIds.addAll(
                    widget.students.map((s) => s.studentId),
                  );
                }
              });
            }

            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const Text(
                    'Select Students',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterList,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primaryDark,
                        ),
                        hintText: 'Search by name...',
                        filled: true,
                        fillColor: AppColors.lightGreyColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Select All (only for multiple)
                  if (widget.allowMultiple)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            allSelected
                                ? 'All Students Selected'
                                : 'Select All Students',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: allSelected,
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) => toggleSelectAll(),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Divider(),
                  ),

                  // Student List
                  Expanded(
                    child: filteredStudents.isEmpty
                        ? const Center(
                            child: Text(
                              'No students found',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              final isSelected = tempSelectedIds.contains(
                                student.studentId,
                              );

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setModalState(() {
                                    if (widget.allowMultiple) {
                                      if (isSelected) {
                                        tempSelectedIds.remove(
                                          student.studentId,
                                        );
                                      } else {
                                        tempSelectedIds.add(student.studentId);
                                      }
                                    } else {
                                      // Single selection: immediately return result
                                      tempSelectedIds.clear();
                                      tempSelectedIds.add(student.studentId);

                                      // Update the local selected list so UI reflects choice when sheet closes
                                      setState(() {
                                        _selectedStudents
                                          ..clear()
                                          ..add(student);
                                      });

                                      // Notify parent and close sheet
                                      widget.onSelectionChanged([student]);
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryDark.withOpacity(
                                            0.06,
                                          )
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Enlarged Checkbox
                                      Transform.scale(
                                        scale: 1.4,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          activeColor: AppColors.primaryDark,
                                          value: isSelected,
                                          onChanged: (checked) {
                                            setModalState(() {
                                              if (!widget.allowMultiple) {
                                                // behave like tap above
                                                tempSelectedIds.clear();
                                                tempSelectedIds.add(
                                                  student.studentId,
                                                );

                                                setState(() {
                                                  _selectedStudents
                                                    ..clear()
                                                    ..add(student);
                                                });

                                                widget.onSelectionChanged([
                                                  student,
                                                ]);
                                                Navigator.pop(context);
                                                return;
                                              }

                                              if (checked == true) {
                                                tempSelectedIds.add(
                                                  student.studentId,
                                                );
                                              } else {
                                                tempSelectedIds.remove(
                                                  student.studentId,
                                                );
                                              }
                                            });
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          student.studentName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  Column(
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: widget.allowMultiple
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              height: 45,
                              width: 120,
                              borderRadius: 10,
                              title: 'Cancel',
                              isEnabled: true,
                              onPressed: () => Navigator.pop(context),
                            ),

                            // If multiple selection allowed, show Add button to confirm selection.
                            if (widget.allowMultiple)
                              CustomButton(
                                height: 45,
                                width: 120,
                                borderRadius: 10,
                                title: 'Add',
                                isEnabled: true,
                                onPressed: () {
                                  setState(() {
                                    _selectedStudents.clear();
                                    _selectedStudents.addAll(
                                      widget.students.where(
                                        (s) => tempSelectedIds.contains(
                                          s.studentId,
                                        ),
                                      ),
                                    );
                                  });
                                  widget.onSelectionChanged(_selectedStudents);
                                  Navigator.pop(context);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
