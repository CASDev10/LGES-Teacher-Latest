

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';

import '../../../../components/text_view.dart';

class CampusesTile extends StatefulWidget{
  final String campusName ;

  const CampusesTile({super.key, required this.campusName});

  @override
  State<CampusesTile> createState() => _CampusesState();
}

class _CampusesState extends State<CampusesTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          Image.asset("assets/images/png/ic_school.png",),
          SizedBox(width: 15,),
          Expanded(child: TextView(
            widget.campusName,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
          SizedBox(width: 10,),
          SvgPicture.asset("assets/images/svg/ic_arrow_forward.svg",),
        ],
      ),
    );
  }
}