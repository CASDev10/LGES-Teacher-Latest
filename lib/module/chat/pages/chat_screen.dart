import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/chat/cubits/chat_history/chat_history_cubit.dart';
import 'package:lges_teacher_app/module/chat/cubits/chat_history/chat_history_state.dart';
import 'package:lges_teacher_app/module/chat/cubits/send_message/send_message_state.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';

import '../../../core/di/service_locator.dart';
import '../../../utils/custom_date_time_picker.dart';
import '../cubits/send_message/send_message_cubit.dart';

class ChatDetailScreen extends StatelessWidget {
  final String userName;
  final int conversationId;
  final int studentId;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.conversationId,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatHistoryCubit(sl())),
        BlocProvider(create: (context) => MessageCubit(sl())),
      ],
      child: ChatDetailScreenView(
        userName: userName,
        conversationId: conversationId,
        studentId: studentId,
      ),
    );
  }
}

class ChatDetailScreenView extends StatefulWidget {
  final String userName;
  final int conversationId;
  final int studentId;

  const ChatDetailScreenView({
    super.key,
    required this.userName,
    required this.conversationId,
    required this.studentId,
  });

  @override
  State<ChatDetailScreenView> createState() => _ChatDetailScreenViewState();
}

class _ChatDetailScreenViewState extends State<ChatDetailScreenView> {
  final TextEditingController _messageController = TextEditingController();
  AuthRepository authRepository = sl<AuthRepository>();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  int studentId = -1;
  int conversationId = -1;
  void _sendMessage(String message) {
    context.read<MessageCubit>().sendMessage(studentId, message);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {}
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {}
  }

  void _scrollToBottom() {
    print('Scrolling to bottom');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    studentId = widget.studentId;
    conversationId = widget.conversationId;
    if (widget.conversationId != -1)
      context.read<ChatHistoryCubit>().getChatHistory(conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar(widget.userName, centerTitle: false),
      backgroundColor: AppColors.primaryDark,
      hMargin: 0,
      body: BlocConsumer<MessageCubit, MessageState>(
        listener: (context, messageState) {
          if (messageState.messageStatus == MessageStatus.loading) {
            DisplayUtils.showLoader();
          }
          if (messageState.messageStatus == MessageStatus.success) {
            DisplayUtils.removeLoader();
            _messageController.clear();
            conversationId = messageState.conversationId;
            if (conversationId != -1)
              context.read<ChatHistoryCubit>().getChatHistory(
                conversationId,
                isLoading: false,
              );
          }
          if (messageState.messageStatus == MessageStatus.failure) {
            DisplayUtils.removeLoader();
            DisplayUtils.showToast(context, messageState.message);
          }
        },
        builder: (context, messageState) {
          return Container(
            width: double.infinity,
            height: double.infinity,
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
                  child: BlocConsumer<ChatHistoryCubit, ChatHistoryState>(
                    listener: (context, state) {
                      if (state.chatHistoryStatus ==
                          ChatHistoryStatus.success) {
                        studentId = state.messages.first.studentId;
                        _scrollToBottom();
                      }
                    },
                    builder: (context, state) {
                      if (state.chatHistoryStatus ==
                          ChatHistoryStatus.loading) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Loading messages...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.chatHistoryStatus ==
                          ChatHistoryStatus.failure) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade600,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                messageState.message,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (conversationId != -1)
                                    context
                                        .read<ChatHistoryCubit>()
                                        .getChatHistory(conversationId);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Retry",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (state.chatHistoryStatus ==
                          ChatHistoryStatus.success) {
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isMe =
                                message.empId == authRepository.user.empId;
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
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 15,
                                      ),
                                    ),
                                    /*if (message['type'] == 'text')
                                  Text(
                                    message['text'],
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black87,
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
                                  ),*/
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          changeDateTimeFormat(
                                            message.sentDate,
                                            'hh:mm a',
                                          ),
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white70
                                                : Colors.grey.shade600,
                                            fontSize: 11,
                                          ),
                                        ),
                                        if (isMe) ...[
                                          const SizedBox(width: 4),
                                          _buildMessageStatusIcon(
                                            message.isSeen,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return SizedBox.shrink();
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
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        // IconButton(
                        //   onPressed: _showAttachmentOptions,
                        //   icon: Icon(
                        //     Icons.attach_file,
                        //     color: AppColors.primaryDark,
                        //   ),
                        // ),
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
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
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
                          onTap: () => _sendMessage(_messageController.text),
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
          );
        },
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

  Widget _buildMessageStatusIcon(bool isSeen) {
    if (isSeen) {
      return const Icon(
        Icons.done_all,
        size: 16,
        color: Colors.lightBlueAccent, // Seen (Blue Double Tick)
      );
    } else {
      return const Icon(
        Icons.done_all,
        size: 16,
        color: Colors.white70, // Delivered (Grey Double Tick)
      );
    }
  }
}
