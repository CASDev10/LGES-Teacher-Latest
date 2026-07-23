import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lges_teacher_app/module/exam_result/widget/result_tile.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../constants/app_colors.dart';

class ShowResultScreen extends StatelessWidget {
  const ShowResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar('Process Result', centerTitle: true),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ResultTile();
          },
          itemCount: 5,
          padding: EdgeInsets.only(top: 40, bottom: 24),
        ),
      ),
      hMargin: 0,
      backgroundColor: AppColors.primaryDark,
    );
  }
}
