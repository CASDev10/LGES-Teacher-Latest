import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/module/exam_result/pages/show_result_screen.dart';
import 'package:lges_teacher_app/module/teacher_observation/cubit/observation_report_cubit/observation_report_cubit.dart';
import 'package:lges_teacher_app/module/teacher_observation/pages/show_report_screen.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/custom_date_time_picker.dart';

class ObservationReportScreen extends StatefulWidget {
  const ObservationReportScreen({super.key});

  @override
  State<ObservationReportScreen> createState() =>
      _ObservationReportScreenState();
}

class _ObservationReportScreenState extends State<ObservationReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CustomAppbar(
        'Teacher Observation',
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: 'Start Date',
                height: 50,
                readOnly: true,
                bottomMargin: 0,
                controller: startDateTextController,
                fontWeight: FontWeight.normal,
                inputType: TextInputType.text,
                fillColor: AppColors.lightGreyColor,
                hintColor: AppColors.blackColor,
                suffixWidget: SvgPicture.asset(
                  'assets/images/svg/ic_drop_down.svg',
                  color: AppColors.primaryDark,
                ),
                onTap: () async {
                  String date =
                      await CustomDateTimePicker.selectDate(context);
                  DateTime dateTime = DateFormat("dd/MM/yyyy").parse(date);
                  startDateTextController.text =
                      DateFormat("yyyy-MM-dd").format(dateTime);
                },
              ),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                hintText: 'End Date',
                height: 50,
                readOnly: true,
                bottomMargin: 0,
                controller: endDateTextController,
                fontWeight: FontWeight.normal,
                inputType: TextInputType.text,
                fillColor: AppColors.lightGreyColor,
                hintColor: AppColors.blackColor,
                suffixWidget: SvgPicture.asset(
                  'assets/images/svg/ic_drop_down.svg',
                  color: AppColors.primaryDark,
                ),
                onTap: () async {
                  String date =
                      await CustomDateTimePicker.selectDate(context);
                  DateTime dateTime = DateFormat("dd/MM/yyyy").parse(date);
                  endDateTextController.text =
                      DateFormat("yyyy-MM-dd").format(dateTime);
                },
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 70,
              ),
              CustomButton(
                onPressed: () {
                  if (startDateTextController.text.isNotEmpty) {
                    if (endDateTextController.text.isNotEmpty) {
                      NavRouter.push(context, ShowReportScreen(startDate: startDateTextController.text
                          .trim()
                          .toString(), endDate:  endDateTextController.text.trim().toString()));
                    } else {
                      DisplayUtils.showSnackBar(
                          context, "Please end date");
                    }
                  } else {
                    DisplayUtils.showSnackBar(
                        context, "Please start date");
                  }
                },
                title: 'Get Report',
                height: 50,
              )
            ],
          ),
        ),
      ),
      hMargin: 0,
    );
  }
}
