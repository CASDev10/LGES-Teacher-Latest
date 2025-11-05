import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../constants/app_colors.dart';

class CustomCalendarWidget extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final DateTime? firstDay;
  final DateTime? lastDay;

  const CustomCalendarWidget({
    super.key,
    required this.onDaySelected,
    this.firstDay,
    this.lastDay,
  });

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime selectedDay;
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // Use provided first/last day or fall back to defaults
    final DateTime firstDay = widget.firstDay ?? DateTime.now();
    final DateTime lastDay = widget.lastDay ?? DateTime.utc(2050, 12, 31);

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),

      onDaySelected: (selected, focused) {
        if (!selected.isBefore(firstDay) && !selected.isAfter(lastDay)) {
          setState(() {
            selectedDay = selected;
            focusedDay = focused;
          });
          widget.onDaySelected(selectedDay);
        }
      },

      enabledDayPredicate: (day) {
        // Enable only days between firstDay and lastDay (inclusive)
        return !day.isBefore(firstDay) && !day.isAfter(lastDay);
      },

      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: false,
        leftChevronVisible: true,
        rightChevronVisible: true,
        leftChevronIcon: Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xffA5A5A5),
          size: 18,
        ),
        rightChevronIcon: Icon(
          Icons.arrow_forward_ios,
          color: Color(0xffA5A5A5),
          size: 18,
        ),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryLight),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        disabledTextStyle: TextStyle(color: Colors.grey.shade400),
        selectedTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        defaultTextStyle: const TextStyle(fontSize: 16),
      ),

      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.black),
        weekdayStyle: TextStyle(color: Colors.black),
      ),

      calendarFormat: CalendarFormat.month,
      availableGestures: AvailableGestures.none,
      daysOfWeekVisible: true,
    );
  }
}
