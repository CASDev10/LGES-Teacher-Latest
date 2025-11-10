import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lges_teacher_app/components/text_view.dart';

import '../constants/app_colors.dart';

class GenericDropDown<T> extends StatefulWidget {
  final String hint;
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
  final String Function(T item) getLabel;
  final T? selectedValue;

  const GenericDropDown({
    Key? key,
    required this.hint,
    required this.items,
    required this.getLabel,
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
    this.selectedValue,
  }) : super(key: key);

  @override
  State<GenericDropDown<T>> createState() => _GenericDropDownState<T>();
}

class _GenericDropDownState<T> extends State<GenericDropDown<T>> {
  T? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant GenericDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ensure dropdownValue is null if it's not part of the updated items list
    if (dropdownValue != null && !widget.items.contains(dropdownValue)) {
      dropdownValue = null;
    }
  }

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
            icon: Padding(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: SvgPicture.asset(
                'assets/images/svg/ic_drop_down.svg',
                color: widget.iconColor,
              ),
            ),
            style: TextStyle(
              fontSize: widget.fontSize,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
            hint: TextView(
              widget.hint,
              fontSize: widget.fontSize,
              color: widget.hintColor,
              fontWeight: widget.fontWeight,
              overflow: TextOverflow.ellipsis,
            ),
            decoration: InputDecoration(
              enabled: false,
              filled: true,
              fillColor: AppColors.lightGreyColor,
              contentPadding:
                  EdgeInsets.all(widget.allPadding) +
                  EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
              border: _outlineInputBorder,
              enabledBorder: _outlineInputBorder,
              disabledBorder: _outlineInputBorder,
            ),
            dropdownColor: const Color(0xffF4F4F4),
            value: widget.items.contains(dropdownValue)
                ? dropdownValue
                : null, // ✅ Prevent invalid value
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onChanged: (T? newValue) {
              if (widget.onSelect != null && newValue != null) {
                widget.onSelect!(newValue);
                setState(() => dropdownValue = newValue);
              }
            },
            items: widget.items.map((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: TextView(
                  widget.getLabel(value),
                  overflow: TextOverflow.ellipsis,
                  fontSize: widget.fontSize,
                  color: widget.hintColor,
                ),
              );
            }).toList(),
          ),
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
      border: Border.all(color: AppColors.primaryDark, width: 1),
    );
  } else {
    return const BoxDecoration(
      color: AppColors.lightGreyColor,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
  }
}
