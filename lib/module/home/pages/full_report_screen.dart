import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/core/di/service_locator.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';

class FullReportScreen extends StatefulWidget {
  const FullReportScreen({Key? key}) : super(key: key);

  @override
  State<FullReportScreen> createState() => _FullReportScreenState();
}

class _FullReportScreenState extends State<FullReportScreen> {
  final AuthRepository _repository = sl<AuthRepository>();

  int _selectedFilterIndex = 1; // 0: Today, 1: This Week, 2: This Month, 3: This Term, 4: Custom
  final List<String> _filters = [
    "Today",
    "This Week",
    "This Month",
    "This Term",
    "Custom",
  ];

  // Toggle chart vs table view per section (default to table view as requested by Figma mockup)
  bool _showClassChart = false;
  bool _showStudentTrendChart = false;
  bool _showTeacherAttendanceChart = false;
  bool _showPerformanceChart = false;
  bool _showMonthlyComparisonChart = false;
  bool _showTermComparisonChart = false;
  bool _showLeaveStatsChart = false;
  bool _showRecentActivityChart = false;

  // Filter dropdown values
  String _selectedClassFilter = "Monthly";
  String _selectedStudentTrendFilter = "Weekly";
  String _selectedTeacherFilter = "Weekly";
  String _selectedPerfFilter = "Monthly";
  String _selectedMonthlyFilter = "Monthly";
  String _selectedTermFilter = "Monthly";
  String _selectedLeaveFilter = "Monthly";
  String _selectedActivityFilter = "Daily";

  // Search query controllers
  final TextEditingController _classSearchController = TextEditingController();
  final TextEditingController _activitySearchController = TextEditingController();

  // Touched bar indices for fl_chart interactive highlights
  int? _touchedClassBarIndex;

