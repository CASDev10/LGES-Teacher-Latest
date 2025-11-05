import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/text_view.dart';
import '../constants/app_colors.dart';

class CountdownTimerWidget extends StatefulWidget {
  const CountdownTimerWidget({super.key});

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  int? _endTime;
  Duration _timeRemaining = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadEndTime();
  }

  // Load the end time from shared preferences
  Future<void> _loadEndTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int endTime = prefs.getInt('end_time') ?? 0;
    setState(() {
      _endTime = endTime;
      _calculateTimeRemaining();
    });
    if (_endTime! > 0) {
      _startTimer();
    }
  }

  // Save the end time to shared preferences
  Future<void> _saveEndTime(int endTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('end_time', endTime);
  }

  // Calculate the remaining time
  void _calculateTimeRemaining() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (_endTime! > now) {
      _timeRemaining = Duration(milliseconds: _endTime! - now);
    } else {
      _timeRemaining = Duration.zero;
    }
  }

  // Start the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _calculateTimeRemaining();
        if (_timeRemaining == Duration.zero) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_timeRemaining.inMinutes}:${(_timeRemaining.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 36),
            ),
            ElevatedButton(
              onPressed: () {
                int now = DateTime.now().millisecondsSinceEpoch;
                int endTime =
                    now + (2 * 60 * 1000); // 2 minutes in milliseconds
                _saveEndTime(endTime);
                setState(() {
                  _endTime = endTime;
                  _timeRemaining = const Duration(minutes: 2);
                });
                _startTimer();
              },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneralCustomDropDown<T> extends StatefulWidget {
  final String hint;
  final T? selectedValue;
  final List<T> items;
  final bool disable;
  final Color borderColor;
  final Color hintColor;
  final Color iconColor;
  final bool isOutline;
  final String? suffixIconPath;
  final double allPadding;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Function(T value)? onSelect;
  final double height;
  final double width;
  final String Function(T)?
  displayField; // New field to specify which entity to display

  const GeneralCustomDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.height = 50,
    this.width = double.infinity,
    this.iconColor = AppColors.grey4,
    this.hintColor = AppColors.grey3,
    this.suffixIconPath,
    this.disable = false,
    this.borderColor = AppColors.whiteColor,
    this.fontSize = 14,
    this.onSelect,
    this.isOutline = true,
    this.allPadding = 10,
    this.fontWeight = FontWeight.w400,
    this.horizontalPadding = 16,
    this.verticalPadding = 0,
    this.displayField,
    this.selectedValue, // Passing the function to display specific field
  });

  @override
  State<GeneralCustomDropDown<T>> createState() =>
      _GeneralCustomDropDownState<T>();
}

class _GeneralCustomDropDownState<T> extends State<GeneralCustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: _boxDecoration(widget.isOutline),
      alignment: Alignment.center,
      child: IgnorePointer(
        ignoring: widget.disable,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: DropdownButtonFormField<T>(
            isExpanded: true,
            isDense: true,
            icon: SvgPicture.asset(
              'assets/images/svg/ic_drop_down.svg',
              color: AppColors.primaryDark,
            ),
            style: TextStyle(
              fontSize: widget.fontSize,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            menuMaxHeight: 550,
            hint: TextView(
              widget.hint,
              fontSize: widget.fontSize,
              color: widget.hintColor,
              fontWeight: widget.fontWeight,
              overflow: TextOverflow.ellipsis,
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: widget.fontSize,
                color: AppColors.primaryDark,
                fontWeight: widget.fontWeight,
              ),
              enabled: false,
              filled: true,
              fillColor: AppColors.lightGreyColor,
              contentPadding:
                  EdgeInsets.all(widget.allPadding) +
                  EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              border: _outlineInputBorder,
              enabledBorder: _outlineInputBorder,
              disabledBorder: _outlineInputBorder,
            ),
            dropdownColor: const Color(0xffF4F4F4),
            // value: widget.items.isNotEmpty ? widget.selectedValue : null,
            value: widget.selectedValue,
            items: widget.items.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  widget.displayField != null
                      ? widget.displayField!(
                          value,
                        ) // Use the displayField function
                      : value.toString(),
                  // Default to toString() if no displayField is provided
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              );
            }).toList(),
            onChanged: widget.disable
                ? null
                : (T? newValue) {
                    // setState(() {
                    //   widget.selectedValue = newValue;
                    // });
                    if (widget.onSelect != null && newValue != null) {
                      widget.onSelect!(newValue);
                    }
                  },
          ),
        ),
      ),
    );
  }
}

class GenericCustomDropDown<T> extends StatefulWidget {
  final String hint;
  final List<T> items;
  final String Function(T) getLabel;
  final Function(T value)? onSelect;
  final bool disable;
  final Color borderColor;
  final Color hintColor;
  final Color textColor;
  final Color fillColor;
  final Color iconColor;
  final bool isOutline;
  final String? suffixIconPath;
  final double allPadding;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? width;
  final double borderRadius;
  final T? selectedItem;

  const GenericCustomDropDown({
    super.key,
    required this.hint,
    required this.items,
    required this.getLabel,
    this.onSelect,
    this.disable = false,
    this.hintColor = const Color(0xff797575),
    this.textColor = Colors.black,
    this.suffixIconPath,
    this.borderColor = AppColors.primaryLight,
    this.fontSize = 14,
    this.isOutline = true,
    this.allPadding = 10,
    this.fontWeight = FontWeight.w500,
    this.horizontalPadding = 10,
    this.verticalPadding = 12,
    this.width,
    this.fillColor = Colors.transparent,
    this.iconColor = const Color(0xFFB6B6B6),
    this.borderRadius = 8,
    this.selectedItem,
  });

  @override
  State<GenericCustomDropDown<T>> createState() =>
      _GenericCustomDropDownState<T>();
}

class _GenericCustomDropDownState<T> extends State<GenericCustomDropDown<T>> {
  // T? dropdownValue;
  //
  // @override
  // void initState() {
  //   if (mounted && widget.selectedItem != null) {
  //     dropdownValue = widget.selectedItem;
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: DropdownButtonFormField<T>(
          value: widget.selectedItem,
          isExpanded: true,
          isDense: true,
          icon: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SvgPicture.asset(
              'assets/images/svg/drop_down.svg',
              color: widget.iconColor,
            ),
          ),
          style: TextStyle(
            color: widget.textColor,
            fontWeight: widget.fontWeight,
            fontSize: widget.fontSize,
          ),
          hint: Text(
            widget.hint,
            style: TextStyle(
              color: widget.hintColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            enabled: !widget.disable,
            filled: true,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: 1.2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
              vertical: widget.verticalPadding,
            ),
          ),
          dropdownColor: const Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          menuMaxHeight: 550,

          // ✅ Always provide onChanged, even if null
          onChanged: widget.disable
              ? null
              : (T? newValue) {
                  if (newValue != null) {
                    // setState(() {
                    //   dropdownValue = newValue;
                    // });
                    widget.onSelect?.call(newValue);
                  }
                },

          // ✅ Always provide items
          items: widget.items.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                widget.getLabel(value),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.textColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12.0),
  borderSide: const BorderSide(color: AppColors.lightGreyColor),
);

BoxDecoration _boxDecoration(bool isOutline) {
  if (isOutline) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.primaryDark,
        width: 1, //                   <--- border width here
      ),
    );
  } else {
    return const BoxDecoration(
      color: AppColors.lightGreyColor,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }
}
