import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const botId = 8498110175;
  const irisToken = 'lIGEBw0CPirJO32tQuS0Ax3A2CK9elnf';
  const apiVersion = '0.3';
  const baseUrl = 'https://iris-tg.ru/api';

  final authPath = '${botId}_$irisToken/v$apiVersion';

  final endpoints = [
    'pocket/balance',
    'pocket/sweets/history',
    'pocket/gold/history',
    'user_info/spam',
    'trade/my_orders',
    'iris_agents',
  ];

  final client = http.Client();

  for (var endpoint in endpoints) {
    print('\n🔍 Testing: $endpoint');
    final url = Uri.parse('$baseUrl/$authPath/$endpoint');

    try {
      final response = await client.get(url);
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final json = jsonDecode(response.body);
          print('Parsed JSON: $json');
        } catch (e) {
          print('Not JSON or parse error: $e');
        }
      }
    } catch (e) {
      print('Request error: $e');
    }
  }

  client.close();
}
