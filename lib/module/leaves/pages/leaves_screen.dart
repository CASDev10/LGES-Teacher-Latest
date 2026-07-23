import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/leaves/cubit/leave_balance/leave_balance_state.dart';
import 'package:lges_teacher_app/module/leaves/cubit/leaves_state.dart';

import '../../../../components/custom_appbar.dart';
import '../../../../core/di/service_locator.dart';
import '../../../components/base_scaffold.dart';
import '../../../components/custom_button.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/display/display_utils.dart';
import '../cubit/apply_leave_cubit/apply_leave_cubit.dart';
import '../cubit/apply_leave_cubit/apply_leave_state.dart';
import '../cubit/leave_balance/leave_balance_cubit.dart';
import '../cubit/leaves_cubit.dart';
import '../dialogs/apply_leave_dialogue.dart';
import '../model/employee_leaves_response.dart';
import '../widgets/attendance_card.dart';
import '../widgets/leave_tile.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TeacherLeaveCubit(sl())..fetchEmployeeLeaves(offSet: 0, next: 10),
        ),
        BlocProvider(
          create: (context) => LeaveBalanceCubit(sl())..fetchLeaveBalance(),
        ),
      ],
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
            BlocBuilder<LeaveBalanceCubit, LeaveBalanceState>(
              builder: (context, leaveBalanceState) {
                if (leaveBalanceState.leaveBalanceStatus ==
                    LeaveBalanceStatus.loading) {
                  return SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (leaveBalanceState.leaveBalanceStatus ==
                    LeaveBalanceStatus.failure) {
                  return Center(
                    child: Text(
                      leaveBalanceState.failure.message,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  );
                }
                if (leaveBalanceState.leaveBalanceStatus ==
                    LeaveBalanceStatus.success) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        leaveBalanceState.leaveBalance.length,
                        (index) {
                          var item = leaveBalanceState.leaveBalance[index];
                          return AttendanceCard(
                            cardName:
                                '${item.leaveTypeName.split(' ')[0]} ${item.leaveTypeName.split(' ')[1]}',
                            value: item.balance.toString(),
                          );
                        },
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
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
            Expanded(
              child: BlocBuilder<TeacherLeaveCubit, TeacherLeaveState>(
                builder: (context, leaveState) {
                  if (leaveState.leaveStatus == TeacherLeaveStatus.loading) {
                    return SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (leaveState.leaveStatus == TeacherLeaveStatus.failure) {
                    return Center(
                      child: Text(
                        leaveState.failure.message,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  }
                  if (leaveState.leaveStatus == TeacherLeaveStatus.success) {
                    return leaveState.employeeLeaves.isNotEmpty
                        ? ListView.separated(
                            controller: _scrollController,
                            itemCount: leaveState.employeeLeaves.length,
                            itemBuilder: (context, index) {
                              EmployeeLeaveModel employeeLeave =
                                  leaveState.employeeLeaves[index];
                              return LeaveTile(detail: employeeLeave);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return SizedBox(height: 12.0);
                                },
                          )
                        : Center(
                            child: Text(
                              "No Leaves Applied",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          );
                  }
                  return SizedBox.shrink();
                },
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
  } else if (applyLeaveState.studentAttendanceStatus ==
      ApplyLeaveStatus.failure) {
    DisplayUtils.removeLoader();
    DisplayUtils.showToast(
      context,
      applyLeaveState.failure.message,
    );
  }
},   builder: (context, applyLeaveState) {
                return BlocBuilder<LeaveBalanceCubit, LeaveBalanceState>(
                  builder: (context, state) {
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
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      hMargin: 0,
      appBar: CustomAppbar("Apply Leaves", centerTitle: true),
      backgroundColor: AppColors.primaryDark,
    );
  }
}
