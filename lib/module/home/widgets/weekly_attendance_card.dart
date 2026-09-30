import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyAttendanceCard extends StatelessWidget {
  final VoidCallback? onFullReportTap;
  final List<double> weeklyData;
  final List<String> dayLabels;

  const WeeklyAttendanceCard({
    Key? key,
    this.onFullReportTap,
    this.weeklyData = const [0.65, 0.85, 0.60, 0.80, 0.45],
    this.dayLabels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2E78).withValues(alpha: 0.07),
            offset: const Offset(0, 2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and "Full Report →"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "This Week's Attendance",
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              InkWell(
                onTap: onFullReportTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Full Report',
                        style: TextStyle(
                          color: Color(0xFF1B2E78),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF1B2E78),
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Interactive Bar Chart with fl_chart
          SizedBox(
            height: 100,
            child: BarChart(
              BarChartData(
                maxY: 1.0,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF112461),
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tooltipMargin: 6,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final String day = dayLabels[groupIndex];
                      final int pct = (rod.toY * 100).toInt();
                      return BarTooltipItem(
                        "$day: $pct%",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index >= 0 && index < dayLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              dayLabels[index],
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(dayLabels.length, (index) {
                  final double fillRatio = (index < weeklyData.length)
                      ? weeklyData[index].clamp(0.1, 1.0)
                      : 0.5;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: fillRatio,
                        width: 22,
                        color: const Color(0xFF1B2E78),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
