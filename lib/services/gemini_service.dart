import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyCZIqjKgbFBYMGQhT_nIDUBTLiee7HppZM";

  static Future<Map<String, dynamic>> parseQuery(String text) async {
    try {

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                  "Extract food name and max price from this query and return ONLY JSON.\nQuery: $text\nFormat: {\"food\": string or null, \"max_price\": number or null}"
                }
              ]
            }
          ]
        }),
      );


      final decoded = jsonDecode(response.body);

      print("RAW GEMINI RESPONSE = $decoded");


      if (decoded["candidates"] == null ||
          decoded["candidates"].isEmpty ||
          decoded["candidates"][0]["content"] == null) {
        return {};
      }

      final textOutput =
      decoded["candidates"][0]["content"]["parts"][0]["text"];

      print("GEMINI TEXT = $textOutput");

      // Extract JSON safely
      final jsonStart = textOutput.indexOf("{");
      final jsonEnd = textOutput.lastIndexOf("}");

      if (jsonStart == -1 || jsonEnd == -1) return {};

      final jsonString = textOutput.substring(jsonStart, jsonEnd + 1);



      return jsonDecode(jsonString);
    } catch (e) {
      print("GEMINI ERROR = $e");
      return {};
    }
  }
  static Future<String> callGemini(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      final decoded = jsonDecode(response.body);

      if (decoded["candidates"] == null ||
          decoded["candidates"].isEmpty ||
          decoded["candidates"][0]["content"] == null) {
        return "Hmm… I couldn’t understand that. Try asking differently 😊";
      }

      return decoded["candidates"][0]["content"]["parts"][0]["text"];
    } catch (e) {
      print("CHAT GEMINI ERROR = $e");
      return "Oops! Something went wrong. Please try again.";
    }
  }
  static Future<String> chatWithContext({
    required String userMessage,
    required String context,
  }) async {
    final prompt = """
You are Streato AI — a friendly street food guide inside a food discovery app.

Speak like a helpful human, conversational and natural.
Use the provided stall and food data to answer.

You can recommend:
- Best stalls
- Cheap food
- Popular dishes
- Nearby food
- What user should try

APP DATA:
$context

USER QUESTION:
$userMessage
""";

    final response = await callGemini(prompt);
    return response;
  }

}
