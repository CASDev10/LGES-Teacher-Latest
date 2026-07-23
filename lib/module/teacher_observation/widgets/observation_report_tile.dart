import 'package:flutter/cupertino.dart';

import '../../../components/text_view.dart';
import '../../../constants/app_colors.dart';
import '../models/observation_report_response.dart';

class ObservationReportTile extends StatefulWidget {
  final ObservationReportModel model;

  const ObservationReportTile({super.key, required this.model});

  @override
  State<ObservationReportTile> createState() => _ObservationReportTileState();
}

class _ObservationReportTileState extends State<ObservationReportTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      padding: EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 8,
            spreadRadius: .5,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  'S.NO',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.srNo.toString(),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  'Submit Date',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.submitDate,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  'Level',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.level,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Section Head's Name",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.headName,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Teacher's Name",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.teacherName,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Punctuality",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.punctuality,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Communications Skills",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.communicationSkills,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Quality of Teaching",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.qualityOfTeaching,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Notebook Checking",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.notebookChecking,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Support provided to LRSs",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.supportProvidedToLrLs,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Duties Performed (MOD,BREAK,DISPlINE etc",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.dutiesPerformedModBreakDisciplineEtc,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextView(
                  "Contribution in Whole School Programmes",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextView(
                  widget.model.contributionInWholeSchoolProgrammes,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  "Feedback Provided to Teacher",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                ),
                TextView(
                  widget.model.feedBack,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.end,
                  color: AppColors.primaryDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
