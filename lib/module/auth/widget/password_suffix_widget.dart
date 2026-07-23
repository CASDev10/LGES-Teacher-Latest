import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';

class PasswordSuffixWidget extends StatelessWidget {
  const PasswordSuffixWidget({
    Key? key,
    required this.isPasswordVisible,
    required this.onTap,
  }) : super(key: key);
  final bool isPasswordVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 20,
      icon: SvgPicture.asset(
        'assets/images/svg/ic_eye_${isPasswordVisible ? 'invisible.svg' : 'visible.svg'}',
        color: AppColors.grey,
        height: 16,
      ),
    );
  }
}
