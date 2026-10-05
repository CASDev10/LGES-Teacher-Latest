import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum NotificationCategory {
  alerts,
  reminders,
  academic,
  messages,
}

class PrincipalNotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final Widget iconWidget;
  final Color iconBgColor;
  bool isUnread;
  final NotificationCategory category;

  PrincipalNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.iconWidget,
    required this.iconBgColor,
    required this.isUnread,
    required this.category,
  });
}

class PrincipalNotificationsScreen extends StatefulWidget {
  const PrincipalNotificationsScreen({super.key});

  @override
  State<PrincipalNotificationsScreen> createState() =>
      _PrincipalNotificationsScreenState();
}

class _PrincipalNotificationsScreenState
    extends State<PrincipalNotificationsScreen> {
  String _selectedTab = 'All'; // 'All', 'Unread', 'Alerts', 'Reminders', 'Academic'

  late List<PrincipalNotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      PrincipalNotificationItem(
        id: '1',
        title: 'New Leave Request',
        message: 'Ahmad Ali submitted a leave request for 30 July 2025.',
        time: '5 min ago',
        iconBgColor: const Color(0xFFEFF4FE),
        iconWidget: const Icon(
          Icons.notifications_active_rounded,
          color: Color(0xFFF59E0B),
          size: 22,
        ),
        isUnread: true,
        category: NotificationCategory.alerts,
      ),
      PrincipalNotificationItem(
        id: '2',
        title: 'Diary Reminder',
        message: 'Daily diary for Class 6-B is pending. Please submit by 2 PM.',
        time: '30 min ago',
        iconBgColor: const Color(0xFFEFF4FE),
        iconWidget: const Icon(
          Icons.alarm_rounded,
          color: Color(0xFFEF4444),
          size: 22,
        ),
        isUnread: true,
        category: NotificationCategory.reminders,
      ),
      PrincipalNotificationItem(
        id: '3',
        title: 'Exam Schedule Updated',
        message: 'Mid-term exams rescheduled to 10 July 2025 for all grades.',
        time: '2 hrs ago',
        iconBgColor: const Color(0xFFF1F5F9),
        iconWidget: const Icon(
          Icons.campaign_rounded,
          color: Color(0xFF64748B),
          size: 22,
        ),
        isUnread: false,
        category: NotificationCategory.academic,
      ),
      PrincipalNotificationItem(
        id: '4',
        title: 'Message from Principal',
        message: 'Staff meeting tomorrow at 8:00 AM in conference room.',
        time: 'Yesterday',
        iconBgColor: const Color(0xFFF1F5F9),
        iconWidget: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Color(0xFF64748B),
          size: 20,
        ),
        isUnread: false,
        category: NotificationCategory.messages,
      ),
      PrincipalNotificationItem(
        id: '5',
        title: 'Parent Message',
        message:
            "Fatima's parents request a meeting regarding academic progress.",
        time: 'Yesterday',
        iconBgColor: const Color(0xFFEFF4FE),
        iconWidget: const Icon(
          Icons.people_alt_rounded,
          color: Color(0xFF3B82F6),
          size: 22,
        ),
        isUnread: false,
        category: NotificationCategory.messages,
      ),
    ];
  }

  int get _totalCount => _notifications.length;
  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  List<PrincipalNotificationItem> get _filteredNotifications {
    if (_selectedTab == 'All') {
      return _notifications;
    } else if (_selectedTab == 'Unread') {
      return _notifications.where((n) => n.isUnread).toList();
    } else if (_selectedTab == 'Alerts') {
      return _notifications
          .where((n) => n.category == NotificationCategory.alerts)
          .toList();
    } else if (_selectedTab == 'Reminders') {
      return _notifications
          .where((n) => n.category == NotificationCategory.reminders)
          .toList();
    } else if (_selectedTab == 'Academic') {
      return _notifications
          .where((n) => n.category == NotificationCategory.academic)
          .toList();
    }
    return _notifications;
  }

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isUnread = false;
      }
    });
    Fluttertoast.showToast(msg: "All notifications marked as read");
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });
    Fluttertoast.showToast(msg: "Notification removed");
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF0F172A),
                size: 24,
              ),
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _markAllAsRead,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B2E68),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Tabs (All, Unread, Alerts, Reminders, Academic)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabPill('All'),
                    const SizedBox(width: 8),
                    _buildTabPill('Unread'),
                    const SizedBox(width: 8),
                    _buildTabPill('Alerts'),
                    const SizedBox(width: 8),
                    _buildTabPill('Reminders'),
                    const SizedBox(width: 8),
                    _buildTabPill('Academic'),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Summary Stats Cards (Total & Unread)
              Row(
                children: [
                  // Total Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8EEF5)),
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
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: Color(0xFF4F46E5),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '$_totalCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Unread Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8EEF5)),
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
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '$_unreadCount',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Unread',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Section Header: Notifications (X)
              Text(
                'Notifications (${filteredList.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Notifications List
              if (filteredList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No notifications found',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return _buildNotificationCard(item);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabPill(String title) {
    final bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B2E68) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? null
              : Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(PrincipalNotificationItem item) {
    final isUnread = item.isUnread;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFEFF4FE) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? const Color(0xFFD6E2FB) : const Color(0xFFE8EEF5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              item.isUnread = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: item.iconWidget,
                ),
                const SizedBox(width: 12),

                // Title, Message, Time Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Unread indicator
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1B2E68),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Message Body
                      Text(
                        item.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Time
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Delete Trash Icon
                IconButton(
                  onPressed: () => _deleteNotification(item.id),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
