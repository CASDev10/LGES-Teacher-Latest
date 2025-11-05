import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/utils/extensions/extended_context.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/custom_countdown.dart';
import '../../../utils/display/display_utils.dart';
import '../model/leave_types_list.dart';
import '../model/reliever_list.dart';
import '../widgets/custom_calander_widget.dart';

class ApplyLeavePage extends StatefulWidget {
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final TextEditingController supportingDocumentController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? starFormattedtDate;
  String? endFormattedDate;
  int _totalDays = 0;

  String? selectedLeaveTypeName;
  String? selectedRelieverName;
  int? selectedLeaveTypeId;
  int? selectedRelieverNameId;
  final _userAuthRepo = sl<AuthRepository>();
  // final _userAccountRepo = sl<UserAccountRepository>();
  final List<LeaveTypeList> dummyLeaveTypes = [
    LeaveTypeList(entityLeaveTypeId: 1, leaveTypeName: "Casual Leave"),
    LeaveTypeList(entityLeaveTypeId: 2, leaveTypeName: "Sick Leave"),
    LeaveTypeList(entityLeaveTypeId: 3, leaveTypeName: "Annual Leave"),
    LeaveTypeList(entityLeaveTypeId: 4, leaveTypeName: "Maternity Leave"),
    LeaveTypeList(entityLeaveTypeId: 5, leaveTypeName: "Paternity Leave"),
    LeaveTypeList(entityLeaveTypeId: 6, leaveTypeName: "Emergency Leave"),
    LeaveTypeList(entityLeaveTypeId: 7, leaveTypeName: "Half Day Leave"),
  ];

  final List<RelieverListElement> dummyRelievers = [
    RelieverListElement(relieverId: 1, relieverName: "Ahmed Khan"),
    RelieverListElement(relieverId: 2, relieverName: "Sara Ali"),
    RelieverListElement(relieverId: 3, relieverName: "Bilal Hassan"),
    RelieverListElement(relieverId: 4, relieverName: "Ayesha Malik"),
    RelieverListElement(relieverId: 5, relieverName: "Usman Saeed"),
    RelieverListElement(relieverId: 6, relieverName: "Zainab Tariq"),
    RelieverListElement(relieverId: 7, relieverName: "Hamza Qureshi"),
  ];

