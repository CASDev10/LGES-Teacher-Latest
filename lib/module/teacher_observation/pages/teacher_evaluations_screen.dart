import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// 🔹 Class-wise Evaluation Model
class ClassEvaluationItem {
  final String id;
  final String teacherName;
  final String teacherCode;
  final String className;
  final String sectionName;
  final String initials;
  final int scorePercentage;
  final String status;
  final DateTime date;

  ClassEvaluationItem({
    required this.id,
    required this.teacherName,
    required this.teacherCode,
    required this.className,
    required this.sectionName,
    required this.initials,
    required this.scorePercentage,
    required this.status,
    required this.date,
  });
}

// 🔹 Student-wise Evaluation Model
class StudentEvaluationItem {
  final String id;
  final String studentName;
  final String initials;
  final String className;
  final String sectionName;
  final String subject;
  final String remark;
  final String grade;
  final int scorePercentage;
  final String status;
  final DateTime date;

  StudentEvaluationItem({
    required this.id,
    required this.studentName,
    required this.initials,
    required this.className,
    required this.sectionName,
    required this.subject,
    required this.remark,
    required this.grade,
    required this.scorePercentage,
    required this.status,
    required this.date,
  });

  String get subtitle => "$className-$sectionName · $subject · $remark";
}

class TeacherEvaluationsScreen extends StatefulWidget {
  const TeacherEvaluationsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherEvaluationsScreen> createState() =>
      _TeacherEvaluationsScreenState();
}

