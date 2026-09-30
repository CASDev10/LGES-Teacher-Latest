import 'package:flutter/material.dart';

class DashboardStatsOverview extends StatelessWidget {
  final int totalStudents;
  final int totalTeachers;
  final String schoolAttendance;
  final int pendingLeaves;

  const DashboardStatsOverview({
    Key? key,
    this.totalStudents = 1248,
    this.totalTeachers = 86,
    this.schoolAttendance = "88%",
    this.pendingLeaves = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                iconBgColor: const Color(0xFFFFE4EC),
                emoji: '🎓',
                value: '$totalStudents',
                title: 'Total Students',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                iconBgColor: const Color(0xFFE0F0FF),
                emoji: '👩‍🏫',
                value: '$totalTeachers',
                title: 'Total Teachers',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                iconBgColor: const Color(0xFFE8F8E8),
                emoji: '📊',
                value: schoolAttendance,
                title: 'School Attendance',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                iconBgColor: const Color(0xFFFFF3E0),
                emoji: '📁',
                value: '$pendingLeaves',
                title: 'Pending Leaves',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required Color iconBgColor,
    required String emoji,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2E78).withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
