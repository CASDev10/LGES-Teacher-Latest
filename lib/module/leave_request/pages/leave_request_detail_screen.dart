import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'leave_approval_screen.dart';

class LeaveBalanceItem {
  final String title;
  final int days;
  final Color borderColor;

  LeaveBalanceItem({
    required this.title,
    required this.days,
    required this.borderColor,
  });
}

class LeaveRequestDetailScreen extends StatefulWidget {
  final LeaveRequestItem item;
  final Function(LeaveStatus newStatus)? onStatusChanged;

  const LeaveRequestDetailScreen({
    Key? key,
    required this.item,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<LeaveRequestDetailScreen> createState() =>
      _LeaveRequestDetailScreenState();
}

class _LeaveRequestDetailScreenState extends State<LeaveRequestDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late LeaveStatus _currentStatus;

  final List<LeaveBalanceItem> _leaveBalances = [
    LeaveBalanceItem(
      title: 'Casual Leaves',
      days: 10,
      borderColor: const Color(0xFF10B981),
    ),
    LeaveBalanceItem(
      title: 'Sick Leaves',
      days: 9,
      borderColor: const Color(0xFFFF6B4A),
    ),
    LeaveBalanceItem(
      title: 'Maternity Leaves',
      days: 18,
      borderColor: const Color(0xFF10B981),
    ),
    LeaveBalanceItem(
      title: 'Casual Leaves',
      days: 10,
      borderColor: const Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.item.status;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onReject() {
    setState(() {
      _currentStatus = LeaveStatus.rejected;
      widget.item.status = LeaveStatus.rejected;
    });
    widget.onStatusChanged?.call(LeaveStatus.rejected);
    Fluttertoast.showToast(
      msg: "Leave request rejected",
      backgroundColor: const Color(0xFFDC2626),
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }

  void _onApprove() {
    setState(() {
      _currentStatus = LeaveStatus.approved;
      widget.item.status = LeaveStatus.approved;
    });
    widget.onStatusChanged?.call(LeaveStatus.approved);
    Fluttertoast.showToast(
      msg: "Leave request approved successfully!",
      backgroundColor: const Color(0xFF059669),
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 App Bar
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
                    "Leave Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Leave Balances Horizontal Scroll
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _leaveBalances.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final balance = _leaveBalances[index];
                          return _buildBalanceCard(balance);
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 🔹 Leave Details Main Card
                    Container(
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
                          // Header: Avatar + Title/Teacher + Status Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B2E78),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.item.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Title & Teacher Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.item.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.item.applicantName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.item.applicantCode,
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
                              _buildStatusBadge(_currentStatus),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          const SizedBox(height: 12),

                          // Table Rows
                          _buildDetailRow("Leave Type", "Sick Leave"),
                          const Divider(height: 20, color: Color(0xFFF3F4F6)),
                          _buildDetailRow("From", "30 Jun"),
                          const Divider(height: 20, color: Color(0xFFF3F4F6)),
                          _buildDetailRow("To", "30 Jun"),
                          const Divider(height: 20, color: Color(0xFFF3F4F6)),
                          _buildDetailRow("Days", widget.item.duration),
                          const Divider(height: 20, color: Color(0xFFF3F4F6)),
                          _buildDetailRow("Reason", widget.item.reason),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Comments Heading
                    const Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 🔹 Comments Input Box
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 13.5),
                        decoration: const InputDecoration(
                          hintText: "Add comment for student/parent...",
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Reject & Approve Buttons Row
                    Row(
                      children: [
                        // Reject Button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _onReject,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFF1F2),
                                foregroundColor: const Color(0xFFDC2626),
                                elevation: 0,
                                side: const BorderSide(
                                  color: Color(0xFFFECACA),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Color(0xFFDC2626),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Reject",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Approve Button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _onApprove,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Approve",
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // 🔹 Balance Card
  Widget _buildBalanceCard(LeaveBalanceItem item) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: item.days.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2E78),
                  ),
                ),
                const TextSpan(
                  text: " Days",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Detail Row (Label --- Value)
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  // 🔹 Status Badge
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
}
