import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'attendance_monitoring_details_screen.dart';

class AttendanceMonitoringScreen extends StatefulWidget {
  const AttendanceMonitoringScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceMonitoringScreen> createState() =>
      _AttendanceMonitoringScreenState();
}

class _ClassAttendanceModel {
  final String id;
  final String className;
  final String sectionName;
  final String teacherName;
  final String teacherRole;
  final String initials;
  final DateTime date;
  final String? submittedTime;
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int leaveCount;
  final bool isSubmitted;

  _ClassAttendanceModel({
    required this.id,
    required this.className,
    required this.sectionName,
    required this.teacherName,
    required this.teacherRole,
    required this.initials,
    required this.date,
    this.submittedTime,
    required this.totalStudents,
    required this.presentCount,
    required this.absentCount,
    required this.leaveCount,
    required this.isSubmitted,
  });

  double get attendancePercentage {
    if (!isSubmitted || totalStudents == 0) return 0.0;
    return (presentCount / totalStudents) * 100;
  }
}

class _AttendanceMonitoringScreenState
    extends State<AttendanceMonitoringScreen> {
  DateTime _selectedDate = DateTime(2026, 1, 28);
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Applied Filter states
  String? _selectedTeacher;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedStatus;

  late List<_ClassAttendanceModel> _allClasses;

  final List<String> _teacherOptions = [
    'All Teachers',
    'Ms. Ayesha Khan',
    'Ms. Fatima Ahmed',
    'Ms. Farhana Malik',
    'Ms. Sana Mir',
    'Mr. Hassan Ali',
    'Mr. Noman Tariq',
    'Mr. Tariq Mehmood',
    'Ms. Zainab Hussain',
  ];

  final List<String> _classOptions = [
    'All Classes',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
  ];

  final List<String> _sectionOptions = [
    'All Sections',
    'Section A',
    'Section B',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Submitted',
    'Pending',
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _allClasses = [
      _ClassAttendanceModel(
        id: '1',
        className: 'Class 1',
        sectionName: 'Section A',
        teacherName: 'Ms. Ayesha Khan',
        teacherRole: 'Class Incharge',
        initials: '1A',
        date: _selectedDate,
        submittedTime: '08:15 AM',
        totalStudents: 30,
        presentCount: 26,
        absentCount: 2,
        leaveCount: 2,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '2',
        className: 'Class 1',
        sectionName: 'Section B',
        teacherName: 'Ms. Fatima Ahmed',
        teacherRole: 'Class Teacher',
        initials: '1B',
        date: _selectedDate,
        submittedTime: '08:30 AM',
        totalStudents: 33,
        presentCount: 26,
        absentCount: 3,
        leaveCount: 4,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '3',
        className: 'Class 2',
        sectionName: 'Section A',
        teacherName: 'Ms. Farhana Malik',
        teacherRole: 'Class Teacher',
        initials: '2A',
        date: _selectedDate,
        submittedTime: '08:32 AM',
        totalStudents: 36,
        presentCount: 27,
        absentCount: 6,
        leaveCount: 3,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '4',
        className: 'Class 2',
        sectionName: 'Section B',
        teacherName: 'Ms. Sana Mir',
        teacherRole: 'Class Teacher',
        initials: '2B',
        date: _selectedDate,
        submittedTime: null,
        totalStudents: 35,
        presentCount: 0,
        absentCount: 0,
        leaveCount: 0,
        isSubmitted: false,
      ),
      _ClassAttendanceModel(
        id: '5',
        className: 'Class 3',
        sectionName: 'Section A',
        teacherName: 'Mr. Hassan Ali',
        teacherRole: 'Class Teacher',
        initials: '3A',
        date: _selectedDate,
        submittedTime: '08:10 AM',
        totalStudents: 25,
        presentCount: 23,
        absentCount: 1,
        leaveCount: 1,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '6',
        className: 'Class 4',
        sectionName: 'Section A',
        teacherName: 'Mr. Noman Tariq',
        teacherRole: 'Class Teacher',
        initials: '4A',
        date: _selectedDate,
        submittedTime: '09:00 AM',
        totalStudents: 35,
        presentCount: 24,
        absentCount: 7,
        leaveCount: 4,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '7',
        className: 'Class 5',
        sectionName: 'Section A',
        teacherName: 'Mr. Tariq Mehmood',
        teacherRole: 'Class Teacher',
        initials: '5A',
        date: _selectedDate,
        submittedTime: '08:20 AM',
        totalStudents: 40,
        presentCount: 35,
        absentCount: 3,
        leaveCount: 2,
        isSubmitted: true,
      ),
      _ClassAttendanceModel(
        id: '8',
        className: 'Class 6',
        sectionName: 'Section A',
        teacherName: 'Ms. Zainab Hussain',
        teacherRole: 'Class Teacher',
        initials: '6A',
        date: _selectedDate,
        submittedTime: null,
        totalStudents: 38,
        presentCount: 0,
        absentCount: 0,
        leaveCount: 0,
        isSubmitted: false,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters =>
      (_selectedTeacher != null && _selectedTeacher != 'All Teachers') ||
      (_selectedClass != null && _selectedClass != 'All Classes') ||
      (_selectedSection != null && _selectedSection != 'All Sections') ||
      (_selectedStatus != null && _selectedStatus != 'All Status');

  List<_ClassAttendanceModel> get _filteredClasses {
    return _allClasses.where((c) {
      final matchesSearch =
          c.className.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.sectionName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.teacherName.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      // Teacher filter
      if (_selectedTeacher != null && _selectedTeacher != 'All Teachers') {
        if (!c.teacherName
            .toLowerCase()
            .contains(_selectedTeacher!.toLowerCase())) {
          return false;
        }
      }

      // Class filter
      if (_selectedClass != null && _selectedClass != 'All Classes') {
        if (c.className != _selectedClass) {
          return false;
        }
      }

      // Section filter
      if (_selectedSection != null && _selectedSection != 'All Sections') {
        if (c.sectionName != _selectedSection) {
          return false;
        }
      }

      // Status filter
      if (_selectedStatus != null && _selectedStatus != 'All Status') {
        if (_selectedStatus == 'Submitted' && !c.isSubmitted) return false;
        if (_selectedStatus == 'Pending' && c.isSubmitted) return false;
      }

      return true;
    }).toList();
  }

  int get _totalStudents =>
      _allClasses.fold(0, (sum, item) => sum + item.totalStudents);
  int get _totalPresent =>
      _allClasses.fold(0, (sum, item) => sum + item.presentCount);
  int get _totalAbsent =>
      _allClasses.fold(0, (sum, item) => sum + item.absentCount);
  int get _totalLeave =>
      _allClasses.fold(0, (sum, item) => sum + item.leaveCount);
  int get _submittedCount => _allClasses.where((c) => c.isSubmitted).length;

  double get _overallPercentage {
    final submittedStudents = _allClasses
        .where((c) => c.isSubmitted)
        .fold(0, (sum, item) => sum + item.totalStudents);
    if (submittedStudents == 0) return 0.0;
    return (_totalPresent / submittedStudents) * 100;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B2E78),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _initData();
      });
    }
  }

  // 🔹 Shows Filter Popup Dialog
  void _showFilterDialog(BuildContext context) {
    String? tempTeacher = _selectedTeacher;
    String? tempClass = _selectedClass;
    String? tempSection = _selectedSection;
    String? tempStatus = _selectedStatus;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filters",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2E78),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(dialogContext),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 2x2 Form Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          // Row 1: TEACHER & CLASS
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilterDropdownField(
                                  label: "TEACHER",
                                  value: tempTeacher,
                                  items: _teacherOptions,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      tempTeacher = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildFilterDropdownField(
                                  label: "CLASS",
                                  value: tempClass,
                                  items: _classOptions,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      tempClass = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Row 2: SECTION & STATUS
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilterDropdownField(
                                  label: "SECTION",
                                  value: tempSection,
                                  items: _sectionOptions,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      tempSection = val;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildFilterDropdownField(
                                  label: "STATUS",
                                  value: tempStatus,
                                  items: _statusOptions,
                                  onChanged: (val) {
                                    setDialogState(() {
                                      tempStatus = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons Row (Reset & Apply)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () {
                                setDialogState(() {
                                  tempTeacher = null;
                                  tempClass = null;
                                  tempSection = null;
                                  tempStatus = null;
                                });
                                setState(() {
                                  _selectedTeacher = null;
                                  _selectedClass = null;
                                  _selectedSection = null;
                                  _selectedStatus = null;
                                });
                                Navigator.pop(dialogContext);
                                Fluttertoast.showToast(msg: "Filters reset");
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1A1A2E),
                                side: const BorderSide(
                                    color: Color(0xFFE5E7EB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedTeacher = tempTeacher;
                                  _selectedClass = tempClass;
                                  _selectedSection = tempSection;
                                  _selectedStatus = tempStatus;
                                });
                                Navigator.pop(dialogContext);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B2E78),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedTeacher = null;
      _selectedClass = null;
      _selectedSection = null;
      _selectedStatus = null;
    });
    Fluttertoast.showToast(msg: "Filters reset");
  }

  void _showClassDetails(_ClassAttendanceModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceMonitoringDetailsScreen(
          className: item.className,
          sectionName: item.sectionName,
          teacherName: item.teacherName,
          employeeId: "TCH-00${item.id}",
          submissionTime: item.submittedTime ?? "8:45 AM",
          date: item.date,
          totalStudents: item.totalStudents,
          presentCount: item.presentCount > 0 ? item.presentCount : 28,
          absentCount: item.absentCount > 0 ? item.absentCount : 3,
          leaveCount: item.leaveCount > 0 ? item.leaveCount : 2,
        ),
      ),
    );
  }

  void _sendReminder(_ClassAttendanceModel item) {
    Fluttertoast.showToast(
      msg: "Reminder sent to ${item.teacherName} successfully!",
      backgroundColor: const Color(0xFF1B2E78),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MMM-yyyy');
    final formattedDate = dateFormat.format(_selectedDate);

    final submittedClasses = _filteredClasses;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FE),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top App Bar
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const Text(
                    "Attendance Monitoring",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Date Selector & Filters Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Date selector button
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2E78),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter button opening the Dialog popup
                      InkWell(
                        onTap: () => _showFilterDialog(context),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14),
                          decoration: BoxDecoration(
                            color: _hasActiveFilters
                                ? const Color(0xFF1B2E78)
                                : const Color(0xFF1B2E78),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Filters",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Search Input
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Search class or teacher name...",
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF9CA3AF),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 4 Top Summary Cards (Total, Present, Absent, Leave)
                    Row(
                      children: [
                        _buildSummaryCard(
                          title: "Total",
                          count: "$_totalStudents",
                          icon: Icons.people_outline,
                          bgColor: const Color(0xFFE8EDFF),
                          textColor: const Color(0xFF1B2E78),
                        ),
                        const SizedBox(width: 8),
                        _buildSummaryCard(
                          title: "Present",
                          count: "$_totalPresent",
                          icon: Icons.check_circle_outline,
                          bgColor: const Color(0xFFE8F8F3),
                          textColor: const Color(0xFF00A76F),
                        ),
                        const SizedBox(width: 8),
                        _buildSummaryCard(
                          title: "Absent",
                          count: "$_totalAbsent",
                          icon: Icons.cancel_outlined,
                          bgColor: const Color(0xFFFFEBEE),
                          textColor: const Color(0xFFE53935),
                        ),
                        const SizedBox(width: 8),
                        _buildSummaryCard(
                          title: "Leave",
                          count: "$_totalLeave",
                          icon: Icons.event_busy_outlined,
                          bgColor: const Color(0xFFFFF2ED),
                          textColor: const Color(0xFFFF6B35),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 🔹 School Attendance Rate Progress Card
                    _buildOverallProgressCard(),

                    const SizedBox(height: 20),

                    // 🔹 Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Classes (${submittedClasses.length})",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (_hasActiveFilters)
                          InkWell(
                            onTap: _resetFilters,
                            child: const Text(
                              "Clear filters",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B2E78),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 🔹 Class Cards List
                    if (submittedClasses.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 44,
                              color: Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "No classes found",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Try adjusting your search query or filter options.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: submittedClasses.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = submittedClasses[index];
                          return _buildClassCard(item);
                        },
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

  // 🔹 Dropdown Item inside Filter Popup Dialog
  Widget _buildFilterDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text(
                "",
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF6B7280),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 4-Card Summary Item Widget
  Widget _buildSummaryCard({
    required String title,
    required String count,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
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

  // 🔹 School Attendance Progress Card
  Widget _buildOverallProgressCard() {
    final presentPct = _totalStudents > 0
        ? (_totalPresent / _totalStudents) * 100
        : 0.0;
    final leavePct = _totalStudents > 0
        ? (_totalLeave / _totalStudents) * 100
        : 0.0;
    final absentPct = _totalStudents > 0
        ? (_totalAbsent / _totalStudents) * 100
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "School Overall Attendance",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                "${_overallPercentage.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2E78),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Multi-color segmented progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: (_totalPresent > 0 ? _totalPresent : 1),
                    child: Container(color: const Color(0xFF00A76F)),
                  ),
                  Expanded(
                    flex: (_totalLeave > 0 ? _totalLeave : 1),
                    child: Container(color: const Color(0xFFFF6B35)),
                  ),
                  Expanded(
                    flex: (_totalAbsent > 0 ? _totalAbsent : 1),
                    child: Container(color: const Color(0xFFE53935)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendDot(
                color: const Color(0xFF00A76F),
                label: "Present",
                pct: "${presentPct.toStringAsFixed(1)}%",
              ),
              _buildLegendDot(
                color: const Color(0xFFFF6B35),
                label: "Leave",
                pct: "${leavePct.toStringAsFixed(1)}%",
              ),
              _buildLegendDot(
                color: const Color(0xFFE53935),
                label: "Absent",
                pct: "${absentPct.toStringAsFixed(1)}%",
              ),
              Text(
                "Submitted: $_submittedCount/${_allClasses.length}",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot({
    required Color color,
    required String label,
    required String pct,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "$label $pct",
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // 🔹 Class Attendance Card
  Widget _buildClassCard(_ClassAttendanceModel item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSubmitted
              ? const Color(0xFFE5E7EB)
              : const Color(0xFFFFCDD2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Names, Percentage and Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B2E78),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Class & Teacher info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.className} — ${item.sectionName}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${item.teacherName} • ${item.teacherRole}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              // Percentage & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.isSubmitted
                        ? "${item.attendancePercentage.toStringAsFixed(0)}%"
                        : "--",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: item.isSubmitted
                          ? (item.attendancePercentage >= 80
                              ? const Color(0xFF00A76F)
                              : const Color(0xFFFF6B35))
                          : const Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.isSubmitted
                          ? const Color(0xFFE8F8F3)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.isSubmitted ? "✓ Submitted" : "⏳ Pending",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: item.isSubmitted
                            ? const Color(0xFF00A76F)
                            : const Color(0xFFE53935),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Metadata Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaColumn(
                  "DATE",
                  DateFormat('dd-MMM-yyyy').format(item.date),
                  const Color(0xFF1A1A2E),
                ),
                _buildMetaColumn(
                  "SUBMITTED",
                  item.submittedTime ?? "Not Submitted",
                  item.isSubmitted
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFE53935),
                ),
                _buildMetaColumn(
                  "TOTAL",
                  "${item.totalStudents}",
                  const Color(0xFF1A1A2E),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Content based on Submitted vs Pending
          if (item.isSubmitted) ...[
            // 3 Count Boxes
            Row(
              children: [
                _buildClassStatBox(
                  "${item.presentCount}",
                  "Present",
                  const Color(0xFFE8F8F3),
                  const Color(0xFF00A76F),
                ),
                const SizedBox(width: 8),
                _buildClassStatBox(
                  "${item.absentCount}",
                  "Absent",
                  const Color(0xFFFFEBEE),
                  const Color(0xFFE53935),
                ),
                const SizedBox(width: 8),
                _buildClassStatBox(
                  "${item.leaveCount}",
                  "Leave",
                  const Color(0xFFFFF2ED),
                  const Color(0xFFFF6B35),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // View Details Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () => _showClassDetails(item),
                icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                label: const Text(
                  "View Details",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8EDFF),
                  foregroundColor: const Color(0xFF1B2E78),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Warning Alert for Pending Attendance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Color(0xFFD32F2F),
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Attendance not submitted yet",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Two Action Buttons: View Details and Remind
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => _showClassDetails(item),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                      label: const Text(
                        "View Details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8EDFF),
                        foregroundColor: const Color(0xFF1B2E78),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => _sendReminder(item),
                      icon: const Icon(Icons.notifications_active_outlined,
                          size: 16),
                      label: const Text(
                        "Remind",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF2ED),
                        foregroundColor: const Color(0xFFE53935),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaColumn(String label, String value, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: valColor,
          ),
        ),
      ],
    );
  }

  Widget _buildClassStatBox(
      String count, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
