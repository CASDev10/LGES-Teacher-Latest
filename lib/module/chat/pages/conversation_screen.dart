import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/generic_drop_down.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/chat/cubits/conversations/conversations_cubit.dart';
import 'package:lges_teacher_app/module/chat/cubits/conversations/conversations_state.dart';
import 'package:lges_teacher_app/utils/custom_date_time_picker.dart';

import '../../../components/custom_button.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/repo/auth_repository.dart';
import '../../class_section/cubit/classes_cubit/classes_cubit.dart';
import '../../class_section/cubit/sections_cubit/sections_cubit.dart';
import '../../class_section/model/classes_model.dart';
import '../../class_section/model/sections_model.dart';
import '../../daily_diary/cubit/subject_cubit/subjects_cubit.dart';
import '../../daily_diary/models/subjects_response.dart';
import '../../file_sharing/cubits/get_students/get_students_cubit.dart';
import '../../file_sharing/cubits/get_students/get_students_state.dart';
import '../../file_sharing/models/get_students_response.dart';
import '../../file_sharing/pages/file_sharing_screen.dart';
import '../models/conversations_response.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationsCubit(sl())..getConversations(),
      child: ConversationsScreenView(),
    );
  }
}

class ConversationsScreenView extends StatefulWidget {
  const ConversationsScreenView({super.key});

  @override
  State<ConversationsScreenView> createState() =>
      _ConversationsScreenViewState();
}

class _ConversationsScreenViewState extends State<ConversationsScreenView> {
  void _openNewChatDialog() async {
    final selectedData = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TeacherListSheet(),
    );

