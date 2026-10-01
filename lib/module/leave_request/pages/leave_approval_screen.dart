import 'package:flutter/material.dart';
import 'leave_request_detail_screen.dart';

enum LeaveStatus { pending, submitted, approved, rejected }

class LeaveRequestItem {
  final String id;
  final String title;
  final String applicantName;
  final String applicantCode;
  final String initials;
  final String dateRange;
  final String duration;
  final String reason;
  LeaveStatus status;
  final DateTime appliedDate;

  LeaveRequestItem({
    required this.id,
    required this.title,
    required this.applicantName,
    required this.applicantCode,
    required this.initials,
    required this.dateRange,
    required this.duration,
    required this.reason,
    required this.status,
    required this.appliedDate,
  });

  String get statusText {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.submitted:
        return 'Submitted';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
    }
  }
}

class LeaveApprovalScreen extends StatefulWidget {
  const LeaveApprovalScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApprovalScreen> createState() => _LeaveApprovalScreenState();
}

class _LeaveApprovalScreenState extends State<LeaveApprovalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Approved', 'Rejected'

  late List<LeaveRequestItem> _leaveRequests;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    _leaveRequests = [
      LeaveRequestItem(
        id: '1',
        title: 'Class 1 — Section A',
        applicantName: 'Ms. Ayesha Khalid',
        applicantCode: 'TCH-001',
        initials: 'MA',
        dateRange: '30 Jun — 30 Jun',
        duration: '1 day',
        reason: 'Medical checkup',
        status: LeaveStatus.pending,
        appliedDate: DateTime.now(),
      ),
      LeaveRequestItem(
        id: '2',
        title: 'Class 1 — Section A',
        applicantName: 'Ms. Ayesha Khalid',
        applicantCode: 'TCH-001',
        initials: 'MA',
        dateRange: '30 Jun — 30 Jun',
        duration: '1 day',
        reason: 'Medical checkup',
        status: LeaveStatus.submitted,
        appliedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LeaveRequestItem(
        id: '3',
        title: 'Class 1 — Section A',
        applicantName: 'Ms. Ayesha Khalid',
        applicantCode: 'TCH-001',
        initials: 'MA',
        dateRange: '30 Jun — 30 Jun',
        duration: '1 day',
        reason: 'Medical checkup',
        status: LeaveStatus.submitted,
        appliedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      LeaveRequestItem(
        id: '4',
        title: 'Class 2 — Section B',
        applicantName: 'Mr. Bilal Ahmed',
        applicantCode: 'TCH-002',
        initials: 'MB',
        dateRange: '02 Jul — 03 Jul',
        duration: '2 days',
        reason: 'Family event',
        status: LeaveStatus.approved,
        appliedDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LeaveRequestItem> get _filteredRequests {
    return _leaveRequests.where((item) {
      // Status tab filter
      if (_selectedFilter == 'Pending' &&
          item.status != LeaveStatus.pending &&
          item.status != LeaveStatus.submitted) {
        return false;
      }
      if (_selectedFilter == 'Approved' &&
          item.status != LeaveStatus.approved) {
        return false;
      }
      if (_selectedFilter == 'Rejected' &&
          item.status != LeaveStatus.rejected) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesName = item.applicantName.toLowerCase().contains(query);
        final matchesCode = item.applicantCode.toLowerCase().contains(query);
        final matchesReason = item.reason.toLowerCase().contains(query);

        if (!matchesTitle && !matchesName && !matchesCode && !matchesReason) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  int get _pendingCount => _leaveRequests
      .where(
        (e) =>
            e.status == LeaveStatus.pending ||
            e.status == LeaveStatus.submitted,
      )
      .length;

  int get _approvedCount =>
      _leaveRequests.where((e) => e.status == LeaveStatus.approved).length;

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF1B2E78), size: 22),
            SizedBox(width: 8),
            Text(
              "Leave Approval Info",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2E78),
                fontSize: 17,
              ),
            ),
          ],
        ),
        content: const Text(
          "Review submitted leave applications from teachers and staff. You can view full details, approve requests, or reject them with reason remarks.",
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF4B5563),
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2E78),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Got it", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRequests;

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
                  const SizedBox(width: 14),
                  // Title
                  const Text(
                    "Leave Approval",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  // Info Button
                  InkWell(
                    onTap: _showInfoDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFF1B2E78),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Search and Filter Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                children: [
                  // Search Bar
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
                        hintText: "Search student name...",
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
                          vertical: 11,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter Pills Row (All, Pending, Approved, Rejected)
                  Row(
                    children: [
                      Expanded(child: _buildFilterPill("All")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFilterPill("Pending")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFilterPill("Approved")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFilterPill("Rejected")),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Metric Cards Row: Pending & Approved
                    Row(
                      children: [
                        // Pending Card
                        Expanded(
                          child: _buildMetricCard(
                            count: "$_pendingCount",
                            label: "Pending",
                            icon: Icons.access_time,
                            iconBgColor: const Color(0xFFFFF1EB),
                            iconColor: const Color(0xFFFF6B4A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Approved Card
                        Expanded(
                          child: _buildMetricCard(
                            count: "$_approvedCount",
                            label: "Approved",
                            icon: Icons.check_circle_outline,
                            iconBgColor: const Color(0xFFE6F9F0),
                            iconColor: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Section Heading
                    Text(
                      "Leave Requests (${filtered.length})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Requests List
                    if (filtered.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_turned_in_outlined,
                                size: 54,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No leave requests found",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildLeaveRequestCard(item);
                        },
                      ),

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

  // 🔹 Filter Pill Widget
  Widget _buildFilterPill(String title) {
    final isSelected = _selectedFilter == title;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = title;
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
            color: isSelected
                ? const Color(0xFF1B2E78)
                : const Color(0xFFE5E7EB),
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

  // 🔹 Summary Metric Card Widget
  Widget _buildMetricCard({
    required String count,
    required String label,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
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
          // Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 14),
          // Count
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Status Badge Widget
  Widget _buildStatusBadge(LeaveStatus status) {
    Color bg;
    Color textColor;
    String text;

    switch (status) {
      case LeaveStatus.pending:
        bg = const Color(0xFFFFF1EB);
        textColor = const Color(0xFFFF6B4A);
        text = "• Pending";
        break;
      case LeaveStatus.submitted:
        bg = const Color(0xFFE6F9F0);
        textColor = const Color(0xFF0D9488);
        text = "• Submitted";
        break;
      case LeaveStatus.approved:
        bg = const Color(0xFFE6F9F0);
        textColor = const Color(0xFF059669);
        text = "• Approved";
        break;
      case LeaveStatus.rejected:
        bg = const Color(0xFFFFF1F2);
        textColor = const Color(0xFFDC2626);
        text = "• Rejected";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  // 🔹 Leave Request Card Widget
  Widget _buildLeaveRequestCard(LeaveRequestItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeaveRequestDetailScreen(
              item: item,
              onStatusChanged: (newStatus) {
                setState(() {
                  item.status = newStatus;
                });
              },
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            // Top Row: Avatar + Info + Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Initials Avatar
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
                // Title & Applicant
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.applicantName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.applicantCode,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                _buildStatusBadge(item.status),
              ],
            ),

            const SizedBox(height: 10),

            // Date & Duration Row
            Row(
              children: [
                const Text("📅 ", style: TextStyle(fontSize: 12)),
                Text(
                  "${item.dateRange} · ${item.duration}",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Reason
            Text(
              item.reason,
              style: const TextStyle(
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 14),

            // View Details Button
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaveRequestDetailScreen(
                      item: item,
                      onStatusChanged: (newStatus) {
                        setState(() {
                          item.status = newStatus;
                        });
                      },
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                    SizedBox(width: 6),
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B2E78),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
