import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // Pulls your secured key from the Fish shell definition
  static const String _apiKey = String.fromEnvironment('TRANSLATE_KEY');

  Future<String> translateLatinToEnglish(String text) async {
    if (text.trim().isEmpty) return '';

    final url = Uri(
      scheme: 'https',
      host: 'translation.googleapis.com',
      path: '/language/translate/v2',
      queryParameters: {'key': _apiKey.trim()},
    );

    try {
      final response = await http.post(
        url,
        headers: {
          // Explicitly tells Google's load balancer to treat this as standard JSON data
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'q': text, // Your target Latin text
          'source': 'la', // Latin language code
          'target': 'en', // English language code
          'format': 'text', // Tells Google to return unformatted plain text
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Target Google's exact JSON nested maps array response
        final List translations = data['data']['translations'];
        if (translations.isNotEmpty) {
          return translations[0]['translatedText'] ??
              'No translation text returned';
        }
        return 'No translation found';
      } else {
        return 'API Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'Network Exception: $e';
    }
  }
}
