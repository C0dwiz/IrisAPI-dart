import 'package:iris_api/iris_api.dart';

void main() async {
  final api = await IrisApi.create(
    botId: 8498110175,
    irisToken: 'lIGEBw0CPirJO32tQuS0Ax3A2CK9elnf',
  );

  print('🔍 Iris API Diagnostic Tool');
  print('=' * 60);

  // Тест 1: Проверим доступность endpoints
  final endpoints = [
    'pocket/balance',
    'pocket/sweets/history?offset=0',
    'pocket/gold/history?offset=0',
    'user_info/spam?user_id=5858412531',
    'user_info/reg?user_id=5858412531',
    'trade/book',
    'trade/my_orders',
    'iris_agents',
  ];

  for (var endpoint in endpoints) {
    print('\nTesting: $endpoint');
    try {
      final parts = endpoint.split('?');
      final path = parts[0];
      final params = parts.length > 1 ? Uri.splitQueryString(parts[1]) : null;

      final response = await api.getRequest(path, parameters: params);
      print('✅ Response: ${response != null ? "Received data" : "Null"}');
      if (response != null && response is Map) {
        print('   Keys: ${response.keys.take(3).toList()}...');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  api.close();
}
