import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/chat_message.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class ChatScreen extends StatelessWidget {
  final String peerId;
  final String peerName;

  const ChatScreen({
    super.key,
    required this.peerId,
    required this.peerName,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<AuthProvider>(context, listen: false).user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(peerName),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF64B6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: 'Report',
            onPressed: () {
              // TODO: Show report dialog or functionality
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'This chat is anonymous. Be kind and supportive.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: Provider.of<ChatProvider>(context)
                    .getMessages(userId: currentUserId, peerId: peerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!;
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == currentUserId;
                        return ChatBubble(message: message, isMe: isMe);
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF64B6FF),
                    ),
                  );
                },
              ),
            ),
            ChatInput(peerId: peerId),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe ? const Color(0xFF4A90E2) : const Color(0xFFE1E8FF);
    final textColor = isMe ? Colors.white : Colors.black87;
    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 16),
    );

    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('h:mm a').format(message.timestamp),
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  final String peerId;

  const ChatInput({super.key, required this.peerId});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<AuthProvider>(context, listen: false).user?.uid ?? '';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF4A90E2),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;

                  final message = ChatMessage(
                    id: DateTime.now().toIso8601String(),
                    senderId: currentUserId,
                    peerId: widget.peerId,
                    text: _controller.text.trim(),
                    timestamp: DateTime.now(),
                  );

                  Provider.of<ChatProvider>(context, listen: false).sendMessage(message);
                  _controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
