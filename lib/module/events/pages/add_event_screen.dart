import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_dropdown.dart';
import '../../../components/custom_textfield.dart'; // ✅ Added import
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../auth/repo/auth_repository.dart';
import '../../class_section/cubit/classes_cubit/classes_cubit.dart';
import '../../class_section/cubit/sections_cubit/sections_cubit.dart';
import '../../class_section/model/classes_model.dart';
import '../../class_section/model/sections_model.dart';
import '../cubits/add_event/add_event_cubit.dart';
import '../cubits/add_event/add_event_state.dart';
import '../models/add_event_input.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ClassesCubit(sl())
                ..fetchClasses(sl<AuthRepository>().user.schoolId.toString()),
        ),
        BlocProvider(create: (_) => SectionsCubit(sl())),
        BlocProvider(create: (_) => AddEventCubit(sl())),
      ],
      child: const AddEventScreenView(),
    );
  }
}

class AddEventScreenView extends StatefulWidget {
  const AddEventScreenView({super.key});

  @override
  State<AddEventScreenView> createState() => _AddEventScreenViewState();
}

class _AddEventScreenViewState extends State<AddEventScreenView> {
  final _descriptionController = TextEditingController();
  final _dayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthRepository authRepository = sl<AuthRepository>();

  int _status = 1;
  String? _selectedClass;
  String? _selectedSection;
  String? _classId;
  String? _sectionId;

  @override
  void dispose() {
    _descriptionController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar('Add Event', centerTitle: true),
      backgroundColor: AppColors.primaryDark,
      hMargin: 0,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: BlocConsumer<AddEventCubit, AddEventState>(
                  listener: (context, state) {
                    if (state.status == AddEventStatus.loading) {
                      DisplayUtils.showLoader();
                    } else if (state.status == AddEventStatus.success) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showToast(
                        context,
                        'Event added successfully!',
                      );
                      Navigator.pop(context, true);
                    } else if (state.status == AddEventStatus.failure) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showToast(context, state.failure.message);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: _descriptionController,
                            hintText: "Enter event description",
                            onValidate: (v) => v == null || v.isEmpty
                                ? "Description required"
                                : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Event Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            controller: _dayController,
                            hintText: "Select date",
                            readOnly: true,
                            suffixWidget: const Icon(Icons.calendar_today),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                _dayController.text = picked
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                            onValidate: (v) => v == null || v.isEmpty
                                ? "Event date required"
                                : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Status: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: _status == 1,
                                onChanged: (val) =>
                                    setState(() => _status = val ? 1 : 0),
                              ),
                              Text(_status == 1 ? "On" : "Off"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<ClassesCubit, ClassesState>(
                            builder: (context, classState) {
                              if (classState.classesStatus ==
                                  ClassesStatus.loading) {
                                return Center(
                                  child: const CircularProgressIndicator(),
                                );
                              } else if (classState.classesStatus ==
                                  ClassesStatus.success) {
                                return Column(
                                  children: [
                                    CustomDropDown(
                                      hint: _selectedClass ?? "Select Class",
                                      hintColor: AppColors.primaryDark,
                                      iconColor: AppColors.primaryDark,
                                      allPadding: 0,
                                      horizontalPadding: 15,
                                      items: classState.classes
                                          .map((c) => c.className)
                                          .toList(),
                                      onSelect: (value) {
                                        Class selected = classState.classes
                                            .firstWhere(
                                              (c) => c.className == value,
                                            );
                                        setState(() {
                                          _selectedClass = value;
                                          _classId = selected.classId
                                              .toString();
                                          _selectedSection = null;
                                          _sectionId = null;
                                        });
                                        context
                                            .read<SectionsCubit>()
                                            .fetchSections(_classId!);
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    BlocBuilder<SectionsCubit, SectionsState>(
                                      builder: (context, sectionState) {
                                        return CustomDropDown(
                                          hint:
                                              _selectedSection ??
                                              "Select Section",
                                          hintColor: AppColors.primaryDark,
                                          iconColor: AppColors.primaryDark,
                                          allPadding: 0,
                                          horizontalPadding: 15,
                                          items: sectionState.sections
                                              .map((s) => s.sectionName)
                                              .toList(),
                                          onSelect: (value) {
                                            Section selected = sectionState
                                                .sections
                                                .firstWhere(
                                                  (s) => s.sectionName == value,
                                                );
                                            setState(() {
                                              _selectedSection = value;
                                              _sectionId = selected.sectionId
                                                  .toString();
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              title: "Add Event",
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _classId != null &&
                    _sectionId != null) {
                  final input = AddEventInput(
                    ucLoginUserId: authRepository.user.userId,
                    ucEntityId: authRepository.user.entityId,
                    day: _dayController.text,
                    status: _status,
                    description: _descriptionController.text.trim(),
                    ucSchoolId: authRepository.user.schoolId,
                    classIdFk: int.parse(_classId!),
                    sectionIdFk: int.parse(_sectionId!),
                  );
                  print(input.toJson());
                  context.read<AddEventCubit>().addEvent(input: input);
                } else {
                  DisplayUtils.showToast(
                    context,
                    "Please select class and section",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
