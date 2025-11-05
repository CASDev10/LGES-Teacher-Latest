import 'package:flutter/material.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';

import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Ali Raza',
      'message': 'Hey! Are you available tomorrow?',
      'time': '10:45 AM',
      'unread': 2,
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Sara Khan',
      'message': 'Thanks for your help!',
      'time': '9:20 AM',
      'unread': 0,
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Class 5B Group',
      'message': 'Reminder: Meeting at 3PM',
      'time': 'Yesterday',
      'unread': 1,
      'avatar': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'name': 'Principal',
      'message': 'Please submit your attendance report.',
      'time': 'Mon',
      'unread': 0,
      'avatar': 'https://i.pravatar.cc/150?img=3',
    },
  ];

  void _openNewChatDialog() async {
    final selectedTeacher = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TeacherListSheet(),
    );

    if (selectedTeacher != null && selectedTeacher.isNotEmpty) {
      NavRouter.push(context, ChatDetailScreen(userName: selectedTeacher));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const CustomAppbar('Conversations', centerTitle: true),
      hMargin: 0,
      backgroundColor: AppColors.primaryDark,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        onPressed: _openNewChatDialog,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            final chat = _conversations[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                NavRouter.push(
                  context,
                  ChatDetailScreen(userName: chat['name']),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: chat['unread'] > 0
                      ? AppColors.primaryDark.withOpacity(0.06)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(chat['avatar']),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat['message'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          chat['time'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (chat['unread'] > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chat['unread'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}

class _TeacherListSheet extends StatelessWidget {
  const _TeacherListSheet();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _teachers = [
      {'name': 'Mr. Ahmed Ali', 'avatar': 'https://i.pravatar.cc/150?img=1'},
      {'name': 'Ms. Fatima Noor', 'avatar': 'https://i.pravatar.cc/150?img=2'},
      {'name': 'Ms. Ayesha Khan', 'avatar': 'https://i.pravatar.cc/150?img=5'},
      {'name': 'Mr. Imran Tariq', 'avatar': 'https://i.pravatar.cc/150?img=3'},
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a member to Chat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _teachers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(_teachers[index]['avatar']),
                    ),
                    title: Text(_teachers[index]['name']),
                    onTap: () {
                      Navigator.pop(context, _teachers[index]['name']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
