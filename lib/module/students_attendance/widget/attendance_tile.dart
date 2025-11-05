import 'package:flutter/material.dart';
import 'package:lges_teacher_app/components/text_view.dart';
import 'package:lges_teacher_app/module/students_attendance/models/attendance_reponse.dart';

import '../../../constants/app_colors.dart';

class AttendanceTile extends StatefulWidget {
  const AttendanceTile({
    super.key,
    required this.attendanceModel,
    required this.index,
    this.onSelect,
    this.enableSelection = true,
  });

  final AttendanceModel attendanceModel;
  final int index;
  final bool enableSelection;
  final Function(int status, int studentId)? onSelect;

  @override
  State<AttendanceTile> createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                alignment: FractionalOffset.centerLeft,
                width: 30.0,
                padding: const EdgeInsets.only(right: 3.0, left: 5.0),
                child: TextView(
                  widget.index < 10 ? "0${widget.index}" : "${widget.index}",
                  color: AppColors.primaryDark,
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: FractionalOffset.centerLeft,
                  padding: const EdgeInsets.only(right: 3.0, left: 5),
                  child: Text(
                    widget.attendanceModel.studentName.toString(),
                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.enableSelection)
                setState(() {
                  widget.attendanceModel.attendanceStatusIdFk = 2;
                  if (widget.onSelect != null) {
                    widget.onSelect!(
                      widget.attendanceModel.attendanceStatusIdFk,
                      widget.attendanceModel.studentId,
                    );
                  }
                });
            },
            child: Container(
              alignment: FractionalOffset.center,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.attendanceModel.attendanceStatusIdFk == 2
                      ? AppColors.primaryDark
                      : AppColors.greyColor,
                ),
                color: widget.attendanceModel.attendanceStatusIdFk == 2
                    ? AppColors.primaryDark
                    : AppColors.transparent,
              ),
              child: Center(
                child: Visibility(
                  visible: widget.attendanceModel.attendanceStatusIdFk == 2,
                  child: Text(
                    "A",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.enableSelection)
                setState(() {
                  widget.attendanceModel.attendanceStatusIdFk = 1;
                  if (widget.onSelect != null) {
                    widget.onSelect!(
                      widget.attendanceModel.attendanceStatusIdFk,
                      widget.attendanceModel.studentId,
                    );
                  }
                });
            },
            child: Container(
              alignment: FractionalOffset.center,
              width: 60.0,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.attendanceModel.attendanceStatusIdFk == 1
                      ? AppColors.primaryDark
                      : AppColors.greyColor,
                ),
                color: widget.attendanceModel.attendanceStatusIdFk == 1
                    ? AppColors.primaryDark
                    : AppColors.transparent,
              ),
              child: Visibility(
                visible: widget.attendanceModel.attendanceStatusIdFk == 1,
                child: Text(
                  "P",
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.enableSelection)
                setState(() {
                  widget.attendanceModel.attendanceStatusIdFk = 3;
                  if (widget.onSelect != null) {
                    widget.onSelect!(
                      widget.attendanceModel.attendanceStatusIdFk,
                      widget.attendanceModel.studentId,
                    );
                  }
                });
            },
            child: Container(
              alignment: FractionalOffset.center,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.attendanceModel.attendanceStatusIdFk == 3
                      ? AppColors.primaryDark
                      : AppColors.greyColor,
                ),
                color: widget.attendanceModel.attendanceStatusIdFk == 3
                    ? AppColors.primaryDark
                    : AppColors.transparent,
              ),
              child: Visibility(
                visible: widget.attendanceModel.attendanceStatusIdFk == 3,
                child: Text(
                  "L",
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
