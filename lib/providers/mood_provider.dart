import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class MoodProvider extends ChangeNotifier {
  final Box moodBox = Hive.box('moodBox');

  String? getMoodForDate(DateTime date) {
    final key = _formatDate(date);
    return moodBox.get(key);
  }

  void setMoodForDate(BuildContext context, DateTime date, String moodEmoji) async{
    final key = _formatDate(date);
    moodBox.put(key, moodEmoji);
    notifyListeners();

    final message = await _getAiMessage(moodEmoji);
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Your Mood Message"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
  }
   void removeMoodForDate(DateTime date) {
    final key = _formatDate(date);
    moodBox.delete(key);
    notifyListeners();
  }

  /// Format date as YYYY-MM-DD.
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
           '${date.month.toString().padLeft(2, '0')}-'
           '${date.day.toString().padLeft(2, '0')}';
  }

  /// Fetch AI-generated message
  Future<String> _getAiMessage(String mood) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer YOUR_OPENAI_API_KEY',//kvckd
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a friendly mood assistant.be compassionate and encouraging."},
          {"role": "user", "content": "Generate a short friendly message for someone feeling $mood."}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return "Stay strong! Every emotion is part of the journey. 😊";
    }
  }
}

