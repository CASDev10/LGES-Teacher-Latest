import 'package:flutter/cupertino.dart';
import 'package:lges_teacher_app/components/text_view.dart';

import '../../../components/custom_button.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 10,
            spreadRadius: 3.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            color: AppColors.lightGreyColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextView(
                    'Subject',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: AppColors.primaryDark,
                  ),
                ),
                Expanded(
                  child: TextView(
                    'Biology',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.end,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Container(
            color: AppColors.lightGreyColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextView(
                    'Section',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: AppColors.primaryDark,
                  ),
                ),
                Expanded(
                  child: TextView(
                    'Red',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.end,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Container(
            color: AppColors.lightGreyColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextView(
                    'Session',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: AppColors.primaryDark,
                  ),
                ),
                Expanded(
                  child: TextView(
                    '2023-2024',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.end,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          Container(
            color: AppColors.lightGreyColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextView(
                    'Process',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    color: AppColors.primaryDark,
                  ),
                ),
                Expanded(
                  child: TextView(
                    'N',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.end,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: CustomButton(
                    onPressed: () {},
                    width: 100,
                    title: 'Process',
                    fontSize: 14,
                    height: 34,
                    textColor: AppColors.whiteColor,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomButton(
                    isOutlinedButton: true,
                    textColor: AppColors.red,
                    onPressed: () {},
                    width: 100,
                    fontSize: 14,
                    title: 'Delete',
                    outlineColor: AppColors.red,
                    height: 34,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
