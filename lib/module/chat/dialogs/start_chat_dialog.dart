import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/config/routes/nav_router.dart';
import 'package:lges_teacher_app/core/di/service_locator.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/chat/pages/principal_chat_detail_screen.dart';
import 'package:lges_teacher_app/module/class_section/cubit/classes_cubit/classes_cubit.dart';
import 'package:lges_teacher_app/module/class_section/cubit/sections_cubit/sections_cubit.dart';
import 'package:lges_teacher_app/module/class_section/model/classes_model.dart';
import 'package:lges_teacher_app/module/class_section/model/sections_model.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/subject_cubit/subjects_cubit.dart';
import 'package:lges_teacher_app/module/daily_diary/models/subjects_response.dart';
import 'package:lges_teacher_app/module/file_sharing/cubits/get_students/get_students_cubit.dart';
import 'package:lges_teacher_app/module/file_sharing/cubits/get_students/get_students_state.dart';
import 'package:lges_teacher_app/module/file_sharing/models/get_students_response.dart';

class StartNewChatDialog extends StatelessWidget {
  const StartNewChatDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => const StartNewChatDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final schoolId =
                sl<AuthRepository>().user.schoolId.toString();
            return ClassesCubit(sl())..fetchClasses(schoolId);
          },
        ),
        BlocProvider(create: (context) => SectionsCubit(sl())),
        BlocProvider(create: (context) => SubjectsCubit(sl())),
        BlocProvider(create: (context) => GetStudentsCubit(sl())),
      ],
      child: const _StartNewChatDialogContent(),
    );
  }
}

class _StartNewChatDialogContent extends StatefulWidget {
  const _StartNewChatDialogContent();

  @override
  State<_StartNewChatDialogContent> createState() =>
      _StartNewChatDialogContentState();
}

