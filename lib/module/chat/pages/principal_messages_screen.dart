import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lges_teacher_app/config/routes/nav_router.dart';
import 'package:lges_teacher_app/module/chat/dialogs/start_chat_dialog.dart';
import 'package:lges_teacher_app/module/chat/pages/principal_chat_detail_screen.dart';

class PrincipalChatItem {
  final String id;
  final String name;
  final String initials;
  final Color avatarBgColor;
  final bool isOnline;
  final String lastMessage;
  final String time;
  final String tag;
  final Color tagBgColor;
  final Color tagTextColor;
  final int unreadCount;
  final String category; // 'Student' or 'Teachers'

  PrincipalChatItem({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarBgColor,
    required this.isOnline,
    required this.lastMessage,
    required this.time,
    required this.tag,
    required this.tagBgColor,
    required this.tagTextColor,
    required this.unreadCount,
    required this.category,
  });
}

class PrincipalMessagesScreen extends StatefulWidget {
  const PrincipalMessagesScreen({super.key});

  @override
  State<PrincipalMessagesScreen> createState() =>
      _PrincipalMessagesScreenState();
}

class _PrincipalMessagesScreenState extends State<PrincipalMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All'; // 'All', 'Student', 'Teachers'

  final List<PrincipalChatItem> _allChats = [
    PrincipalChatItem(
      id: '1',
      name: 'Mr. Tariq Ahmed',
      initials: 'MT',
      avatarBgColor: const Color(0xFFE53935),
      isOnline: true,
      lastMessage: 'Please submit attendance by 9 AM',
      time: '9:15 AM',
      tag: 'Teachers',
      tagBgColor: const Color(0xFFFFECEF),
      tagTextColor: const Color(0xFF8B2D38),
      unreadCount: 2,
      category: 'Teachers',
    ),
    PrincipalChatItem(
      id: '2',
      name: "Ahmad's Parents",
      initials: 'AP',
      avatarBgColor: const Color(0xFF0D9488),
      isOnline: false,
      lastMessage: 'Thank you for the update',
      time: '10:30 AM',
      tag: 'Student',
      tagBgColor: const Color(0xFFE6F7F0),
      tagTextColor: const Color(0xFF0D7E56),
      unreadCount: 0,
      category: 'Student',
    ),
    PrincipalChatItem(
      id: '3',
      name: 'Grade 5 Teachers',
      initials: 'G5',
      avatarBgColor: const Color(0xFF7C4DFF),
      isOnline: true,
      lastMessage: 'Meeting at 2 PM today',
      time: '11:00 AM',
      tag: 'Student',
      tagBgColor: const Color(0xFFF3E8FF),
      tagTextColor: const Color(0xFF7C3AED),
      unreadCount: 5,
      category: 'Student',
    ),
    PrincipalChatItem(
      id: '4',
      name: 'Ms. Fatima Malik',
      initials: 'MF',
      avatarBgColor: const Color(0xFF1E3A8A),
      isOnline: true,
      lastMessage: 'Can you share the worksheet?',
      time: '12:15 PM',
      tag: 'Teacher',
      tagBgColor: const Color(0xFFE8EEFF),
      tagTextColor: const Color(0xFF2563EB),
      unreadCount: 1,
      category: 'Teachers',
    ),
    PrincipalChatItem(
      id: '5',
      name: "Bilal's Parents",
      initials: 'BP',
      avatarBgColor: const Color(0xFF10B981),
      isOnline: false,
      lastMessage: 'He will be absent tomorrow',
      time: 'Yesterday',
      tag: 'Student',
      tagBgColor: const Color(0xFFE6F7F0),
      tagTextColor: const Color(0xFF0D7E56),
      unreadCount: 0,
      category: 'Student',
    ),
  ];

  List<PrincipalChatItem> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();
    return _allChats.where((chat) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          chat.category.toLowerCase() == _selectedCategory.toLowerCase() ||
          chat.tag.toLowerCase().contains(_selectedCategory.toLowerCase());

      final matchesQuery =
          query.isEmpty ||
          chat.name.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query) ||
          chat.tag.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openNewChatDialog() {
    StartNewChatDialog.show(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredChats;

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
          'Messages',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton.icon(
              onPressed: _openNewChatDialog,
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF112461),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF94A3B8),
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips (All, Student, Teachers)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterTab('All'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Student'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Teachers'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chats Count Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Chats (${filtered.length})',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Chat List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No conversations found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final chat = filtered[index];
                        return _buildChatCard(chat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title) {
    final bool isSelected = _selectedCategory == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF112461) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: isSelected
                ? null
                : Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(PrincipalChatItem chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EEF5)),
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
            NavRouter.push(
              context,
              PrincipalChatDetailScreen(
                userName: chat.name,
                subtitle: chat.tag.toLowerCase().contains('student')
                    ? 'Class 1 — Section A'
                    : 'Staff — ${chat.tag}',
                initials: chat.initials,
                avatarBgColor: chat.avatarBgColor,
                isOnline: chat.isOnline,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with online dot indicator
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: chat.avatarBgColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        chat.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Content Column (Name, Last Message, Tag)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Last Message
                      Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Tag Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: chat.tagBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          chat.tag,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: chat.tagTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Unread Count Badge
                if (chat.unreadCount > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF112461),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
