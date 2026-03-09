import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  final botIdRaw = Platform.environment['IRIS_BOT_ID'];
  final irisToken = Platform.environment['IRIS_TOKEN'];

  if (botIdRaw == null || irisToken == null) {
    print('Set IRIS_BOT_ID and IRIS_TOKEN environment variables.');
    return;
  }

  final botId = int.tryParse(botIdRaw);
  if (botId == null) {
    print('IRIS_BOT_ID must be an integer.');
    return;
  }

  const baseUrl = 'https://iris-tg.ru/api';
  final client = http.Client();

  String apiVersion = '0.5';
  try {
    final versionResponse = await client.get(Uri.parse('$baseUrl/last_version'));
    final versionJson = jsonDecode(versionResponse.body) as Map<String, dynamic>;
    apiVersion = versionJson['result']?.toString() ?? apiVersion;
  } catch (_) {
    // Fallback to 0.5 if the public version endpoint is unavailable.
  }

  final authPath = '${botId}_$irisToken/v$apiVersion';

  final endpoints = [
    'pocket/balance',
    'pocket/sweets/history?offset=0&limit=1',
    'pocket/gold/history?offset=0&limit=1',
    'pocket/tgstars/history?offset=0&limit=1',
    'user_info/spam',
    'trade/orderbook',
    'trade/deals?limit=1',
    'updates/getUpdates?offset=0&limit=1',
    'nft/list?offset=0&limit=1',
    'iris_agents',
  ];

  for (var endpoint in endpoints) {
    print('\nTesting: $endpoint');
    final url = Uri.parse('$baseUrl/$authPath/$endpoint');

    try {
      final response = await client.get(url);
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final json = jsonDecode(response.body);
          if (json is Map<String, dynamic>) {
            print('Keys: ${json.keys.toList()}');
          } else {
            print('Parsed JSON type: ${json.runtimeType}');
          }
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
