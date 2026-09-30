import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentAttendanceRecord {
  final String rollNo;
  final String name;
  final String status; // 'Present', 'Absent', 'Leave'

  const StudentAttendanceRecord({
    required this.rollNo,
    required this.name,
    required this.status,
  });
}

class AttendanceMonitoringDetailsScreen extends StatefulWidget {
  final String className;
  final String sectionName;
  final String teacherName;
  final String employeeId;
  final String submissionTime;
  final DateTime date;
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int leaveCount;

  const AttendanceMonitoringDetailsScreen({
    Key? key,
    this.className = "Class 1",
    this.sectionName = "Section A",
    this.teacherName = "Ms. Ayesha Khalid",
    this.employeeId = "TCH-001",
    this.submissionTime = "8:45 AM",
    DateTime? date,
    this.totalStudents = 33,
    this.presentCount = 28,
    this.absentCount = 3,
    this.leaveCount = 2,
  })  : date = date ?? const _DefaultDate(),
        super(key: key);

  @override
  State<AttendanceMonitoringDetailsScreen> createState() =>
      _AttendanceMonitoringDetailsScreenState();
}

class _DefaultDate implements DateTime {
  const _DefaultDate();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      DateTime(2025, 6, 29);
}

class _AttendanceMonitoringDetailsScreenState
    extends State<AttendanceMonitoringDetailsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Present', 'Absent', 'Leave'

  late final List<StudentAttendanceRecord> _students;

  @override
  void initState() {
    super.initState();
    _initStudents();
  }

  void _initStudents() {
    // Generate realistic student list based on design
    final sampleNames = [
      "Ali Akkbar",
      "Hassaan Asim",
      "Abdullah Nawaz",
      "Mubshir Nadem",
      "Ali Akkbar",
      "Hassaan Asim",
      "Abdullah Nawaz",
      "Mubshir Nadem",
      "Ali Akkbar",
      "Hassaan Asim",
      "Abdullah Nawaz",
      "Mubshir Nadem",
      "Zain Ul Abideen",
      "Usman Tariq",
      "Hamza Javed",
      "Bilal Ahmed",
      "Ayaan Sheikh",
      "Mustafa Kamal",
      "Saad Rafique",
      "Omer Farooq",
      "Ibrahim Qureshi",
      "Daniyal Malik",
      "Ahmed Raza",
      "Faizan Ali",
      "Haris Rauf",
      "Zubair Khan",
      "Taha Siddiqui",
      "Rehan Butt",
      "Shahid Afridi",
      "Babar Azam",
      "Shaheen Shah",
      "Naseem Shah",
      "Mohammad Rizwan",
    ];

    _students = List.generate(widget.totalStudents, (index) {
      final rollStr = (index + 1).toString().padLeft(2, '0');
      final name = index < sampleNames.length
          ? sampleNames[index]
          : "Student ${index + 1}";

      // Specific sample pattern matching the design:
      // index 0: Present (Ali Akkbar)
      // index 1: Absent (Hassaan Asim)
      // index 2: Present (Abdullah Nawaz)
      // index 3: Absent (Mubshir Nadem)
      // index 4: Present (Ali Akkbar)
      // index 5: Absent (Hassaan Asim)
      // index 6: Present (Abdullah Nawaz)
      // index 7: Absent (Mubshir Nadem)
      // index 8: Present (Ali Akkbar)
      // index 9: Absent (Hassaan Asim)
      // index 10: Present (Abdullah Nawaz)
      // index 11: Absent (Mubshir Nadem)
      String status = 'Present';
      if (index == 1 || index == 3 || index == 5 || index == 7 || index == 9 || index == 11) {
        status = 'Absent';
      } else if (index == 12 || index == 13) {
        status = 'Leave';
      } else {
        status = 'Present';
      }

      return StudentAttendanceRecord(
        rollNo: rollStr,
        name: name,
        status: status,
      );
    });
  }

  List<StudentAttendanceRecord> get _filteredStudents {
    if (_selectedFilter == 'All') return _students;
    return _students.where((s) => s.status == _selectedFilter).toList();
  }

  String get _initials {
    final parts = widget.teacherName.split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return "MA";
  }

  double get _attendanceRate {
    if (widget.totalStudents == 0) return 0;
    return (widget.presentCount / widget.totalStudents) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(
      widget.date is _DefaultDate ? DateTime(2025, 6, 29) : widget.date,
    );

    final sectionShort = widget.sectionName.replaceAll('Section ', 'Sec ');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FE),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top Bar with Back Button & Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "${widget.className} — ${widget.sectionName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Main Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Teacher & Class Overview Card (Light Blue Container)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEFB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Header: Avatar, Teacher Info & Submission Time
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B2E78),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.teacherName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1B2E78),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Employee ID: ${widget.employeeId}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Submission",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.submissionTime,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00A76F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 2x2 Info Grid
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoTile("Date", formattedDate),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInfoTile(
                                    "Submission", widget.submissionTime),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoTile(
                                  "Class",
                                  "${widget.className} — $sectionShort",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInfoTile(
                                  "Total",
                                  "${widget.totalStudents} students",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 3 Metric Cards (Present, Absent, Leave)
                    Row(
                      children: [
                        _buildMetricPill(
                          count: "${widget.presentCount}",
                          label: "Present",
                          icon: Icons.check_box,
                          iconColor: const Color(0xFF00A76F),
                          bgColor: const Color(0xFFE8F8F3),
                          textColor: const Color(0xFF00A76F),
                        ),
                        const SizedBox(width: 10),
                        _buildMetricPill(
                          count: "${widget.absentCount}",
                          label: "Absent",
                          icon: Icons.cancel,
                          iconColor: const Color(0xFFE53935),
                          bgColor: const Color(0xFFFFEBEE),
                          textColor: const Color(0xFFE53935),
                        ),
                        const SizedBox(width: 10),
                        _buildMetricPill(
                          count: "${widget.leaveCount}",
                          label: "Leave",
                          icon: Icons.assignment_outlined,
                          iconColor: const Color(0xFFFF6B35),
                          bgColor: const Color(0xFFFFF2ED),
                          textColor: const Color(0xFFFF6B35),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Attendance Rate Progress Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Attendance Rate",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                              Text(
                                "${_attendanceRate.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1B2E78),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _attendanceRate / 100,
                              minHeight: 7,
                              backgroundColor: const Color(0xFFE5E7EB),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF1B2E78),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Filter Tabs (All, Present, Absent, Leave)
                    Row(
                      children: [
                        _buildFilterTab("All"),
                        const SizedBox(width: 8),
                        _buildFilterTab("Present"),
                        const SizedBox(width: 8),
                        _buildFilterTab("Absent"),
                        const SizedBox(width: 8),
                        _buildFilterTab("Leave"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Student List Card with Table Header & Rows
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Navy Blue Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B2E78),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    "Student List",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      "Absent",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      "Present",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Student Rows List
                          if (_filteredStudents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.person_search_outlined,
                                    size: 40,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "No $_selectedFilter students",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredStudents.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF3F4F6),
                              ),
                              itemBuilder: (context, index) {
                                final student = _filteredStudents[index];
                                final isPresent = student.status == 'Present';
                                final isAbsent = student.status == 'Absent';

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  child: Row(
                                    children: [
                                      // Roll Number
                                      SizedBox(
                                        width: 28,
                                        child: Text(
                                          student.rollNo,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B2E78),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Student Name
                                      Expanded(
                                        child: Text(
                                          student.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937),
                                          ),
                                        ),
                                      ),
                                      // Absent Check Circle
                                      SizedBox(
                                        width: 60,
                                        child: Center(
                                          child: _buildAttendanceIndicator(
                                            isSelected: isAbsent,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Present Check Circle
                                      SizedBox(
                                        width: 60,
                                        child: Center(
                                          child: _buildAttendanceIndicator(
                                            isSelected: isPresent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Circular Checkmark Indicator
  Widget _buildAttendanceIndicator({required bool isSelected}) {
    if (isSelected) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: Color(0xFF1B2E78),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          size: 14,
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF9CA3AF),
          width: 1.5,
        ),
      ),
    );
  }

  // 🔹 White Tile inside Overview Card
  Widget _buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Metric Pills (Present, Absent, Leave)
  Widget _buildMetricPill({
    required String count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Segmented Filter Tab Button
  Widget _buildFilterTab(String title) {
    final isSelected = _selectedFilter == title;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = title;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B2E78) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1B2E78)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
