import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../components/custom_appbar.dart';
import '../../../../core/di/service_locator.dart';
import '../../../components/base_scaffold.dart';
import '../../../components/custom_button.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../cubit/apply_leave_cubit/apply_leave_cubit.dart';
import '../cubit/leaves_cubit.dart';
import '../dialogs/apply_leave_dialogue.dart';
import '../model/employee_leaves_response.dart';
import '../model/leave_balance_response.dart';
import '../widgets/attendance_card.dart';
import '../widgets/leave_tile.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherLeaveCubit(sl())
        ..fetchEmployeeLeaves(offSet: 0, next: 10)
        ..fetchLeaveBalance(),
      child: LeavesScreenView(),
    );
  }
}

class LeavesScreenView extends StatefulWidget {
  const LeavesScreenView({super.key});

  @override
  State<LeavesScreenView> createState() => _LeavesScreenViewState();
}

class _LeavesScreenViewState extends State<LeavesScreenView> {
  final int _next = 10;
  int offset = 0;

  returnOffset() {
    offset += _next;
    return offset;
  }

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  List<EmployeeLeaveModel> dummyLeaveList = [
    EmployeeLeaveModel(
      id: 1,
      empId: 101,
      fromDate: DateTime(2025, 11, 5),
      fromDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 5)),
      toDate: DateTime(2025, 11, 7),
      toDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 7)),
      reason: 'Medical Leave',
      days: 3,
      entityLeaveTypeId: 1,
      entityLeaveType: 'Sick Leave',
      isDeleted: false,
      createdBy: 10,
      createdDate: DateTime(2025, 11, 1),
      createdDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 1)),
      employeeName: 'Ali Raza',
      departmentName: 'Science Department',
      desginationName: 'Teacher',
      approved: true,
      shift: 'Morning',
      waitingForApproval: 0,
      offSet: 0,
      next: 0,
      leaveStatus: 1,
      leaveStatusString: 'Approved',
      fileDownloadLink: 'https://example.com/file1.pdf',
      ucUser: null,
      ucLoginUserId: 1001,
      ucUserFullName: 'Admin User',
      ucEntityId: 1,
      ucSchoolId: 1,
      ucPrivilegeId: 1,
      ucIsAllowed: 1,
      ucMessageId: 0,
      ucMessage: null,
      ucCompanyName: 'ABC School System',
      ucDbConnectionString: 'Server=abc;Database=school;',
      ucIsAdminUser: true,
    ),
    EmployeeLeaveModel(
      id: 2,
      empId: 102,
      fromDate: DateTime(2025, 11, 10),
      fromDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 10)),
      toDate: DateTime(2025, 11, 12),
      toDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 12)),
      reason: 'Family Function',
      days: 3,
      entityLeaveTypeId: 2,
      entityLeaveType: 'Casual Leave',
      isDeleted: false,
      createdBy: 10,
      createdDate: DateTime(2025, 11, 3),
      createdDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 3)),
      employeeName: 'Fatima Noor',
      departmentName: 'Mathematics',
      desginationName: 'Lecturer',
      approved: false,
      shift: 'Evening',
      waitingForApproval: 1,
      offSet: 0,
      next: 0,
      leaveStatus: 0,
      leaveStatusString: 'Pending',
      fileDownloadLink: 'https://example.com/file2.pdf',
      ucUser: null,
      ucLoginUserId: 1001,
      ucUserFullName: 'Admin User',
      ucEntityId: 1,
      ucSchoolId: 1,
      ucPrivilegeId: 1,
      ucIsAllowed: 1,
      ucMessageId: 0,
      ucMessage: null,
      ucCompanyName: 'ABC School System',
      ucDbConnectionString: 'Server=abc;Database=school;',
      ucIsAdminUser: true,
    ),
    EmployeeLeaveModel(
      id: 3,
      empId: 103,
      fromDate: DateTime(2025, 11, 20),
      fromDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 20)),
      toDate: DateTime(2025, 11, 22),
      toDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 22)),
      reason: 'Personal Work',
      days: 3,
      entityLeaveTypeId: 3,
      entityLeaveType: 'Annual Leave',
      isDeleted: false,
      createdBy: 10,
      createdDate: DateTime(2025, 11, 5),
      createdDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 5)),
      employeeName: 'Usman Saeed',
      departmentName: 'Computer Science',
      desginationName: 'Instructor',
      approved: true,
      shift: 'Morning',
      waitingForApproval: 0,
      offSet: 0,
      next: 0,
      leaveStatus: 1,
      leaveStatusString: 'Approved',
      fileDownloadLink: 'https://example.com/file3.pdf',
      ucUser: null,
      ucLoginUserId: 1001,
      ucUserFullName: 'Admin User',
      ucEntityId: 1,
      ucSchoolId: 1,
      ucPrivilegeId: 1,
      ucIsAllowed: 1,
      ucMessageId: 0,
      ucMessage: null,
      ucCompanyName: 'ABC School System',
      ucDbConnectionString: 'Server=abc;Database=school;',
      ucIsAdminUser: true,
    ),
    EmployeeLeaveModel(
      id: 4,
      empId: 104,
      fromDate: DateTime(2025, 11, 29),
      fromDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 29)),
      toDate: DateTime(2025, 11, 31),
      toDateString: DateFormat('dd/MM/yyyy').format(DateTime(2025, 11, 31)),
      reason: 'Personal Work',
      days: 3,
      entityLeaveTypeId: 3,
      entityLeaveType: 'Annual Leave',
      isDeleted: false,
      createdBy: 10,
      createdDate: DateTime(2025, 11, 29),
      createdDateString: DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime(2025, 11, 29)),
      employeeName: 'Usman Saeed',
      departmentName: 'Computer Science',
      desginationName: 'Instructor',
      approved: true,
      shift: 'Morning',
      waitingForApproval: 0,
      offSet: 0,
      next: 0,
      leaveStatus: 1,
      leaveStatusString: 'Approved',
      fileDownloadLink: 'https://example.com/file3.pdf',
      ucUser: null,
      ucLoginUserId: 1001,
      ucUserFullName: 'Admin User',
      ucEntityId: 1,
      ucSchoolId: 1,
      ucPrivilegeId: 1,
      ucIsAllowed: 1,
      ucMessageId: 0,
      ucMessage: null,
      ucCompanyName: 'ABC School System',
      ucDbConnectionString: 'Server=abc;Database=school;',
      ucIsAdminUser: true,
    ),
  ];
  List<LeaveModel> dummyLeaveBalanceList = [
    LeaveModel(
      empLeaveBalanceId: 1,
      leaveTypeId: 101,
      empId: 1001,
      balance: 12,
      allowLeavePerMonth: 1,
      leaveTypeName: 'Casual Leave',
      validFromDate: '01/01/2025',
      validToDate: '31/12/2025',
    ),
    LeaveModel(
      empLeaveBalanceId: 2,
      leaveTypeId: 102,
      empId: 1001,
      balance: 8,
      allowLeavePerMonth: 1,
      leaveTypeName: 'Sick Leave',
      validFromDate: '01/01/2025',
      validToDate: '31/12/2025',
    ),
    LeaveModel(
      empLeaveBalanceId: 3,
      leaveTypeId: 103,
      empId: 1001,
      balance: 20,
      allowLeavePerMonth: 2,
      leaveTypeName: 'Annual Leave',
      validFromDate: '01/01/2025',
      validToDate: '31/12/2025',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        Future.wait([
          context.read<TeacherLeaveCubit>().fetchEmployeeLeaves(
            loadMore: true,
            offSet: returnOffset(),
            next: _next,
          ),
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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
        padding:
            const EdgeInsets.symmetric(horizontal: 20) +
            const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(dummyLeaveBalanceList.length, (index) {
                var item = dummyLeaveBalanceList[index];
                return Expanded(
                  child: AttendanceCard(
                    cardName: item.leaveTypeName,
                    value: item.balance.toString(),
                  ),
                );
              }),
            ),
            SizedBox(height: 6),
            Text(
              "Leaves",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            dummyLeaveList.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: dummyLeaveList.length,
                      itemBuilder: (context, index) {
                        EmployeeLeaveModel employeeLeave =
                            dummyLeaveList[index];
                        return LeaveTile(detail: employeeLeave);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 12.0);
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        "No Leaves Applied",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 12.0),
            CustomButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return ApplyLeaveDialogue(
                      onSave: (value) async {
                        await context
                            .read<ApplyLeaveCubit>()
                            .addUpdateEmployeeLeave(input: value);
                        NavRouter.pop(context, true);
                      },
                      leaveBalance: dummyLeaveBalanceList,
                    );
                  },
                ).then((v) async {
                  if (v) {
                    offset = 0;
                    Future.wait([
                      context.read<TeacherLeaveCubit>().fetchLeaveBalance(),
                      context.read<TeacherLeaveCubit>().fetchEmployeeLeaves(
                        offSet: offset,
                        next: _next,
                      ),
                    ]);
                  }
                });
              },
              title: "Apply Leave",
            ),
          ],
        ),

        /*BlocConsumer<TeacherLeaveCubit, TeacherLeaveState>(
          builder: (context, state) {
            if (state.studentAttendanceStatus == TeacherLeaveStatus.failure) {
              return Center(
                child: Text(
                  state.failure.message,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(state.leaveBalance.length, (index) {
                    var item = state.leaveBalance[index];
                    return Expanded(
                      child: AttendanceCard(
                        cardName: item.leaveTypeName,
                        value: item.balance.toString(),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 6),
                Text(
                  "Leaves",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                state.employeeLeaves.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: state.employeeLeaves.length,
                          itemBuilder: (context, index) {
                            EmployeeLeaveModel employeeLeave =
                                state.employeeLeaves[index];
                            return LeaveTile(detail: employeeLeave);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 12.0);
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            "No Leaves Applied",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 12.0),
                BlocConsumer<ApplyLeaveCubit, ApplyLeaveState>(
                  listener: (context, applyLeaveState) {
                    if (applyLeaveState.studentAttendanceStatus ==
                        ApplyLeaveStatus.loading) {
                      DisplayUtils.showLoader();
                    } else if (applyLeaveState.studentAttendanceStatus ==
                        ApplyLeaveStatus.success) {
                      DisplayUtils.removeLoader();
                      NavRouter.pop(context, true);
                    } else if (applyLeaveState.studentAttendanceStatus ==
                        ApplyLeaveStatus.failure) {
                      DisplayUtils.removeLoader();
                      DisplayUtils.showSnackBar(
                        context,
                        applyLeaveState.failure.message,
                      );
                    }
                  },
                  builder: (context, applyLeaveState) {
                    return CustomButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return ApplyLeaveDialogue(
                              onSave: (value) async {
                                await context
                                    .read<ApplyLeaveCubit>()
                                    .addUpdateEmployeeLeave(input: value);
                                NavRouter.pop(context, true);
                              },
                              leaveBalance: state.leaveBalance,
                            );
                          },
                        ).then((v) async {
                          if (v) {
                            offset = 0;
                            Future.wait([
                              context
                                  .read<TeacherLeaveCubit>()
                                  .fetchLeaveBalance(),
                              context
                                  .read<TeacherLeaveCubit>()
                                  .fetchEmployeeLeaves(
                                    offSet: offset,
                                    next: _next,
                                  ),
                            ]);
                          }
                        });
                      },
                      title: "Apply Leave",
                      height: 40.0,
                    );
                  },
                ),
              ],
            );
          },
          listener: (BuildContext context, TeacherLeaveState state) {
            if (state.studentAttendanceStatus == TeacherLeaveStatus.failure) {
              DisplayUtils.showSnackBar(context, state.failure.message);
            } else if (state.studentAttendanceStatus ==
                TeacherLeaveStatus.loadMore) {
              _isLoading = true;
            } else {
              _isLoading = false;
            }
          },
        )*/
      ),
      hMargin: 0,
      appBar: CustomAppbar("Apply Leaves", centerTitle: true),
      backgroundColor: AppColors.primaryDark,
    );
  }
}
