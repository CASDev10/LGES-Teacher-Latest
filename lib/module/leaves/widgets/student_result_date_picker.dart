import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../utils/custom_date_time_picker.dart';

class AddResultDatePicker extends StatefulWidget {
  const AddResultDatePicker({
    super.key,
    required this.stringFunction,
    required this.hintText,
    this.isOutline = false,
    this.selectedDate,
  });
  final Function(String) stringFunction;
  final String hintText;
  final bool isOutline;
  final String? selectedDate;
  @override
  _AddResultDatePickerState createState() => _AddResultDatePickerState();
}

class _AddResultDatePickerState extends State<AddResultDatePicker> {
  String selectedDate = ''; // Default text to show
  @override
  void initState() {
    if (widget.selectedDate != null) {
      selectedDate = widget.selectedDate!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Pick the date and update the selectedDate variable
        final String dateString = await CustomDateTimePicker.selectDate(
          context,
        );
        if (dateString.isNotEmpty) {
          // Parse the selected date string ('dd/MM/yyyy') into DateTime object
          final DateTime parsedDate = DateFormat(
            'dd/MM/yyyy',
          ).parse(dateString);

          // Format the parsed DateTime into 'yyyy-MM-dd'
          final String formattedDate = DateFormat(
            'yyyy-MM-dd',
          ).format(parsedDate);

          setState(() {
            selectedDate = formattedDate;
          });

          // Pass the formatted date to the parent widget
          widget.stringFunction(formattedDate);
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isOutline
                ? AppColors.primaryDark
                : Colors.transparent,
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primaryDark,
                size: 22,
              ),
              SizedBox(width: 8.0),
              Text(
                selectedDate.isNotEmpty
                    ? selectedDate
                    : widget
                          .hintText, // Display the selected date in 'yyyy-MM-dd' format
                style: TextStyle(fontSize: 14, color: AppColors.primaryDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
