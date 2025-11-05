import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lges_teacher_app/components/text_view.dart';

import '../config/routes/nav_router.dart';
import '../constants/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar(
    this.title, {
    this.centerTitle = false,
    this.actions,
    this.onBackIconClicked,
    this.elevation = 0,
    Key? key,
    this.leading,
  }) : super(key: key);
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onBackIconClicked;
  final double elevation;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: AppColors.primaryDark,
      elevation: elevation,
      centerTitle: centerTitle,
      actions: actions,
      leadingWidth: 70,
      leading:
          leading ??
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              NavRouter.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10) + EdgeInsets.only(left: 20),
              child: SvgPicture.asset(
                "assets/images/svg/ic_back_arrow.svg",
                height: 36,
                width: 50,
              ),
            ),
          ),
      title: TextView(
        title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
