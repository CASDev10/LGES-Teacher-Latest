import 'package:flutter/material.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';

import '../../../../config/routes/nav_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../auth/repo/auth_repository.dart';
import '../model/employee_leaves_response.dart';

class LeaveDetailDialogue extends StatelessWidget {
  LeaveDetailDialogue({super.key, required this.model});

  final EmployeeLeaveModel model;
  final AuthRepository _authRepository = sl<AuthRepository>();

  String getStatusText() {
    if (model.waitingForApproval == 1 && model.approved == true) {
      return "Approved";
    } else if (model.waitingForApproval == 1 && model.approved == false) {
      return "Rejected";
    } else {
      return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Header Row with Title & Close Button ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Leave Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => NavRouter.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// --- Employee Info ---
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(Icons.person, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _authRepository.user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// --- Leave Info Card ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow("Leave Type", model.entityLeaveType),
                    _spacer(),
                    _detailRow("Duration", "${model.days} days"),
                    _spacer(),
                    _detailRow(
                      "From - To",
                      "${model.fromDateString} → ${model.toDateString}",
                    ),
                    _spacer(),
                    _detailRow("Applied On", model.createdDateString),
                    _spacer(),
                    _detailRow("Status", getStatusText()),
                    _spacer(),
                    _detailRow("Reason", model.reason),
                    _spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              /// --- Footer Info ---
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Created by: ${model.createdBy} | ${model.fromDateString}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _spacer() => const SizedBox(height: 8);
}
