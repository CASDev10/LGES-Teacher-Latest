import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';

import '../cubit/leaves_cubit.dart';
import '../dialogs/leave_detail_dialoge.dart';
import '../model/employee_leaves_response.dart';

class LeaveTile extends StatelessWidget {
  const LeaveTile({super.key, required this.detail});

  final EmployeeLeaveModel detail;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = detail.leaveStatusString.toString();
    final statusColor = _statusColor(status);

    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => LeaveDetailDialogue(model: detail),
        ).then((v) async {
          if (v == true) {
            await Future.wait([
              context.read<TeacherLeaveCubit>().fetchEmployeeLeaves(
                offSet: 0,
                next: 10,
              ),
              context.read<TeacherLeaveCubit>().fetchLeaveBalance(),
            ]);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${detail.fromDateString} → ${detail.toDateString}",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Divider(thickness: 0.5, color: Colors.grey.shade300),

              // 🔸 Leave Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoItem("Leave Type", detail.entityLeaveType),
                  _infoItem("Days", "${detail.days}"),
                  _infoItem("Status", '${detail.approved}', color: statusColor),
                ],
              ),

              const SizedBox(height: 8),
              Divider(thickness: 0.5, color: Colors.grey.shade200),

              // 🔹 Footer with Icon and Hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Applied on: ${detail.fromDateString}",
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(String title, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: color ?? AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
