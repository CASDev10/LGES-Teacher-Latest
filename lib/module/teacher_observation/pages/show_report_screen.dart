import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/module/teacher_observation/widgets/observation_report_tile.dart';

import '../../../components/base_scaffold.dart';
import '../../../components/custom_appbar.dart';
import '../../../components/loading_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../cubit/observation_report_cubit/observation_report_cubit.dart';

class ShowReportScreen extends StatefulWidget {
  final String startDate;
  final String endDate;

  const ShowReportScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ShowReportScreen> createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ObservationReportCubit(sl())
            ..getObservationReport(widget.startDate, widget.endDate),
      child: BaseScaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: const CustomAppbar('Teacher Observation', centerTitle: true),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: BlocBuilder<ObservationReportCubit, ObservationReportState>(
            builder: (context, state) {
              if (state.observationReportStatus ==
                  ObservationReportStatus.loading) {
                return Center(child: LoadingIndicator());
              } else if (state.observationReportStatus ==
                  ObservationReportStatus.success) {
                return Column(
                  children: [
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        itemCount: state.observationReportList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ObservationReportTile(
                            model: state.observationReportList[index],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state.observationReportStatus ==
                  ObservationReportStatus.failure) {
                return Center(child: Text(state.failure.message));
              }

              return SizedBox();
            },
          ),
        ),
        hMargin: 0,
      ),
    );
  }
}
