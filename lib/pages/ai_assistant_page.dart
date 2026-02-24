import 'package:flutter/material.dart';
import '../services/vendor_service.dart';
import '../services/gemini_service.dart';
import '../models/vendor.dart';

class StreatoAIAssistantPage extends StatefulWidget {
  const StreatoAIAssistantPage({super.key});

  @override
  State<StreatoAIAssistantPage> createState() => _StreatoAIAssistantPageState();
}

class _StreatoAIAssistantPageState extends State<StreatoAIAssistantPage> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool loading = false;

  Future<void> askAI(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": query});
      loading = true;
    });

    // 🔥 Get vendors from your app database
    final vendors = await VendorService.getAllVendors();

    // Build context for AI
    String context = "";
    for (final v in vendors.take(40)) {
      context +=
      "${v.name} | rating:${v.rating} | category:${v.category} | location:${v.locationName}\n";
      for (final item in v.menu.take(5)) {
        context += " - ${item.name} ₹${item.price}\n";
      }
    }

    final reply = await GeminiService.chatWithContext(
      userMessage: query,
      context: context,
    );

    setState(() {
      messages.add({"role": "ai", "text": reply});
      loading = false;
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// CHAT MESSAGES
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isUser = msg["role"] == "user";

              return Align(
                alignment:
                isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 520),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFFFFB300)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    msg["text"]!,
                    style: TextStyle(
                      color: isUser ? Colors.black : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CircularProgressIndicator(),
          ),

        /// INPUT BAR
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Ask me anything about food, stalls, price, nearby...",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: askAI,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => askAI(controller.text),
                child: const Icon(Icons.send),
              )
            ],
          ),
        )
      ],
    );
  }
}