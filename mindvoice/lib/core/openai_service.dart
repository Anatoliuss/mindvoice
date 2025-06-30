import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  // TODO: Replace with your real OpenAI API key
  static const String _apiKey = 'sk-REPLACE_ME';

  // Whisper API endpoint
  static const String _whisperEndpoint = 'https://api.openai.com/v1/audio/transcriptions';

  Future<String?> transcribeAudio(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    final request = http.MultipartRequest('POST', Uri.parse(_whisperEndpoint))
      ..headers['Authorization'] = 'Bearer $_apiKey'
      ..fields['model'] = 'whisper-1'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['text'] as String?;
    } else {
      print('OpenAI Whisper error: ${response.statusCode} ${response.body}');
      return null;
    }
  }

  // Summarize and give advice using GPT
  Future<Map<String, String>?> summarizeAndAdvise(String transcription) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';
    final prompt = '''You are a mental health assistant. Given the following voice message transcription, provide:
1. A concise summary of the message.
2. One piece of actionable mental health advice for the user.

Transcription:
"""
$transcription
"""

Respond in JSON with keys 'summary' and 'advice'.''';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 256,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'];
      try {
        final jsonResult = json.decode(content);
        return {
          'summary': jsonResult['summary'] ?? '',
          'advice': jsonResult['advice'] ?? '',
        };
      } catch (e) {
        // Fallback: try to parse summary/advice from plain text
        final summaryMatch = RegExp(r'Summary:(.*?)(Advice:|\Z)', dotAll: true).firstMatch(content);
        final adviceMatch = RegExp(r'Advice:(.*)', dotAll: true).firstMatch(content);
        return {
          'summary': summaryMatch?.group(1)?.trim() ?? '',
          'advice': adviceMatch?.group(1)?.trim() ?? '',
        };
      }
    } else {
      print('OpenAI GPT error: ${response.statusCode} ${response.body}');
      return null;
    }
  }
} 