    if (selectedData != null) {
      print('selectedData $selectedData');

      // Get the current state to check existing conversations
      final conversationsState = context.read<ConversationsCubit>().state;

      // Find if conversation already exists with this student
      final existingConversation = conversationsState.conversations.firstWhere(
        (conversation) => conversation.studentId == selectedData["id"],
        orElse: () => ConversationModel(
          conversationId: -1,
          teacherName: '',
          studentId: -1,
          studentName: '',
          latestMessage: '',
          className: '',
          sectionName: '',
          latestMessageDate: DateTime.now(),
        ),
      );

      // Use existing conversationId if found, otherwise use -1 for new conversation
      final conversationId = existingConversation.conversationId ?? -1;

      NavRouter.push(
        context,
        ChatDetailScreen(
          userName: selectedData["name"],
          conversationId: conversationId,
          studentId: selectedData["id"],
        ),
      ).then((value) {
        context.read<ConversationsCubit>().getConversations(isLoading: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const CustomAppbar('Conversations', centerTitle: true),
      hMargin: 0,
      backgroundColor: AppColors.primaryDark,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        onPressed: _openNewChatDialog,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ConversationsCubit, ConversationsState>(
          builder: (context, state) {
            if (state.conversationsStatus == ConversationsStatus.loading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Loading...',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state.conversationsStatus == ConversationsStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   Icons.error_outline,
                    //   size: 50,
                    //   color: Colors.red.shade600,
                    // ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   "Something went wrong",
                    //   style: TextStyle(
                    //     color: Colors.red.shade600,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ConversationsCubit>().getConversations();
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state.conversationsStatus == ConversationsStatus.success) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 30,
                ),
                itemCount: state.conversations.length,
                itemBuilder: (context, index) {
                  final chat = state.conversations[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      NavRouter.push(
                        context,
                        ChatDetailScreen(
                          userName: chat.studentName,
                          conversationId: chat.conversationId,
                          studentId: chat.studentId,
                        ),
                      ).then((value) {
                        context.read<ConversationsCubit>().getConversations(
                          isLoading: false,
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryDark.withOpacity(0.08),
                            AppColors.primaryDark.withOpacity(0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primaryDark.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row with Name and Time
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${chat.studentName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black87,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),

                                    // Time with better styling
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryDark
                                            .withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        changeDateTimeFormat(
                                          chat.latestMessageDate,
                                          'hh:mm a',
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Class & Section with icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.school_outlined,
                                      color: Colors.grey[600],
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${chat.className} - ${chat.sectionName}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Latest Message with message icon
                                Row(
                                  children: [
                                    Icon(
                                      Icons.message_outlined,
                                      color: Colors.grey[500],
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        chat.latestMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 16);
                },
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _TeacherListSheet extends StatefulWidget {
  const _TeacherListSheet();

  @override
  State<_TeacherListSheet> createState() => _TeacherListSheetState();
}

class _TeacherListSheetState extends State<_TeacherListSheet> {
  String? selectedClass;
  String? selectedSection;
  String? selectedSubject;

  String? classId;
  String? sectionId;
  String? subjectId;

  List<NotificationStudentModel> selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ClassesCubit(sl())
                ..fetchClasses(sl<AuthRepository>().user.schoolId.toString()),
        ),
        BlocProvider(create: (context) => SectionsCubit(sl())),
        BlocProvider(create: (context) => SubjectsCubit(sl())),
        BlocProvider(create: (context) => GetStudentsCubit(sl())),
      ],
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Start a Chat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                BlocBuilder<ClassesCubit, ClassesState>(
                  builder: (context, state) {
                    if (state.classesStatus == ClassesStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return GenericDropDown<Class>(
                      hint: selectedClass ?? "Select Class",
                      items: state.classes,
                      hintColor: AppColors.primaryDark,
                      onSelect: (Class value) {
                        setState(() {
                          selectedClass = value.className;
                          classId = value.classId.toString();

                          selectedSection = null;
                          sectionId = null;
                          selectedSubject = null;
                          subjectId = null;
                          selectedStudents.clear();
                        });

                        context.read<SectionsCubit>().fetchSections(classId!);
                      },
                      getLabel: (c) => c.className,
                    );
                  },
                ),

                const SizedBox(height: 12),

                BlocBuilder<SectionsCubit, SectionsState>(
                  builder: (context, state) {
                    if (state.sectionsStatus == SectionsStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return GenericDropDown<Section>(
                      hint: selectedSection ?? "Select Section",
                      items: state.sections,
                      hintColor: AppColors.primaryDark,
                      onSelect: (Section value) {
                        setState(() {
                          selectedSection = value.classSection;
                          sectionId = value.sectionIdFk.toString();

                          selectedSubject = null;
                          subjectId = null;
                          selectedStudents.clear();
                        });

                        context.read<SubjectsCubit>().fetchSubjects(
                          classId!,
                          sectionId!,
                        );
                      },
                      getLabel: (s) => s.classSection,
                    );
                  },
                ),

                const SizedBox(height: 12),

                BlocBuilder<SubjectsCubit, SubjectsState>(
                  builder: (context, state) {
                    if (state.subjectsStatus == SubjectsStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return GenericDropDown<SubjectModel>(
                      hint: selectedSubject ?? "Select Subject",
                      items: state.subjects,
                      hintColor: AppColors.primaryDark,
                      onSelect: (SubjectModel value) {
                        setState(() {
                          selectedSubject = value.subjectName;
                          subjectId = value.subjectId.toString();
                        });

                        context.read<GetStudentsCubit>().getGetStudents(
                          classId!,
                          sectionId!,
                        );
                      },
                      getLabel: (s) => s.subjectName,
                    );
                  },
                ),

                const SizedBox(height: 12),

                BlocBuilder<GetStudentsCubit, GetStudentsState>(
                  builder: (context, studentState) {
                    if (studentState.status == GetStudentsStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return StudentMultiSelectDropdown(
                      students: studentState.students,
                      allowMultiple: false,
                      onSelectionChanged: (list) {
                        setState(() => selectedStudents = list);
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    height: 48,
                    width: 160,
                    title: "Start Chat",
                    onPressed: () {
                      if (selectedStudents.isNotEmpty) {
                        print({
                          "name": selectedStudents.first.studentName,
                          "id": selectedStudents.first.studentId,
                        });
                        Navigator.pop(context, {
                          "name": selectedStudents.first.studentName,
                          "id": selectedStudents.first.studentId,
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
