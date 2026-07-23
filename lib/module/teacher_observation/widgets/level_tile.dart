import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lges_teacher_app/module/teacher_observation/models/observation_levels_response.dart';

import '../../../components/custom_button.dart';
import '../../../components/text_view.dart';
import '../../../constants/app_colors.dart';

class ObservationLevelTile extends StatefulWidget {
  final ObservationLevelModel observationLevelModel;
  final void Function(bool value)? onButtonPressYes;

  const ObservationLevelTile({
    super.key,
    required this.observationLevelModel,
    this.onButtonPressYes,
  });

  @override
  State<ObservationLevelTile> createState() => _ObservationLevelTileState();
}

class _ObservationLevelTileState extends State<ObservationLevelTile> {
  TextEditingController addLevelTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 8,
            spreadRadius: .5,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: TextView(
              'Level',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
              color: AppColors.blackColor,
            ),
          ),
          Container(
            color: AppColors.lightGreyColor,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextView(
              widget.observationLevelModel.level,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.start,
              color: AppColors.primaryDark,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: CustomButton(
                    onPressed: () {
                      widget.onButtonPressYes!(true);
                    },
                    width: 100,
                    title: 'Edit',
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
                    onPressed: () {
                      widget.onButtonPressYes!(false);
                    },
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