  @override
  void dispose() {
    _classSearchController.dispose();
    _activitySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      hMargin: 0,
      safeAreaTop: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(),
            const SizedBox(height: 12),
            _buildTimeFilterTabs(),
            const SizedBox(height: 20),
            _buildSectionHeader("Key Metrics"),
            const SizedBox(height: 12),
            _buildKeyMetricsCarousel(),
            const SizedBox(height: 24),
            _buildSectionHeader("Analytics — Toggle Chart / Table View"),
            const SizedBox(height: 14),
            _buildAttendanceByClassCard(),
            const SizedBox(height: 16),
            _buildStudentAttendanceTrendCard(),
            const SizedBox(height: 16),
            _buildTeacherAttendanceCard(),
            const SizedBox(height: 16),
            _buildStudentPerformanceCard(),
            const SizedBox(height: 16),
            _buildMonthlyComparisonCard(),
            const SizedBox(height: 16),
            _buildTermComparisonCard(),
            const SizedBox(height: 16),
            _buildLeaveStatisticsCard(),
            const SizedBox(height: 16),
            _buildRecentActivitySummaryCard(),
            const SizedBox(height: 24),
            _buildSectionHeader("Export Reports"),
            const SizedBox(height: 12),
            _buildExportReportsSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Top Curved Header
  // -------------------------------------------------------------
  Widget _buildTopHeader() {
    final String fullName = _repository.user.fullName.isNotEmpty
        ? _repository.user.fullName
        : "Mr. Tariq Mehmood";
    final String schoolName = _repository.user.schoolName != null && _repository.user.schoolName!.isNotEmpty
        ? _repository.user.schoolName!
        : "LGES Principal / Teacher";

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/png/bg_home_top_view.png"),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 40,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF0554F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      schoolName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Image.asset(
            "assets/images/png/app_logo.png",
            height: 95,
            width: 95,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Time Filter Tabs
  // -------------------------------------------------------------
  Widget _buildTimeFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final bool isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF112461) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF112461).withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF4B5563),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------------------------------
  // Section Header Indicator
  // -------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF112461),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Key Metrics Carousel / Row
  // -------------------------------------------------------------
  Widget _buildKeyMetricsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildMetricCard(
            icon: Icons.people_outline_rounded,
            iconBg: const Color(0xFFEEF2FF),
            iconColor: const Color(0xFF112461),
            value: "1,248",
            label: "Students",
            trend: "+1.8%",
            sparklineColor: const Color(0xFF112461),
            spots: const [
              FlSpot(0, 1.2),
              FlSpot(1, 1.5),
              FlSpot(2, 1.3),
              FlSpot(3, 1.8),
              FlSpot(4, 1.7),
              FlSpot(5, 2.2),
              FlSpot(6, 2.4),
            ],
          ),
          const SizedBox(width: 12),
          _buildMetricCard(
            icon: Icons.menu_book_outlined,
            iconBg: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF22C55E),
            value: "86",
            label: "Teachers",
            trend: "+2.4%",
            sparklineColor: const Color(0xFF22C55E),
            spots: const [
              FlSpot(0, 75),
              FlSpot(1, 78),
              FlSpot(2, 80),
              FlSpot(3, 79),
              FlSpot(4, 83),
              FlSpot(5, 84),
              FlSpot(6, 86),
            ],
          ),
          const SizedBox(width: 12),
          _buildMetricCard(
            icon: Icons.show_chart_rounded,
            iconBg: const Color(0xFFDBEAFE),
            iconColor: const Color(0xFF2563EB),
            value: "88%",
            label: "Attendance",
            trend: "+3.2%",
            sparklineColor: const Color(0xFF2563EB),
            spots: const [
              FlSpot(0, 80),
              FlSpot(1, 82),
              FlSpot(2, 81),
              FlSpot(3, 85),
              FlSpot(4, 84),
              FlSpot(5, 87),
              FlSpot(6, 88),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
    required String trend,
    required Color sparklineColor,
    required List<FlSpot> spots,
  }) {
    return Container(
      width: 135,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              SizedBox(
                width: 54,
                height: 24,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: sparklineColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: sparklineColor.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                color: Color(0xFF22C55E),
                size: 12,
              ),
              const SizedBox(width: 2),
              Text(
                trend,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 1: Attendance by Class
  // -------------------------------------------------------------
  Widget _buildAttendanceByClassCard() {
    final List<Map<String, dynamic>> classData = [
      {"class": "Nursery", "students": 47, "present": 42, "absent": 5, "rate": "82%"},
      {"class": "Prep", "students": 50, "present": 45, "absent": 5, "rate": "90%"},
      {"class": "Class 1", "students": 45, "present": 39, "absent": 6, "rate": "87%"},
      {"class": "Class 2", "students": 48, "present": 39, "absent": 9, "rate": "81%"},
      {"class": "Class 3", "students": 44, "present": 37, "absent": 7, "rate": "84%"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Attendance by Class",
      filterValue: _selectedClassFilter,
      filterOptions: const ["Monthly", "Weekly", "Daily", "All Classes"],
      onFilterChanged: (v) => setState(() => _selectedClassFilter = v),
      isChartView: _showClassChart,
      onToggleView: () => setState(() => _showClassChart = !_showClassChart),
      child: _showClassChart
          ? _buildClassBarChart(classData)
          : Column(
              children: [
                _buildSearchField(
                  controller: _classSearchController,
                  hint: "Search...",
                ),
                const SizedBox(height: 12),
                _buildFigmaStyledTable(
                  headers: const ["Class", "Students", "Present", "Absent", "Rate"],
                  rows: classData.map((d) {
                    return [
                      d["class"].toString(),
                      d["students"].toString(),
                      d["present"].toString(),
                      d["absent"].toString(),
                      d["rate"].toString(),
                    ];
                  }).toList(),
                  badgeColumnIndex: 4,
                  badgeType: BadgeType.green,
                ),
                const SizedBox(height: 10),
                _buildTablePagination(showing: "Showing 1-5 of 12"),
              ],
            ),
    );
  }

  Widget _buildClassBarChart(List<Map<String, dynamic>> classData) {
    return Column(
      children: [
        ...classData.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> item = entry.value;
          final String name = item["class"] as String;
          final int pct = int.tryParse(item["rate"].toString().replaceAll('%', '')) ?? 80;
          final bool isTouched = _touchedClassBarIndex == index;

          return GestureDetector(
            onTapDown: (_) => setState(() => _touchedClassBarIndex = index),
            onTapUp: (_) => setState(() => _touchedClassBarIndex = null),
            onTapCancel: () => setState(() => _touchedClassBarIndex = null),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 11,
                        color: isTouched ? const Color(0xFF112461) : const Color(0xFF4B5563),
                        fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Container(
                              height: 12,
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 12,
                              width: constraints.maxWidth * (pct / 100.0),
                              decoration: BoxDecoration(
                                color: isTouched ? const Color(0xFF2563EB) : const Color(0xFF112461),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 36,
                    child: Text(
                      "$pct%",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // -------------------------------------------------------------
  // Card 2: Student Attendance Trend
  // -------------------------------------------------------------
  Widget _buildStudentAttendanceTrendCard() {
    final List<Map<String, dynamic>> trendData = [
      {"period": "W-1", "present": "89%", "absent": "11%"},
      {"period": "W-2", "present": "91%", "absent": "9%"},
      {"period": "W-3", "present": "87%", "absent": "13%"},
      {"period": "W-4", "present": "93%", "absent": "7%"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Student Attendance Trend",
      filterValue: _selectedStudentTrendFilter,
      filterOptions: const ["Weekly", "Monthly", "Term"],
      onFilterChanged: (v) => setState(() => _selectedStudentTrendFilter = v),
      isChartView: _showStudentTrendChart,
      onToggleView: () => setState(() => _showStudentTrendChart = !_showStudentTrendChart),
      child: _showStudentTrendChart
          ? _buildTrendBarChart()
          : _buildFigmaStyledTable(
              headers: const ["Period", "Present %", "Absent %"],
              rows: trendData.map((d) {
                return [d["period"].toString(), d["present"].toString(), d["absent"].toString()];
              }).toList(),
              badgeColumnIndex: 1,
              badgeType: BadgeType.green,
              secondBadgeColumnIndex: 2,
              secondBadgeType: BadgeType.red,
            ),
    );
  }

  Widget _buildTrendBarChart() {
    final List<double> values = [89.0, 91.0, 87.0, 93.0];
    final List<String> labels = ["W-1", "W-2", "W-3", "W-4"];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(labels[i], style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 28,
                  color: const Color(0xFF112461),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 3: Teacher Attendance
  // -------------------------------------------------------------
  Widget _buildTeacherAttendanceCard() {
    final List<Map<String, dynamic>> teacherData = [
      {"dept": "Junior Sec", "total": "28", "present": "26", "leave": "1", "absent": "1"},
      {"dept": "Middle", "total": "22", "present": "19", "leave": "2", "absent": "1"},
      {"dept": "Senior Sec", "total": "18", "present": "16", "leave": "1", "absent": "1"},
      {"dept": "O/A Lev", "total": "10", "present": "10", "leave": "0", "absent": "0"},
      {"dept": "Staff", "total": "8", "present": "7", "leave": "0", "absent": "1"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Teacher Attendance",
      filterValue: _selectedTeacherFilter,
      filterOptions: const ["Weekly", "Daily", "Monthly"],
      onFilterChanged: (v) => setState(() => _selectedTeacherFilter = v),
      isChartView: _showTeacherAttendanceChart,
      onToggleView: () => setState(() => _showTeacherAttendanceChart = !_showTeacherAttendanceChart),
      child: _showTeacherAttendanceChart
          ? _buildTeacherBarChart()
          : _buildFigmaStyledTable(
              headers: const ["Dept", "Total", "Present", "Leave", "Absent"],
              rows: teacherData.map((d) {
                return [
                  d["dept"].toString(),
                  d["total"].toString(),
                  d["present"].toString(),
                  d["leave"].toString(),
                  d["absent"].toString(),
                ];
              }).toList(),
            ),
    );
  }

  Widget _buildTeacherBarChart() {
    final List<double> vals = [92.0, 86.0, 88.0, 100.0, 87.0];
    final List<String> depts = ["Junior", "Middle", "Senior", "O/A", "Staff"];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < depts.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(depts[i], style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(vals.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: vals[i],
                  width: 24,
                  color: const Color(0xFF112461),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 4: Student Performance by Subject
  // -------------------------------------------------------------
  Widget _buildStudentPerformanceCard() {
    final List<Map<String, dynamic>> perfData = [
      {"subject": "Math", "students": "120", "pass": "108", "average": "78%", "rank": "#1"},
      {"subject": "Science", "students": "118", "pass": "104", "average": "82%", "rank": "#2"},
      {"subject": "English", "students": "120", "pass": "98", "average": "74%", "rank": "#3"},
      {"subject": "Urdu", "students": "115", "pass": "102", "average": "85%", "rank": "#4"},
      {"subject": "Isl", "students": "115", "pass": "105", "average": "76%", "rank": "#5"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Student Performance by Subject",
      filterValue: _selectedPerfFilter,
      filterOptions: const ["Monthly", "Midterm", "Final Term"],
      onFilterChanged: (v) => setState(() => _selectedPerfFilter = v),
      isChartView: _showPerformanceChart,
      onToggleView: () => setState(() => _showPerformanceChart = !_showPerformanceChart),
      child: _showPerformanceChart
          ? _buildPerfBarChart()
          : _buildFigmaStyledTable(
              headers: const ["Subject", "Students", "Pass", "Average", "Rank"],
              rows: perfData.map((d) {
                return [
                  d["subject"].toString(),
                  d["students"].toString(),
                  d["pass"].toString(),
                  d["average"].toString(),
                  d["rank"].toString(),
                ];
              }).toList(),
            ),
    );
  }

  Widget _buildPerfBarChart() {
    final List<double> vals = [78.0, 82.0, 74.0, 85.0, 76.0];
    final List<String> subjects = ["Math", "Science", "Eng", "Urdu", "Isl"];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < subjects.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(subjects[i], style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(vals.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: vals[i],
                  width: 24,
                  color: const Color(0xFF112461),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 5: Monthly Comparison
  // -------------------------------------------------------------
  Widget _buildMonthlyComparisonCard() {
    final List<Map<String, dynamic>> monthlyData = [
      {"period": "Jan", "this": "85%", "last": "78%", "change": "+7%"},
      {"period": "Feb", "this": "88%", "last": "80%", "change": "+8%"},
      {"period": "Mar", "this": "82%", "last": "79%", "change": "+3%"},
      {"period": "Apr", "this": "90%", "last": "84%", "change": "+6%"},
      {"period": "May", "this": "86%", "last": "81%", "change": "+5%"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Monthly Comparison",
      filterValue: _selectedMonthlyFilter,
      filterOptions: const ["Monthly", "Quarterly", "Annual"],
      onFilterChanged: (v) => setState(() => _selectedMonthlyFilter = v),
      isChartView: _showMonthlyComparisonChart,
      onToggleView: () => setState(() => _showMonthlyComparisonChart = !_showMonthlyComparisonChart),
      child: _showMonthlyComparisonChart
          ? _buildMonthlyBarChart()
          : Column(
              children: [
                _buildFigmaStyledTable(
                  headers: const ["Period", "This Month %", "Last Month %", "Change"],
                  rows: monthlyData.map((d) {
                    return [d["period"].toString(), d["this"].toString(), d["last"].toString(), d["change"].toString()];
                  }).toList(),
                  badgeColumnIndex: 1,
                  badgeType: BadgeType.amber,
                  secondBadgeColumnIndex: 2,
                  secondBadgeType: BadgeType.amberLight,
                  thirdBadgeColumnIndex: 3,
                  thirdBadgeType: BadgeType.red,
                ),
                const SizedBox(height: 10),
                _buildTablePagination(showing: "Showing 1-5 of 12"),
              ],
            ),
    );
  }

  Widget _buildMonthlyBarChart() {
    final List<double> vals = [85.0, 88.0, 82.0, 90.0, 86.0];
    final List<String> months = ["Jan", "Feb", "Mar", "Apr", "May"];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(months[i], style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(vals.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: vals[i],
                  width: 24,
                  color: const Color(0xFF112461),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 6: Term Comparison
  // -------------------------------------------------------------
  Widget _buildTermComparisonCard() {
    final List<Map<String, dynamic>> termTableData = [
      {"term": "Jan", "nur": "78%", "prep": "85%", "cl1": "72%", "cl2": "88%", "cl3": "70%"},
      {"term": "Feb", "nur": "75%", "prep": "82%", "cl1": "76%", "cl2": "86%", "cl3": "68%"},
      {"term": "Mar", "nur": "80%", "prep": "88%", "cl1": "82%", "cl2": "90%", "cl3": "74%"},
      {"term": "Apr", "nur": "76%", "prep": "84%", "cl1": "78%", "cl2": "84%", "cl3": "72%"},
      {"term": "May", "nur": "82%", "prep": "79%", "cl1": "80%", "cl2": "89%", "cl3": "78%"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Term Comparison",
      filterValue: _selectedTermFilter,
      filterOptions: const ["Monthly", "Quarterly", "Annual"],
      onFilterChanged: (v) => setState(() => _selectedTermFilter = v),
      isChartView: _showTermComparisonChart,
      onToggleView: () => setState(() => _showTermComparisonChart = !_showTermComparisonChart),
      child: _showTermComparisonChart
          ? _buildTermClusteredBarChart()
          : _buildFigmaStyledTable(
              headers: const ["Period", "NUR", "PREP", "CL-1", "CL-2", "CL-3"],
              rows: termTableData.map((d) {
                return [
                  d["term"].toString(),
                  d["nur"].toString(),
                  d["prep"].toString(),
                  d["cl1"].toString(),
                  d["cl2"].toString(),
                  d["cl3"].toString(),
                ];
              }).toList(),
              badgeColumnIndex: 1,
              badgeType: BadgeType.orange,
              secondBadgeColumnIndex: 2,
              secondBadgeType: BadgeType.red,
              thirdBadgeColumnIndex: 3,
              thirdBadgeType: BadgeType.amber,
              fourthBadgeColumnIndex: 4,
              fourthBadgeType: BadgeType.yellow,
              fifthBadgeColumnIndex: 5,
              fifthBadgeType: BadgeType.red,
            ),
    );
  }

  Widget _buildTermClusteredBarChart() {
    final List<List<double>> groupVals = [
      [78.0, 85.0, 72.0, 88.0, 70.0],
      [75.0, 82.0, 76.0, 86.0, 68.0],
      [80.0, 88.0, 82.0, 90.0, 74.0],
      [76.0, 84.0, 78.0, 84.0, 72.0],
    ];
    final List<String> labels = ["Term 1", "Term 2", "Term 3", "Annual"];
    final List<Color> colors = const [
      Color(0xFF112461),
      Color(0xFF22C55E),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
    ];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(labels[i], style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(groupVals.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: List.generate(groupVals[i].length, (j) {
                return BarChartRodData(
                  toY: groupVals[i][j],
                  width: 5,
                  color: colors[j],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 7: Leave Statistics
  // -------------------------------------------------------------
  Widget _buildLeaveStatisticsCard() {
    final List<Map<String, dynamic>> leaveTableData = [
      {"type": "Teaching", "pending": "3", "approved": "8", "rejected": "1", "total": "12"},
      {"type": "Non-Teaching", "pending": "1", "approved": "4", "rejected": "0", "total": "5"},
      {"type": "Students", "pending": "4", "approved": "12", "rejected": "2", "total": "18"},
    ];

    return _buildAnalyticsCardWrapper(
      title: "Leave Statistics",
      filterValue: _selectedLeaveFilter,
      filterOptions: const ["Monthly", "Yearly"],
      onFilterChanged: (v) => setState(() => _selectedLeaveFilter = v),
      isChartView: _showLeaveStatsChart,
      onToggleView: () => setState(() => _showLeaveStatsChart = !_showLeaveStatsChart),
      child: _showLeaveStatsChart
          ? _buildLeaveBarChart()
          : _buildFigmaStyledTable(
              headers: const ["Type", "Pending", "Approved", "Rejected", "Total"],
              rows: leaveTableData.map((d) {
                return [
                  d["type"].toString(),
                  d["pending"].toString(),
                  d["approved"].toString(),
                  d["rejected"].toString(),
                  d["total"].toString(),
                ];
              }).toList(),
            ),
    );
  }

  Widget _buildLeaveBarChart() {
    final List<double> vals = [12.0, 5.0, 18.0];
    final List<String> types = ["Teaching", "Non-Teaching", "Students"];

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 20,
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final int i = val.toInt();
                  if (i >= 0 && i < types.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(types[i], style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(vals.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: vals[i],
                  width: 32,
                  color: const Color(0xFF112461),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Card 8: Recent Activity Summary
  // -------------------------------------------------------------
  Widget _buildRecentActivitySummaryCard() {
    final List<Map<String, dynamic>> activityTableData = [
      {
        "icon": Icons.person_outline_rounded,
        "iconColor": const Color(0xFF2563EB),
        "title": "Attendance Marked",
        "detail": "Class 5-A marked - 08:15 AM",
        "status": null,
      },
      {
        "icon": Icons.school_outlined,
        "iconColor": const Color(0xFF16A34A),
        "title": "Midterm Result Uploaded",
        "detail": "Midterm 2026 - 120 Students",
        "status": "Submitted - 09:30 AM",
      },
      {
        "icon": Icons.calendar_month_outlined,
        "iconColor": const Color(0xFFD97706),
        "title": "Sports Gala Date",
        "detail": "Final Term 2026",
        "status": null,
      },
      {
        "icon": Icons.notifications_none_rounded,
        "iconColor": const Color(0xFFD97706),
        "title": "Fee Reminder",
        "detail": "Mr. Ali (02 students)",
        "status": null,
      },
      {
        "icon": Icons.celebration_outlined,
        "iconColor": const Color(0xFFE11D48),
        "title": "Sports Ceremony",
        "detail": "Sports Gala - 11:00 AM",
        "status": null,
      },
    ];

    return _buildAnalyticsCardWrapper(
      title: "Recent Activity Summary",
      filterValue: _selectedActivityFilter,
      filterOptions: const ["Daily", "Weekly"],
      onFilterChanged: (v) => setState(() => _selectedActivityFilter = v),
      isChartView: _showRecentActivityChart,
      onToggleView: () => setState(() => _showRecentActivityChart = !_showRecentActivityChart),
      child: Column(
        children: [
          _buildSearchField(
            controller: _activitySearchController,
            hint: "Search...",
          ),
          const SizedBox(height: 12),
          _buildActivityTable(activityTableData),
          const SizedBox(height: 10),
          _buildTablePagination(showing: "Showing 1-5 of 24"),
        ],
      ),
    );
  }

  Widget _buildActivityTable(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Dark Header
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF112461),
              child: const Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      "Activity",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Title",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Detail",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            // Rows
            ...data.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        item["icon"] as IconData,
                        color: item["iconColor"] as Color,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: Text(
                        item["title"] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: item["status"] != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4E6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item["status"] as String,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              item["detail"] as String,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Search Field Component
  // -------------------------------------------------------------
  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 16, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Custom Figma Styled Table
  // -------------------------------------------------------------
  Widget _buildFigmaStyledTable({
    required List<String> headers,
    required List<List<String>> rows,
    int? badgeColumnIndex,
    BadgeType? badgeType,
    int? secondBadgeColumnIndex,
    BadgeType? secondBadgeType,
    int? thirdBadgeColumnIndex,
    BadgeType? thirdBadgeType,
    int? fourthBadgeColumnIndex,
    BadgeType? fourthBadgeType,
    int? fifthBadgeColumnIndex,
    BadgeType? fifthBadgeType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Dark Header Row
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF112461),
              child: Row(
                children: headers.map((h) {
                  return Expanded(
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Data Rows
            ...rows.asMap().entries.map((entry) {
              final List<String> r = entry.value;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: r.asMap().entries.map((cellEntry) {
                    final int colIndex = cellEntry.key;
                    final String cellText = cellEntry.value;

                    // Badges support
                    if (badgeColumnIndex != null && colIndex == badgeColumnIndex && badgeType != null) {
                      return Expanded(
                        child: Center(
                          child: _buildBadge(cellText, badgeType),
                        ),
                      );
                    }
                    if (secondBadgeColumnIndex != null && colIndex == secondBadgeColumnIndex && secondBadgeType != null) {
                      return Expanded(
                        child: Center(
                          child: _buildBadge(cellText, secondBadgeType),
                        ),
                      );
                    }
                    if (thirdBadgeColumnIndex != null && colIndex == thirdBadgeColumnIndex && thirdBadgeType != null) {
                      return Expanded(
                        child: Center(
                          child: _buildBadge(cellText, thirdBadgeType),
                        ),
                      );
                    }
                    if (fourthBadgeColumnIndex != null && colIndex == fourthBadgeColumnIndex && fourthBadgeType != null) {
                      return Expanded(
                        child: Center(
                          child: _buildBadge(cellText, fourthBadgeType),
                        ),
                      );
                    }
                    if (fifthBadgeColumnIndex != null && colIndex == fifthBadgeColumnIndex && fifthBadgeType != null) {
                      return Expanded(
                        child: Center(
                          child: _buildBadge(cellText, fifthBadgeType),
                        ),
                      );
                    }

                    return Expanded(
                      child: Text(
                        cellText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, BadgeType type) {
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.green:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF16A34A);
        break;
      case BadgeType.red:
        bg = const Color(0xFFFFE4E6);
        fg = const Color(0xFFDC2626);
        break;
      case BadgeType.amber:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        break;
      case BadgeType.amberLight:
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFF59E0B);
        break;
      case BadgeType.orange:
        bg = const Color(0xFFFFEDD5);
        fg = const Color(0xFFEA580C);
        break;
      case BadgeType.yellow:
        bg = const Color(0xFFFEF9C3);
        fg = const Color(0xFFCA8A04);
        break;
      case BadgeType.blue:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF2563EB);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // Table Pagination Widget
  // -------------------------------------------------------------
  Widget _buildTablePagination({required String showing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          showing,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF9CA3AF),
          ),
        ),
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF112461),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // Export Reports Section
  // -------------------------------------------------------------
  Widget _buildExportReportsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                  title: "Export PDF",
                  icon: Icons.picture_as_pdf_outlined,
                  bgColor: const Color(0xFFEEF2FF),
                  textColor: const Color(0xFF112461),
                  iconColor: const Color(0xFF112461),
                  onTap: () => _handleExport("PDF"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildExportButton(
                  title: "Export Excel",
                  icon: Icons.table_chart_outlined,
                  bgColor: const Color(0xFFDCFCE7),
                  textColor: const Color(0xFF15803D),
                  iconColor: const Color(0xFF15803D),
                  onTap: () => _handleExport("Excel"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                  title: "Export CSV",
                  icon: Icons.description_outlined,
                  bgColor: const Color(0xFFE0F2FE),
                  textColor: const Color(0xFF0369A1),
                  iconColor: const Color(0xFF0369A1),
                  onTap: () => _handleExport("CSV"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildExportButton(
                  title: "Print Report",
                  icon: Icons.print_outlined,
                  bgColor: const Color(0xFFF3E8FF),
                  textColor: const Color(0xFF7E22CE),
                  iconColor: const Color(0xFF7E22CE),
                  onTap: () => _handleExport("Print"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: textColor.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleExport(String type) {
    Fluttertoast.showToast(
      msg: "$type export generated successfully!",
      backgroundColor: const Color(0xFF112461),
      textColor: Colors.white,
    );
  }

  // -------------------------------------------------------------
  // Reusable Card Wrapper with Top Header & Toggle
  // -------------------------------------------------------------
  Widget _buildAnalyticsCardWrapper({
    required String title,
    required String filterValue,
    required List<String> filterOptions,
    required ValueChanged<String> onFilterChanged,
    required bool isChartView,
    required VoidCallback onToggleView,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dropdown Filter Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filterOptions.contains(filterValue) ? filterValue : filterOptions.first,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF112461)),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF112461),
                    ),
                    items: filterOptions.map((opt) {
                      return DropdownMenuItem<String>(
                        value: opt,
                        child: Text(opt),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onFilterChanged(val);
                    },
                  ),
                ),
              ),
              // Toggle Chart / Table View Icons
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isChartView) onToggleView();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: !isChartView ? const Color(0xFF062998) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.grid_on_rounded,
                          size: 14,
                          color: !isChartView ? Colors.white : const Color(0xFF062998),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isChartView) onToggleView();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isChartView ? const Color(0xFF062998) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          size: 14,
                          color: isChartView ? Colors.white : const Color(0xFF062998),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

enum BadgeType {
  green,
  red,
  amber,
  amberLight,
  orange,
  yellow,
  blue,
}
