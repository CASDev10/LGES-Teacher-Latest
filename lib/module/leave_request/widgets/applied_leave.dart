import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lges_teacher_app/components/custom_button.dart';

import '../../../constants/app_colors.dart';
import '../model/leave_data_response.dart';

class AppliedLeaveTile extends StatelessWidget {
  final EmpLeaveDataList empLeaveData;
  const AppliedLeaveTile({super.key, required this.empLeaveData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Date',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE8771B)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  empLeaveData.status,
                  style: const TextStyle(
                    color: Color(0xffE8771B),

                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset("assets/images/svg/ic_schedule_time.svg"),
              const SizedBox(width: 3),
              Text(
                empLeaveData.appliedDate,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xff717171),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              CustomButton(
                width: 140,
                fontSize: 11,
                onPressed: () async {},
                title: 'Attached Document',
              ),
            ],
          ),
          const Divider(height: 40, color: Color(0xffE0E0E0)),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Apply Days',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Expanded(
                child: Text(
                  'Leave Type',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      empLeaveData.days.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Days",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  empLeaveData.leaveTypeName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reliever Name',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  empLeaveData.relieverName ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
