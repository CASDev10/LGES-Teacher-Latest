import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  const ChatDetailScreen({super.key, required this.userName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': false,
      'type': 'text',
      'text': 'Hi! How are you doing today?',
      'time': '10:00 AM',
      'status': null,
    },
    {
      'isMe': true,
      'type': 'text',
      'text': 'Hey! I’m doing great, thanks 😊',
      'time': '10:02 AM',
      'status': 'seen',
    },
    {
      'isMe': false,
      'type': 'text',
      'text': 'Glad to hear that! Did you complete the attendance update?',
      'time': '10:05 AM',
      'status': null,
    },
    {
      'isMe': true,
      'type': 'text',
      'text': 'Yes, I submitted it this morning.',
      'time': '10:06 AM',
      'status': 'delivered',
    },
  ];

  final ImagePicker _picker = ImagePicker();

  void _sendMessage({String? text, File? file, String? fileType}) {
    if ((text == null || text.trim().isEmpty) && file == null) return;

    setState(() {
      _messages.add({
        'isMe': true,
        'type': file != null ? fileType : 'text',
        'text': text ?? '',
        'file': file,
        'time':
            '${TimeOfDay.now().hourOfPeriod}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM'}',
        'status': 'sent',
      });
    });
    _messageController.clear();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _sendMessage(file: File(picked.path), fileType: 'image');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      _sendMessage(file: File(result.files.single.path!), fileType: 'file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar(widget.userName, centerTitle: false),
      backgroundColor: AppColors.primaryDark,
      hMargin: 0,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['isMe'] as bool;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColors.primaryDark
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (message['type'] == 'text')
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          if (message['type'] == 'image' &&
                              message['file'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                message['file'],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (message['type'] == 'file' &&
                              message['file'] != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    message['file'].path.split('/').last,
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message['time'],
                                style: TextStyle(
                                  color: isMe
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                              ),
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                _buildMessageStatusIcon(message['status']),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _showAttachmentOptions,
                      icon: Icon(
                        Icons.attach_file,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _sendMessage(text: _messageController.text),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryDark,
                        child: const Icon(Icons.send, color: Colors.white),
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.image,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: "Files",
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryDark.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primaryDark, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageStatusIcon(String? status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'seen':
        icon = Icons.done_all;
        color = Colors.lightBlueAccent;
        break;
      case 'delivered':
        icon = Icons.done_all;
        color = Colors.white70;
        break;
      case 'sent':
        icon = Icons.check;
        color = Colors.white70;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(icon, size: 16, color: color);
  }
}
