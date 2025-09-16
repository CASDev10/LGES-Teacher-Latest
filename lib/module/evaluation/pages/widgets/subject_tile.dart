

import 'package:flutter/cupertino.dart';

import '../../../../components/custom_textfield.dart';
import '../../../../constants/app_colors.dart';

class SubjectTile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: CustomTextField(
              hintText: 'Subject',
              height: 50,
              bottomMargin: 0,
              fontWeight: FontWeight.normal,
              inputType: TextInputType.text,
              fillColor: AppColors.lightGreyColor,
              hintColor: AppColors.grey,
            ),
          ),
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: CustomTextField(
                hintText: '0.00',
                height: 50,
                bottomMargin: 0,
                fontWeight: FontWeight.normal,
                inputType: TextInputType.text,
                fillColor: AppColors.lightGreyColor,
                hintColor: AppColors.grey,
              ),
            ))
      ],
    );
  }

}