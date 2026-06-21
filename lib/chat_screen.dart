import 'package:flutter/material.dart';

enum MessageStatus { sent, delivered, seen }

class AppColors {
  static const Color background = Colors.black;
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFF1F3F4);
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color textMuted = Color(0xFF9E9EA3);
  static const Color accent = Color(0xFF007AFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color danger = Color(0xFFFF3B30);
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  MessageStatus status;
  final DateTime time;

  Message({
    required this.text,
    required this.isMe,
    this.status = MessageStatus.sent,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Message> _messages = [
    Message(
      text: 'Hi! Your driver is arriving 🚗',
      isMe: false,
      status: MessageStatus.seen,
      time: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    Message(
      text: 'Great, I am waiting at the pickup point',
      isMe: true,
      status: MessageStatus.seen,
      time: DateTime.now().subtract(const Duration(minutes: 7)),
    ),
    Message(
      text: 'Traffic is heavy on MG Road, ETA ~7 mins',
      isMe: false,
      status: MessageStatus.delivered,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      text: 'No worries, I\'ll wait 👍',
      isMe: true,
      status: MessageStatus.sent,
      time: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isMe: true));
      _isTyping = false;
    });
    _controller.clear();
    _scrollToBottom();
    _simulateStatusUpdate();
  }

  void _simulateStatusUpdate() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _messages.last.status = MessageStatus.delivered);
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _messages.last.status = MessageStatus.seen);
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onChanged(String val) =>
      setState(() => _isTyping = val.isNotEmpty);

  void _deleteMessage(int i) =>
      setState(() => _messages.removeAt(i));

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.person_rounded,
                color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Driver',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Online',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        CircleIconButton(
          icon: Icons.phone_rounded,
          color: AppColors.accent,
          onTap: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _buildBubble(_messages[i], i),
    );
  }

  Widget _buildBubble(Message msg, int index) {
    return GestureDetector(
      onLongPress: msg.isMe ? () => _showDeleteSheet(index) : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment:
          msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isMe) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.person_rounded,
                    color: AppColors.textMuted, size: 14),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: msg.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.72,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? AppColors.accent
                          : AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
                        bottomRight: Radius.circular(msg.isMe ? 4 : 16),
                      ),
                      border: msg.isMe
                          ? null
                          : Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isMe
                            ? AppColors.background
                            : AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(msg.time),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                      if (msg.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          msg.status == MessageStatus.sent
                              ? Icons.check_rounded
                              : Icons.done_all_rounded,
                          size: 13,
                          color: msg.status == MessageStatus.seen
                              ? AppColors.accent
                              : AppColors.textMuted,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSheet(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: const Text('Delete message',
                  style: TextStyle(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded,
                  color: AppColors.textSecondary),
              title: const Text('Copy message',
                  style: TextStyle(color: AppColors.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                      color: AppColors.textMuted, fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isTyping ? AppColors.accent : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isTyping ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.send_rounded,
                color: _isTyping
                    ? AppColors.background
                    : AppColors.textMuted,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}