  @override
  void initState() {
    // final selectedSchool = _userAccountRepo.getSelectedSchool();
    // context.read<LeaveDataCubit>().fetchLeaveTypes();
    // context.read<LeaveDataCubit>().fetchRelieverList(
    //     {"UC_SchoolId":  1});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar('Leave'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCalendarWidget(
              onDaySelected: (selectedDate) {
                starFormattedtDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate);
                endFormattedDate = starFormattedtDate; // same for single date
                _totalDays = 1;
              },
            ),

            const SizedBox(height: 10),
            const Divider(color: AppColors.primaryLight),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Upload Supporting Document',
              height: 50,
              fontSize: 16,
              inputType: TextInputType.text,
              fillColor: AppColors.lightGreyColor,
              hintColor: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
              readOnly: true,
              suffixWidget: SvgPicture.asset(
                'assets/images/svg/upload_document.svg',
              ),
              onTap: () async {
                // final leaveAttachment =
                // context.read<ApplyLeaveCubit>();
                // await leaveAttachment.pickFile();
                // if (leaveAttachment.selectedFile != null) {
                //   supportingDocumentController.text = path
                //       .basename(leaveAttachment.selectedFile!.path);
                // }
              },
              controller: supportingDocumentController,
            ),
            const SizedBox(height: 14),

            /// Leave type dropdown
            /// Leave type dropdown
            GenericCustomDropDown<LeaveTypeList>(
              hint: "Select Leave Type",
              borderColor: AppColors.primaryLight,
              iconColor: const Color(0xffA5A5A5),
              hintColor: const Color(0xffA5A5A5),
              fillColor: Colors.transparent,
              items: dummyLeaveTypes,
              getLabel: (v) => v.leaveTypeName,
              onSelect: (selected) {
                setState(() {
                  selectedLeaveTypeName = selected.leaveTypeName;
                  selectedLeaveTypeId = selected.entityLeaveTypeId;
                });
              },
            ),
            const SizedBox(height: 14),

            /// Reliever dropdown
            GenericCustomDropDown<RelieverListElement>(
              hint: "Select Reliever",
              borderColor: AppColors.primaryLight,
              iconColor: const Color(0xffA5A5A5),
              hintColor: const Color(0xffA5A5A5),
              fillColor: Colors.transparent,
              items: dummyRelievers,
              getLabel: (v) => v.relieverName,
              onSelect: (selected) {
                setState(() {
                  selectedRelieverName = selected.relieverName;
                  selectedRelieverNameId = selected.relieverId;
                });
              },
            ),

            const SizedBox(height: 14),

            /// Note
            Text(
              "Note",
              style: context.textTheme.titleSmall?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              hintText: 'Write..',
              fontSize: 16,
              inputType: TextInputType.text,
              fillColor: AppColors.lightGreyColor,
              hintColor: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
              readOnly: true,
              maxLines: 5,
              suffixWidget: SvgPicture.asset(
                'assets/images/svg/upload_document.svg',
              ),
              onTap: () async {
                // final leaveAttachment =
                // context.read<ApplyLeaveCubit>();
                // await leaveAttachment.pickFile();
                // if (leaveAttachment.selectedFile != null) {
                //   supportingDocumentController.text = path
                //       .basename(leaveAttachment.selectedFile!.path);
                // }
              },
              controller: noteController,
            ),
            const SizedBox(height: 40),
          ],
        ),

        /*BlocConsumer<ApplyLeaveCubit, ApplyLeaveState>(
          listener: (context, state) {
            if (state.status == ApplyLeaveStatus.loading) {
              return DisplayUtils.showLoader();
            } else if (state.status == ApplyLeaveStatus.error) {
              DisplayUtils.removeLoader();
              DisplayUtils.showToast(context, "Failed: ${state.message}");
            } else if (state.status == ApplyLeaveStatus.success) {
              DisplayUtils.removeLoader();
              DisplayUtils.showToast(context, state.message);
              NavRouter.pushAndRemoveUntilFirst(context, LeavePage());
            }
          },
          builder: (context, state) {
            return BlocBuilder<LeaveDataCubit, LeaveDataState>(
              builder: (context, leaveTypeState) {
                if (leaveTypeState.status == LeaveDataStatus.loading) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(child: LoadingIndicator()),
                  );
                } else if (leaveTypeState.status == LeaveDataStatus.error) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                      ),
                    ),
                  );
                } else if (leaveTypeState.status == LeaveDataStatus.success) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCalendarWidget(
                        onDaySelected: (selectedDate) {
                          starFormattedtDate =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                          endFormattedDate =
                              starFormattedtDate; // same for single date
                          _totalDays = 1;
                        },
                      ),

                      const SizedBox(height: 10),
                      const Divider(color: AppColors.primaryLightBlue),
                      const SizedBox(height: 20),

                      /// Upload supporting document
                      InputField(
                        onTap: () async {
                          final leaveAttachment =
                              context.read<ApplyLeaveCubit>();
                          await leaveAttachment.pickFile();
                          if (leaveAttachment.selectedFile != null) {
                            supportingDocumentController.text = path
                                .basename(leaveAttachment.selectedFile!.path);
                          }
                        },
                        readOnly: true,
                        fillColor: Colors.white,
                        horizontalPadding: 12,
                        borderColor: AppColors.primaryLightBlue,
                        controller: supportingDocumentController,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SvgPicture.asset(
                              'assets/images/svg/upload_document.svg'),
                        ),
                        label: 'Upload Supporting Document',
                      ),
                      const SizedBox(height: 14),

                      /// Leave type dropdown
                      /// Leave type dropdown
                      GenericCustomDropDown<LeaveTypeList>(
                        hint: "Select Leave Type",
                        borderColor: AppColors.primaryLightBlue,
                        iconColor: const Color(0xffA5A5A5),
                        hintColor: const Color(0xffA5A5A5),
                        fillColor: Colors.transparent,
                        items: leaveTypeState.leaveTypesList,
                        getLabel: (v) => v.leaveTypeName,
                        onSelect: (selected) {
                          setState(() {
                            selectedLeaveTypeName = selected.leaveTypeName;
                            selectedLeaveTypeId = selected.entityLeaveTypeId;
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      /// Reliever dropdown
                      GenericCustomDropDown<RelieverListElement>(
                        hint: "Select Reliever",
                        borderColor: AppColors.primaryLightBlue,
                        iconColor: const Color(0xffA5A5A5),
                        hintColor: const Color(0xffA5A5A5),
                        fillColor: Colors.transparent,
                        items: leaveTypeState.relieverListElement,
                        getLabel: (v) => v.relieverName,
                        onSelect: (selected) {
                          setState(() {
                            selectedRelieverName = selected.relieverName;
                            selectedRelieverNameId = selected.relieverId;
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      /// Note
                      Text("Note",
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontSize: 24)),
                      const SizedBox(height: 14),
                      InputField(
                        borderColor: AppColors.primaryLightBlue,
                        controller: noteController,
                        label: 'Write..',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          },
        )*/
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          title: 'Submit',
          height: 50,

          isEnabled: true,
          onPressed: () async {
            if (starFormattedtDate == null || endFormattedDate == null) {
              DisplayUtils.showToast(context, "Please select dates");
              return;
            } else if (_totalDays <= 0) {
              DisplayUtils.showToast(context, "Please select valid dates");
              return;
            } else if (supportingDocumentController.text.isEmpty) {
              DisplayUtils.showToast(
                context,
                "Please upload supporting document",
              );
              return;
            } else if (noteController.text.isEmpty) {
              DisplayUtils.showToast(context, "Please write reason");
              return;
            }

            final data = {
              "UC_LoginUserId": _userAuthRepo.user.userId,
              "EntityLeaveTypeId": selectedLeaveTypeId,
              "FromDate": starFormattedtDate,
              "RelieverId": selectedRelieverNameId,
              "Reason": noteController.text,
            };

            // await context.read<ApplyLeaveCubit>().applyLeave(data);
          },
        ),
      ),
    );
  }
}
