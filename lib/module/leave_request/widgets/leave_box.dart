import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class LeaveBox extends StatelessWidget {
  final String title;
  final String days;

  const LeaveBox({super.key, required this.title, required this.days});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLight,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  days,
                  style: const TextStyle(
                    fontSize: 20, // slightly bigger for emphasis
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Days",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
