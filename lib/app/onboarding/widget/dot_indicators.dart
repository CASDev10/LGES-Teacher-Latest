import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';

class BuildDotIndicators extends StatelessWidget {
  const BuildDotIndicators({Key? key, required this.selectedIndex})
    : super(key: key);
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => DotIndicator(isActive: selectedIndex == index),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({Key? key, required this.isActive}) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: isActive ? 36 : 10,
        decoration: isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryDark,
              )
            : const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey3,
              ),
      ),
    );
  }
}