class _TeacherEvaluationsScreenState extends State<TeacherEvaluationsScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTab = 'Class-wise'; // 'Overview', 'Class-wise', 'Student-wise'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter dropdown selections
  String? _selectedTeacher;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedStatus;

  // Filter dropdown options
  final List<String> _teacherOptions = [
    'All Teachers',
    'Mr. Bilal Ahmed',
    'Ms. Ayesha Khan',
    'Ms. Fatima Ahmed',
    'Mr. Hassan Ali',
    'Mr. Noman Tariq',
  ];

  final List<String> _classOptions = [
    'All Classes',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
  ];

  final List<String> _sectionOptions = [
    'All Sections',
    'Section A',
    'Section B',
    'Section C',
  ];

  final List<String> _statusOptions = [
    'All Status',
    'Completed',
    'Pending',
    'In Progress',
  ];

  late List<ClassEvaluationItem> _classEvaluations;
  late List<StudentEvaluationItem> _studentEvaluations;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _classEvaluations = [
      ClassEvaluationItem(
        id: '1',
        teacherName: 'Mr. Bilal Ahmed',
        teacherCode: 'TCH-002',
        className: 'Class 1',
        sectionName: 'Section B',
        initials: 'MB',
        scorePercentage: 75,
        status: 'Completed',
        date: DateTime.now(),
      ),
      ClassEvaluationItem(
        id: '2',
        teacherName: 'Mr. Bilal Ahmed',
        teacherCode: 'TCH-002',
        className: 'Class 1',
        sectionName: 'Section B',
        initials: 'MB',
        scorePercentage: 75,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ClassEvaluationItem(
        id: '3',
        teacherName: 'Mr. Bilal Ahmed',
        teacherCode: 'TCH-002',
        className: 'Class 1',
        sectionName: 'Section B',
        initials: 'MB',
        scorePercentage: 75,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ClassEvaluationItem(
        id: '4',
        teacherName: 'Mr. Bilal Ahmed',
        teacherCode: 'TCH-002',
        className: 'Class 1',
        sectionName: 'Section B',
        initials: 'MB',
        scorePercentage: 75,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    _studentEvaluations = [
      StudentEvaluationItem(
        id: '1',
        studentName: 'Ahmad Ali',
        initials: 'AA',
        className: 'Class 5',
        sectionName: 'A',
        subject: 'Mathematics',
        remark: 'Excellent',
        grade: 'A+',
        scorePercentage: 95,
        status: 'Completed',
        date: DateTime.now(),
      ),
      StudentEvaluationItem(
        id: '2',
        studentName: 'Fatima Malik',
        initials: 'FM',
        className: 'Class 5',
        sectionName: 'B',
        subject: 'English',
        remark: 'Very Good',
        grade: 'A',
        scorePercentage: 88,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      StudentEvaluationItem(
        id: '3',
        studentName: 'Bilal Hassan',
        initials: 'BH',
        className: 'Class 5',
        sectionName: 'A',
        subject: 'Science',
        remark: 'Good',
        grade: 'B+',
        scorePercentage: 79,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      StudentEvaluationItem(
        id: '4',
        studentName: 'Hira Baig',
        initials: 'HB',
        className: 'Class 5',
        sectionName: 'A',
        subject: 'Urdu',
        remark: 'Excellent',
        grade: 'A',
        scorePercentage: 90,
        status: 'Completed',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClassEvaluationItem> get _filteredClassEvaluations {
    return _classEvaluations.where((item) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTeacher = item.teacherName.toLowerCase().contains(query);
        final matchesClass = item.className.toLowerCase().contains(query);
        final matchesSection = item.sectionName.toLowerCase().contains(query);
        final matchesCode = item.teacherCode.toLowerCase().contains(query);

        if (!matchesTeacher && !matchesClass && !matchesSection && !matchesCode) {
          return false;
        }
      }

      if (_selectedTeacher != null &&
          _selectedTeacher != 'All Teachers' &&
          !item.teacherName.toLowerCase().contains(_selectedTeacher!.toLowerCase())) {
        return false;
      }

      if (_selectedClass != null &&
          _selectedClass != 'All Classes' &&
          item.className != _selectedClass) {
        return false;
      }

      if (_selectedSection != null &&
          _selectedSection != 'All Sections' &&
          item.sectionName != _selectedSection) {
        return false;
      }

      if (_selectedStatus != null &&
          _selectedStatus != 'All Status' &&
          item.status != _selectedStatus) {
        return false;
      }

      return true;
    }).toList();
  }

  List<StudentEvaluationItem> get _filteredStudentEvaluations {
    return _studentEvaluations.where((item) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesStudent = item.studentName.toLowerCase().contains(query);
        final matchesClass = item.className.toLowerCase().contains(query);
        final matchesSection = item.sectionName.toLowerCase().contains(query);
        final matchesSubject = item.subject.toLowerCase().contains(query);
        final matchesRemark = item.remark.toLowerCase().contains(query);

        if (!matchesStudent &&
            !matchesClass &&
            !matchesSection &&
            !matchesSubject &&
            !matchesRemark) {
          return false;
        }
      }

      if (_selectedClass != null &&
          _selectedClass != 'All Classes' &&
          item.className != _selectedClass) {
        return false;
      }

      if (_selectedSection != null &&
          _selectedSection != 'All Sections' &&
          "Section ${item.sectionName}" != _selectedSection &&
          item.sectionName != _selectedSection) {
        return false;
      }

      if (_selectedStatus != null &&
          _selectedStatus != 'All Status' &&
          item.status != _selectedStatus) {
        return false;
      }

      return true;
    }).toList();
  }

  int get _currentCount {
    if (_selectedTab == 'Student-wise') {
      return _filteredStudentEvaluations.length;
    }
    return _filteredClassEvaluations.length;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedTeacher = null;
      _selectedClass = null;
      _selectedSection = null;
      _selectedStatus = null;
      _searchController.clear();
      _searchQuery = '';
    });
    Fluttertoast.showToast(msg: "Filters reset successfully");
  }

  void _applyFilters() {
    setState(() {});
    Fluttertoast.showToast(msg: "Filters applied");
  }

  void _showAddDialog() {
    if (_selectedTab == 'Student-wise') {
      _showAddStudentEvaluationDialog();
    } else {
      _showAddClassEvaluationDialog();
    }
  }

  void _showAddClassEvaluationDialog() {
    final TextEditingController teacherNameController = TextEditingController();
    final TextEditingController codeController =
        TextEditingController(text: "TCH-00${_classEvaluations.length + 1}");
    String selectedClass = 'Class 1';
    String selectedSection = 'Section B';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add Class Evaluation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E78),
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Teacher Name",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: teacherNameController,
                  decoration: InputDecoration(
                    hintText: "Enter teacher name (e.g. Mr. Bilal Ahmed)",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                const Text("Class",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: selectedClass,
                  items: _classOptions
                      .where((e) => e != 'All Classes')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedClass = val!),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 14),
                const Text("Section",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: selectedSection,
                  items: _sectionOptions
                      .where((e) => e != 'All Sections')
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedSection = val!),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = teacherNameController.text.trim();
                if (name.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter teacher name");
                  return;
                }
                final initials = name
                    .split(' ')
                    .where((part) => part.isNotEmpty)
                    .take(2)
                    .map((p) => p[0].toUpperCase())
                    .join();

                setState(() {
                  _classEvaluations.insert(
                    0,
                    ClassEvaluationItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      teacherName: name,
                      teacherCode: codeController.text.trim(),
                      className: selectedClass,
                      sectionName: selectedSection,
                      initials: initials.isNotEmpty ? initials : "TH",
                      scorePercentage: 75,
                      status: 'Completed',
                      date: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                Fluttertoast.showToast(msg: "Evaluation added successfully!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2E78),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStudentEvaluationDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController subjectCtrl =
        TextEditingController(text: "Mathematics");
    final TextEditingController remarkCtrl =
        TextEditingController(text: "Excellent");
    final TextEditingController gradeCtrl = TextEditingController(text: "A+");
    final TextEditingController scoreCtrl = TextEditingController(text: "95");
    String selectedClass = 'Class 5';
    String selectedSection = 'A';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "Add Student Evaluation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E78),
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Student Name",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: "e.g. Ahmad Ali",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Class",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: selectedClass,
                            items: _classOptions
                                .where((e) => e != 'All Classes')
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) =>
                                setDialogState(() => selectedClass = val!),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Section",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: selectedSection,
                            items: ['A', 'B', 'C']
                                .map((s) => DropdownMenuItem(
                                    value: s, child: Text("Section $s")))
                                .toList(),
                            onChanged: (val) =>
                                setDialogState(() => selectedSection = val!),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text("Subject",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: subjectCtrl,
                  decoration: InputDecoration(
                    hintText: "e.g. Mathematics",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("Remark",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: remarkCtrl,
                  decoration: InputDecoration(
                    hintText: "e.g. Excellent / Good",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Grade",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: gradeCtrl,
                            decoration: InputDecoration(
                              hintText: "A+",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Score (%)",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: scoreCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "95",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter student name");
                  return;
                }
                final initials = name
                    .split(' ')
                    .where((part) => part.isNotEmpty)
                    .take(2)
                    .map((p) => p[0].toUpperCase())
                    .join();

                final score = int.tryParse(scoreCtrl.text.trim()) ?? 90;

                setState(() {
                  _studentEvaluations.insert(
                    0,
                    StudentEvaluationItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      studentName: name,
                      initials: initials.isNotEmpty ? initials : "ST",
                      className: selectedClass,
                      sectionName: selectedSection,
                      subject: subjectCtrl.text.trim(),
                      remark: remarkCtrl.text.trim(),
                      grade: gradeCtrl.text.trim(),
                      scorePercentage: score,
                      status: 'Completed',
                      date: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                Fluttertoast.showToast(msg: "Student evaluation added!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2E78),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 View Details for Student
  void _onViewStudentEvaluation(StudentEvaluationItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF1B2E78),
                  child: Text(
                    item.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.studentName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.grade,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B2E78),
                      ),
                    ),
                    Text(
                      "${item.scorePercentage}%",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow("Class & Section", "${item.className} - Section ${item.sectionName}"),
            const SizedBox(height: 10),
            _buildDetailRow("Subject", item.subject),
            const SizedBox(height: 10),
            _buildDetailRow("Performance Remark", item.remark),
            const SizedBox(height: 10),
            _buildDetailRow("Evaluation Date", DateFormat('dd MMM yyyy').format(item.date)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2E78),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Close",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Edit Student
  void _onEditStudentEvaluation(StudentEvaluationItem item) {
    final TextEditingController nameCtrl =
        TextEditingController(text: item.studentName);
    final TextEditingController subjectCtrl =
        TextEditingController(text: item.subject);
    final TextEditingController remarkCtrl =
        TextEditingController(text: item.remark);
    final TextEditingController gradeCtrl =
        TextEditingController(text: item.grade);
    final TextEditingController scoreCtrl =
        TextEditingController(text: item.scorePercentage.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Student Evaluation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2E78),
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Student Name",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Subject",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: subjectCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Remark",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: remarkCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Grade",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: gradeCtrl,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Score (%)",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: scoreCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newScore =
                  int.tryParse(scoreCtrl.text.trim()) ?? item.scorePercentage;
              setState(() {
                final idx =
                    _studentEvaluations.indexWhere((e) => e.id == item.id);
                if (idx != -1) {
                  _studentEvaluations[idx] = StudentEvaluationItem(
                    id: item.id,
                    studentName: nameCtrl.text.trim(),
                    initials: item.initials,
                    className: item.className,
                    sectionName: item.sectionName,
                    subject: subjectCtrl.text.trim(),
                    remark: remarkCtrl.text.trim(),
                    grade: gradeCtrl.text.trim(),
                    scorePercentage: newScore,
                    status: item.status,
                    date: item.date,
                  );
                }
              });
              Navigator.pop(ctx);
              Fluttertoast.showToast(msg: "Student evaluation updated");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2E78),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🔹 Delete Student
  void _onDeleteStudentEvaluation(StudentEvaluationItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Evaluation?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            fontSize: 18,
          ),
        ),
        content: Text(
          "Are you sure you want to delete evaluation for ${item.studentName} (${item.subtitle})?",
          style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _studentEvaluations.removeWhere((e) => e.id == item.id);
              });
              Navigator.pop(ctx);
              Fluttertoast.showToast(msg: "Evaluation deleted");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🔹 View Details for Class
  void _onViewClassEvaluation(ClassEvaluationItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF1B2E78),
                  child: Text(
                    item.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.className} — ${item.sectionName}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.teacherName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        item.teacherCode,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${item.scorePercentage}%",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF5C38),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow("Evaluation Date",
                DateFormat('dd MMM yyyy').format(item.date)),
            const SizedBox(height: 10),
            _buildDetailRow("Evaluation Status", item.status),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2E78),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Close",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E))),
      ],
    );
  }

  // 🔹 Edit Class
  void _onEditClassEvaluation(ClassEvaluationItem item) {
    final TextEditingController nameCtrl =
        TextEditingController(text: item.teacherName);
    final TextEditingController scoreCtrl =
        TextEditingController(text: item.scorePercentage.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Evaluation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2E78),
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Teacher Name",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 14),
            const Text("Score Percentage (%)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: scoreCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final newScore =
                  int.tryParse(scoreCtrl.text.trim()) ?? item.scorePercentage;
              setState(() {
                final idx =
                    _classEvaluations.indexWhere((e) => e.id == item.id);
                if (idx != -1) {
                  _classEvaluations[idx] = ClassEvaluationItem(
                    id: item.id,
                    teacherName: nameCtrl.text.trim(),
                    teacherCode: item.teacherCode,
                    className: item.className,
                    sectionName: item.sectionName,
                    initials: item.initials,
                    scorePercentage: newScore,
                    status: item.status,
                    date: item.date,
                  );
                }
              });
              Navigator.pop(ctx);
              Fluttertoast.showToast(msg: "Evaluation updated successfully");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2E78),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🔹 Delete Class
  void _onDeleteClassEvaluation(ClassEvaluationItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Evaluation?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            fontSize: 18,
          ),
        ),
        content: Text(
          "Are you sure you want to delete evaluation for ${item.teacherName} (${item.className} - ${item.sectionName})?",
          style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _classEvaluations.removeWhere((e) => e.id == item.id);
              });
              Navigator.pop(ctx);
              Fluttertoast.showToast(msg: "Evaluation deleted");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _currentCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top App Bar Area
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Text(
                    _selectedTab == 'Student-wise'
                        ? "Evaluations"
                        : "Evaluations ($count)",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  // + Add Button
                  InkWell(
                    onTap: _showAddDialog,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2E78),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Top Header Filters Row & Expandable Container
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  // Date Picker & Filter Action Bar
                  Row(
                    children: [
                      // Date Selector Button
                      Expanded(
                        child: InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2E78),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filters Button
                      InkWell(
                        onTap: () {
                          Fluttertoast.showToast(msg: "Use filters below");
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2E78),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Filters",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 🔹 2x2 Filter Form Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Row 1: TEACHER & CLASS
                        Row(
                          children: [
                            Expanded(
                              child: _buildFilterDropdownField(
                                label: "TEACHER",
                                value: _selectedTeacher,
                                items: _teacherOptions,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedTeacher = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterDropdownField(
                                label: "CLASS",
                                value: _selectedClass,
                                items: _classOptions,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedClass = val;
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
                                value: _selectedSection,
                                items: _sectionOptions,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedSection = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildFilterDropdownField(
                                label: "STATUS",
                                value: _selectedStatus,
                                items: _statusOptions,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedStatus = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Row 3: Reset & Apply Buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: OutlinedButton(
                                  onPressed: _resetFilters,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
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
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: _applyFilters,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B2E78),
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
                                      color: Colors.white,
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

                  const SizedBox(height: 12),

                  // 🔹 Search Input Field
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔹 Tabs Segmented Pills (Overview, Class-wise, Student-wise)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPillTab("Overview"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPillTab("Class-wise"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPillTab("Student-wise"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Scrollable Evaluations List
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub-heading
                    Text(
                      "Evaluations ($count)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_selectedTab == 'Student-wise')
                      _buildStudentList()
                    else
                      _buildClassList(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Student List Renderer
  Widget _buildStudentList() {
    final list = _filteredStudentEvaluations;
    if (list.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildStudentEvaluationCard(item);
      },
    );
  }

  // 🔹 Class List Renderer
  Widget _buildClassList() {
    final list = _filteredClassEvaluations;
    if (list.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildClassEvaluationCard(item);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 54,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              "No evaluations found",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Dropdown Filter Widget
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
            color: Color(0xFF6B7280),
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
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              items: items.map((String opt) {
                return DropdownMenuItem<String>(
                  value: opt,
                  child: Text(
                    opt,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A1A2E),
                    ),
                    overflow: TextOverflow.ellipsis,
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

  // 🔹 Pill Tab Widget
  Widget _buildPillTab(String title) {
    final isSelected = _selectedTab == title;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B2E78) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B2E78) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  // 🔹 Student Evaluation Card (as shown in student-wise image)
  Widget _buildStudentEvaluationCard(StudentEvaluationItem item) {
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
        children: [
          // Top Row: Avatar + Name + Subtitle + Grade/Score
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Navy Initials Avatar
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B2E78),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Student Name & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.studentName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Grade and Percentage Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.grade,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B2E78),
                    ),
                  ),
                  Text(
                    "${item.scorePercentage}%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),

          // Action Buttons: View, Edit, Delete
          Row(
            children: [
              // View
              Expanded(
                child: InkWell(
                  onTap: () => _onViewStudentEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: Color(0xFF1B2E78),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "View",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B2E78),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Edit
              Expanded(
                child: InkWell(
                  onTap: () => _onEditStudentEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Delete
              Expanded(
                child: InkWell(
                  onTap: () => _onDeleteStudentEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Color(0xFFEF4444),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Class Evaluation Card (as shown in class-wise image)
  Widget _buildClassEvaluationCard(ClassEvaluationItem item) {
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
        children: [
          // Top Row (Avatar + Details + Score)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navy Initials Avatar
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B2E78),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Class & Section, Teacher Name, Code
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
                    const SizedBox(height: 3),
                    Text(
                      item.teacherName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.teacherCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              // Score Percentage
              Text(
                "${item.scorePercentage}%",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF5C38),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),

          // Action Buttons Row: View, Edit, Delete
          Row(
            children: [
              // 👁 View Button
              Expanded(
                child: InkWell(
                  onTap: () => _onViewClassEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: Color(0xFF1B2E78),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "View",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B2E78),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ✏️ Edit Button
              Expanded(
                child: InkWell(
                  onTap: () => _onEditClassEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Color(0xFF059669),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 🗑 Delete Button
              Expanded(
                child: InkWell(
                  onTap: () => _onDeleteClassEvaluation(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Color(0xFFEF4444),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
