import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lges_teacher_app/components/text_view.dart';

import '../constants/app_colors.dart';

class CustomDropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
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
  final Function(String value)? onSelect;
  final double height;
  final double width;

  const CustomDropDown({
    Key? key,
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
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? dropdownValue;

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
          child: DropdownButtonFormField(
            isExpanded: true,
            isDense: true,
            icon: Padding(
              padding: EdgeInsets.only(left: 16, right: 4),
              child: SvgPicture.asset(
                'assets/images/svg/ic_drop_down.svg',
                color: AppColors.primaryDark,
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
            value: dropdownValue,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onChanged: (String? newValue) {
              if (widget.onSelect != null) {
                if (newValue != null) {
                  widget.onSelect!(newValue);
                  setState(() {
                    dropdownValue = newValue;
                  });
                }
              }
            },
            menuMaxHeight: 550,
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: TextView(
                  overflow: TextOverflow.ellipsis,
                  value,
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
