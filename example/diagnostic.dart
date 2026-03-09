import 'dart:io';

import 'package:iris_api/iris_api.dart';

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

  final testUserId =
      int.tryParse(Platform.environment['IRIS_TEST_USER_ID'] ?? '0') ?? 0;

  final api = await IrisApi.create(
    botId: botId,
    irisToken: irisToken,
  );

  print('Iris API Diagnostic Tool (v0.5)');
  print('=' * 60);

  final endpoints = [
    'pocket/balance',
    'pocket/sweets/history?offset=0&limit=1',
    'pocket/gold/history?offset=0&limit=1',
    'pocket/tgstars/history?offset=0&limit=1',
    'user_info/spam?user_id=$testUserId',
    'user_info/reg?user_id=$testUserId',
    'trade/orderbook',
    'trade/deals?limit=1',
    'updates/getUpdates?offset=0&limit=1',
    'nft/list?offset=0&limit=1',
    'nft/history?offset=0&limit=1',
    'iris_agents',
  ];

  for (var endpoint in endpoints) {
    print('\nTesting: $endpoint');
    try {
      final parts = endpoint.split('?');
      final path = parts[0];
      final params = parts.length > 1 ? Uri.splitQueryString(parts[1]) : null;

      final response = await api.getRequest(path, parameters: params);
      print('OK: ${response != null ? "Received data" : "Null"}');
      if (response != null && response is Map) {
        print('   Keys: ${response.keys.take(3).toList()}...');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  api.close();
}
