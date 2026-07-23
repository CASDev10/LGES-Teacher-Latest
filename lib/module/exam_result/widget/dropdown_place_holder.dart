import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/text_view.dart';
import '../../../../constants/app_colors.dart';

class DropdownPlaceHolder extends StatelessWidget {
  const DropdownPlaceHolder({
    super.key,
    this.paddingAll = 0.0,
    this.horizontalPadding = 15.0,
    required this.name,
  });
  final double paddingAll;
  final String name;
  final double horizontalPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding:
          EdgeInsets.all(paddingAll) +
          EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextView(
            name,
            fontSize: 14.0,
            color: AppColors.primaryDark,
            overflow: TextOverflow.ellipsis,
          ),
          // Text(
          //   name,
          //   style: TextStyle(
          //     fontSize: 14.0,
          //     color: AppColors.primaryDark,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          SvgPicture.asset(
            'assets/images/svg/ic_drop_down.svg',
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}