class _StartNewChatDialogContentState
    extends State<_StartNewChatDialogContent> {
  Class? selectedClass;
  Section? selectedSection;
  SubjectModel? selectedSubject;
  NotificationStudentModel? selectedStudent;

  void _resetSelections() {
    setState(() {
      selectedClass = null;
      selectedSection = null;
      selectedSubject = null;
      selectedStudent = null;
    });
  }

  void _openClassPicker(List<Class> classes) {
    if (classes.isEmpty) {
      Fluttertoast.showToast(msg: "No classes available");
      return;
    }
    _showItemPicker<Class>(
      title: "Select Class",
      items: classes,
      getLabel: (item) => item.className,
      onSelect: (item) {
        setState(() {
          selectedClass = item;
          selectedSection = null;
          selectedSubject = null;
          selectedStudent = null;
        });
        context.read<SectionsCubit>().fetchSections(item.classId.toString());
      },
    );
  }

  void _openSectionPicker(List<Section> sections) {
    if (selectedClass == null) {
      Fluttertoast.showToast(msg: "Please select a class first");
      return;
    }
    if (sections.isEmpty) {
      Fluttertoast.showToast(msg: "No sections available");
      return;
    }
    _showItemPicker<Section>(
      title: "Select Section",
      items: sections,
      getLabel: (item) => item.classSection,
      onSelect: (item) {
        setState(() {
          selectedSection = item;
          selectedSubject = null;
          selectedStudent = null;
        });
        context.read<SubjectsCubit>().fetchSubjects(
          selectedClass!.classId.toString(),
          item.sectionIdFk.toString(),
        );
        context.read<GetStudentsCubit>().getGetStudents(
          selectedClass!.classId.toString(),
          item.sectionIdFk.toString(),
        );
      },
    );
  }

  void _openSubjectPicker(List<SubjectModel> subjects) {
    if (selectedSection == null) {
      Fluttertoast.showToast(msg: "Please select a section first");
      return;
    }
    if (subjects.isEmpty) {
      Fluttertoast.showToast(msg: "No subjects available");
      return;
    }
    _showItemPicker<SubjectModel>(
      title: "Select Subject",
      items: subjects,
      getLabel: (item) => item.subjectName,
      onSelect: (item) {
        setState(() {
          selectedSubject = item;
        });
      },
    );
  }

  void _openStudentPicker(List<NotificationStudentModel> students) {
    if (selectedSection == null) {
      Fluttertoast.showToast(msg: "Please select a section first");
      return;
    }
    if (students.isEmpty) {
      Fluttertoast.showToast(msg: "No students available");
      return;
    }
    _showItemPicker<NotificationStudentModel>(
      title: "Select Student",
      items: students,
      getLabel: (item) => item.studentName,
      onSelect: (item) {
        setState(() {
          selectedStudent = item;
        });
      },
    );
  }

  void _showItemPicker<T>({
    required String title,
    required List<T> items,
    required String Function(T item) getLabel,
    required Function(T item) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = items.where((item) {
              return getLabel(item).toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (items.length > 5) ...[
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Flexible(
                    child: filtered.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                "No items found",
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              final label = getLabel(item);
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                title: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  onSelect(item);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onStartChat() {
    if (selectedStudent != null) {
      Navigator.pop(context);
      final initials = selectedStudent!.studentName.trim().isNotEmpty
          ? selectedStudent!.studentName
              .trim()
              .split(' ')
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
          : 'ST';
      final subtitle = selectedClass != null && selectedSection != null
          ? '${selectedClass!.className} — ${selectedSection!.classSection}'
          : 'Student';
      NavRouter.push(
        context,
        PrincipalChatDetailScreen(
          userName: selectedStudent!.studentName,
          subtitle: subtitle,
          initials: initials.isNotEmpty ? initials : 'ST',
          avatarBgColor: const Color(0xFF0D9488),
          isOnline: true,
        ),
      );
    } else if (selectedClass != null && selectedSection != null) {
      Navigator.pop(context);
      final groupName =
          "${selectedClass!.className} — ${selectedSection!.classSection}";
      final subtitle = selectedSubject != null
          ? selectedSubject!.subjectName
          : 'Class Group';
      NavRouter.push(
        context,
        PrincipalChatDetailScreen(
          userName: groupName,
          subtitle: subtitle,
          initials: 'G${selectedClass!.className.replaceAll(RegExp(r'[^0-9]'), '')}',
          avatarBgColor: const Color(0xFF7C4DFF),
          isOnline: true,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Please select Class and Section to start chat");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF6F8FC),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. SELECT CLASS
            BlocBuilder<ClassesCubit, ClassesState>(
              builder: (context, state) {
                final isLoading =
                    state.classesStatus == ClassesStatus.loading;
                final text = selectedClass?.className ?? "SELECT CLASS";
                return _buildDropdownButton(
                  text: text,
                  isSelected: selectedClass != null,
                  isLoading: isLoading,
                  onTap: () => _openClassPicker(state.classes),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2. SELECT SECTION
            BlocBuilder<SectionsCubit, SectionsState>(
              builder: (context, state) {
                final isLoading =
                    state.sectionsStatus == SectionsStatus.loading;
                final text = selectedSection?.classSection ?? "SELECT SECTION";
                return _buildDropdownButton(
                  text: text,
                  isSelected: selectedSection != null,
                  isLoading: isLoading,
                  onTap: () => _openSectionPicker(state.sections),
                );
              },
            ),
            const SizedBox(height: 12),

            // 3. SELECT SUBJECT
            BlocBuilder<SubjectsCubit, SubjectsState>(
              builder: (context, state) {
                final isLoading =
                    state.subjectsStatus == SubjectsStatus.loading;
                final text = selectedSubject?.subjectName ?? "SELECT SUBJECT";
                return _buildDropdownButton(
                  text: text,
                  isSelected: selectedSubject != null,
                  isLoading: isLoading,
                  onTap: () => _openSubjectPicker(state.subjects),
                );
              },
            ),
            const SizedBox(height: 12),

            // 4. SELECT STUDENTS
            BlocBuilder<GetStudentsCubit, GetStudentsState>(
              builder: (context, state) {
                final isLoading = state.status == GetStudentsStatus.loading;
                final text =
                    selectedStudent?.studentName ?? "SELECT STUDENTS";
                return _buildDropdownButton(
                  text: text,
                  isSelected: selectedStudent != null,
                  isLoading: isLoading,
                  onTap: () => _openStudentPicker(state.students),
                );
              },
            ),
            const SizedBox(height: 20),

            // Action Buttons: Reset & Start Chat
            Row(
              children: [
                // Reset Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _resetSelections,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFDDE3EA),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Start Chat Button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onStartChat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2E68),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Start Chat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String text,
    required bool isSelected,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w700,
                    color: isSelected
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF64748B),
                    letterSpacing: isSelected ? 0 : 0.4,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF64748B),
                  ),
                )
              else
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF64748B),
                  size: 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
