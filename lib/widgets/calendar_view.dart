import 'package:flutter/material.dart';
import 'package:lges_teacher_app/components/text_view.dart';

import '../constants/app_colors.dart';

class HorizontalCalendarView extends StatefulWidget {
  @override
  _HorizontalCalendarViewState createState() => _HorizontalCalendarViewState();
}

class _HorizontalCalendarViewState extends State<HorizontalCalendarView> {
  DateTime selectedDate = DateTime.now(); // TO tracking date

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController =
      ScrollController(); //To Track Scroll of ListView

  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 85,
              child: ListView.builder(
                itemCount: 7,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextView(
                          listOfDays[DateTime.now()
                                      .add(Duration(days: index))
                                      .weekday -
                                  1]
                              .toString(),
                          fontSize: 14,
                          color: currentDateSelectedIndex == index
                              ? AppColors.primaryDark
                              : AppColors.greyColor,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 35.0,
                          width: 35.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentDateSelectedIndex == index
                                ? AppColors.primaryDark
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(44.0),
                          ),
                          child: TextView(
                            DateTime.now()
                                .add(Duration(days: index))
                                .day
                                .toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: currentDateSelectedIndex == index
                                ? AppColors.whiteColor
                                : AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          height: 2.0,
                          width: 30.0,
                          color: currentDateSelectedIndex == index
                              ? AppColors.primaryDark
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const Positioned(
          bottom: .4,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: .5, color: AppColors.darkGreyColor),
          ),
        ),
      ],
    );
  }
}
