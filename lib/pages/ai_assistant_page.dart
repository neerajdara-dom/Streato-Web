import 'package:flutter/material.dart';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [

        /// 🌙 Ambient Glow (Dark Only)
        if (isDark)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      const Color(0xFFFFB300).withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

        Column(
          children: [

            /// 💬 CHAT AREA
            Expanded(
              child: messages.isEmpty
                  ? Center(
                child: Text(
                  "Ask me anything about food, stalls, price, nearby...",
                  style: TextStyle(
                    color: isDark
                        ? Colors.white54
                        : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _chatBubble(
                    text: msg["text"],
                    isUser: msg["isUser"],
                    isDark: isDark,
                  );
                },
              ),
            ),

            /// 🧊 INPUT BAR
            Padding(
              padding: const EdgeInsets.all(20),
              child: _inputBar(isDark),
            ),
          ],
        ),
      ],
    );
  }

  /// 🔥 CHAT BUBBLE
  Widget _chatBubble({
    required String text,
    required bool isUser,
    required bool isDark,
  }) {
    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFFFFB300)
              : (isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white),

          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 10,
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser
                ? Colors.black
                : (isDark ? Colors.white : Colors.black),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  /// ✨ INPUT BAR
  Widget _inputBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.black.withOpacity(0.06),
            blurRadius: 15,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Ask about dosa, cheap food, nearby...",
                hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white54
                      : Colors.black54,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Color(0xFFFFB300),
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "text": controller.text.trim(),
        "isUser": true,
      });

      messages.add({
        "text": "Let me find the best options for you...",
        "isUser": false,
      });
    });

    controller.clear();
  }
}