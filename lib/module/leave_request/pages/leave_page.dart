import 'package:flutter/material.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';

import '../../../components/custom_button.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/repo/auth_repository.dart';
import '../model/leave_balance_response.dart';
import '../model/leave_data_response.dart';
import '../widgets/applied_leave.dart';
import '../widgets/leave_box.dart';
import 'apply_leave_page.dart';

class LeavePage extends StatefulWidget {
  LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _userAuthRepo = sl<AuthRepository>();
  final List<EmpLeaveDataList> dummyEmpLeaveDataList = [
    EmpLeaveDataList(
      appliedDate: "01/11/2025",
      status: "Approved",
      leaveBalance: 10,
      days: 2,
      entityLeaveTypeId: 1,
      leaveTypeName: "Casual Leave",
      relieverId: 3,
      relieverName: "Bilal Hassan",
      userFileName: "leave_doc_01.pdf",
      systemFileName: "sys_leave_doc_01_2025.pdf",
      fileDownloadLink: "https://example.com/files/leave_doc_01.pdf",
    ),
    EmpLeaveDataList(
      appliedDate: "20/10/2025",
      status: "Pending",
      leaveBalance: 8,
      days: 3,
      entityLeaveTypeId: 2,
      leaveTypeName: "Sick Leave",
      relieverId: 2,
      relieverName: "Sara Ali",
      userFileName: "medical_report.pdf",
      systemFileName: "sys_medical_2025.pdf",
      fileDownloadLink: "https://example.com/files/medical_report.pdf",
    ),
    EmpLeaveDataList(
      appliedDate: "10/09/2025",
      status: "Rejected",
      leaveBalance: 12,
      days: 1,
      entityLeaveTypeId: 3,
      leaveTypeName: "Annual Leave",
      relieverId: 5,
      relieverName: "Usman Saeed",
      userFileName: null,
      systemFileName: null,
      fileDownloadLink: "",
    ),
  ];
  final List<LeaveBalanceList> dummyLeaveBalanceList = [
    LeaveBalanceList(
      empLeaveBalanceId: 101,
      leaveTypeId: 1,
      empId: 1001,
      balance: 12,
      allowLeavePerMonth: 1,
      leaveTypeName: "Casual Leave",
      validFromDate: "01/01/2025",
      validToDate: "31/12/2025",
      canTakeLeave: 1,
      isValidLeaveBalance: 1,
      isCalenderExists: 1,
    ),
    LeaveBalanceList(
      empLeaveBalanceId: 102,
      leaveTypeId: 2,
      empId: 1001,
      balance: 6,
      allowLeavePerMonth: 1,
      leaveTypeName: "Sick Leave",
      validFromDate: "01/01/2025",
      validToDate: "31/12/2025",
      canTakeLeave: 1,
      isValidLeaveBalance: 1,
      isCalenderExists: 0,
    ),
    LeaveBalanceList(
      empLeaveBalanceId: 103,
      leaveTypeId: 3,
      empId: 1001,
      balance: 18,
      allowLeavePerMonth: 2,
      leaveTypeName: "Annual Leave",
      validFromDate: "01/01/2025",
      validToDate: "31/12/2025",
      canTakeLeave: 1,
      isValidLeaveBalance: 1,
      isCalenderExists: 1,
    ),
    LeaveBalanceList(
      empLeaveBalanceId: 104,
      leaveTypeId: 4,
      empId: 1001,
      balance: 5,
      allowLeavePerMonth: 0,
      leaveTypeName: "Maternity Leave",
      validFromDate: "01/03/2025",
      validToDate: "31/12/2025",
      canTakeLeave: 0,
      isValidLeaveBalance: 0,
      isCalenderExists: 0,
    ),
  ];

  @override
  void initState() {
    //
    // context.read<LeaveBalanceCubit>().fetchLeaveBalance(_userAuthRepo.user.userId);
    // context.read<LeaveDataCubit>().fetchLeaveData(_userAuthRepo.user.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar('Leave Request'),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20) +
                const EdgeInsets.only(bottom: 28),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dummyLeaveBalanceList.length,
                itemBuilder: (context, index) {
                  return LeaveBox(
                    title: dummyLeaveBalanceList[index].leaveTypeName,
                    days: dummyLeaveBalanceList[index].balance.toString(),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20) +
                  const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return AppliedLeaveTile(
                  empLeaveData: dummyEmpLeaveDataList[index],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: dummyEmpLeaveDataList.length,
            ),
          ),
          /*BlocConsumer<LeaveBalanceCubit, LeaveBalanceState>(
            listener: (context, leaveBalanceState) {
              if (leaveBalanceState.status == LeaveBalanceStatus.error) {
                DisplayUtils.removeLoader();
                DisplayUtils.showToast(context, leaveBalanceState.message);
              } else if (leaveBalanceState.status ==
                  LeaveBalanceStatus.loading) {
                DisplayUtils.showLoader();
              } else if (leaveBalanceState.status ==
                  LeaveBalanceStatus.success) {
                DisplayUtils.removeLoader();
                // DisplayUtils.showToast(context, state.message);
              }
              ;
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20) +
                    const EdgeInsets.only(bottom: 28),
                child: SizedBox(
                  height: 100,
                  child: state.leaveBalanceList.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.leaveBalanceList.length,
                          itemBuilder: (context, index) {
                            return LeaveBox(
                              title:
                                  state.leaveBalanceList[index].leaveTypeName,
                              days: state.leaveBalanceList[index].balance
                                  .toString(),
                            );
                          },
                        )
                      : Text(
                          state.message,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                        ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<LeaveDataCubit, LeaveDataState>(
              builder: (context, leaveDataState) {
                if (leaveDataState.status == LeaveDataStatus.loading) {
                  return const LoadingIndicator();
                } else if (leaveDataState.status == LeaveDataStatus.error) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      leaveDataState.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                    ),
                  ));
                } else if (leaveDataState.status == LeaveDataStatus.success) {
                  var leaveDataList = leaveDataState.empLeaveDataList;
                  return Column(
                    children: [
                      Expanded(
                        child: leaveDataState.empLeaveDataList.isNotEmpty
                            ? ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20) +
                                        const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) {
                                  return AppliedLeaveTile(
                                      empLeaveData: leaveDataList[index]);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: leaveDataList.length)
                            : Center(
                                child: Text('No leave requests found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 16,
                                          color: AppColors.black,
                                        )),
                              ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),*/
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          title: 'Apply Leaves',
          height: 50,
          isEnabled: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApplyLeavePage()),
            );
          },
        ),
      ),
    );
  }
}
