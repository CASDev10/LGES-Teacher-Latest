import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.enableBorderColor = Colors.orangeAccent,
    this.focusBorderColor = Colors.orange,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixWidget,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.obscureText = false,
    this.fillColor = Colors.white,
    this.bottomMargin = 12,
    this.height = 42,
    this.onTap,
    this.controller,
    this.inputType,
    this.inputFormatters,
    this.onSaved,
    this.onChange,
    this.onValidate,
    this.hasTitle = true,
    this.maxLines = 1,
    this.hintColor = AppColors.grey,
    this.maxLength
  });

  final Color fillColor;
  final String hintText;
  final double bottomMargin;
  final double height;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Color enableBorderColor;
  final Color focusBorderColor;
  final Color hintColor;
  final Widget? prefixIcon;
  final Widget? suffixWidget;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool obscureText;
  final VoidCallback? onTap;
  final bool hasTitle;

  final TextEditingController? controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? val)? onSaved;
  final void Function(String val)? onChange;
  final String? Function(String? val)? onValidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(fontSize: fontSize, color: AppColors.primaryDark,fontWeight: fontWeight,),
          keyboardType: inputType,
          validator: onValidate,
          onSaved: onSaved,
          maxLines: maxLines,
          onChanged: onChange,
          inputFormatters: inputFormatters,
          onTap: onTap,
          maxLength: maxLength,
          cursorColor: AppColors.primaryLight,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
            fillColor: AppColors.lightGreyColor,
            hintText: hintText,
            counterText: "",
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Padding(child: prefixIcon, padding: EdgeInsets.only(left: 16),),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 16),
              child: suffixWidget,
            ),
            prefixIconConstraints: const BoxConstraints(maxHeight: 44, maxWidth: 44),
            suffixIconConstraints:
              const BoxConstraints(maxHeight: 50, maxWidth: 50),
            contentPadding: EdgeInsets.symmetric( vertical: 16, horizontal: 16),
            constraints: BoxConstraints(
              minHeight: 50,
            )
          ),
        ),
        SizedBox(
          height: bottomMargin,
        ),
      ],
    );
  }
}
