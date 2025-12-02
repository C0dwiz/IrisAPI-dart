// example/iris_example_fixed.dart
import 'dart:async';
import 'package:iris_api/iris_api.dart';

Future<void> main() async {
  final api = await IrisApi.create(
    botId: 8498110175,
    irisToken: 'lIGEBw0CPirJO32tQuS0Ax3A2CK9elnf',
  );

  print('🚀 Iris API Example with Rate Limiting');
  print('=' * 60);

  try {
    // Добавляем задержки между запросами
    print('\n1. Testing getBalance...');
    final balance = await api.getBalance();
    print('   ✅ Gold: ${balance.gold}, Sweets: ${balance.sweets}');
    await Future.delayed(Duration(seconds: 2));

    print('\n2. Testing getLastVersion...');
    final version = await api.getLastVersion();
    print('   ✅ API Version: $version');
    await Future.delayed(Duration(seconds: 2));

    print('\n3. Testing checkUserSpam...');
    const testUserId = 5858412531;
    final spamInfo = await api.checkUserSpam(testUserId);
    print('   ✅ Spam info: $spamInfo');
    await Future.delayed(Duration(seconds: 2));

    print('\n4. Testing getSweetsHistory...');
    final sweetsHistory = await api.getSweetsHistory();
    print('   ✅ Sweets history entries: ${sweetsHistory.length}');
    if (sweetsHistory.isNotEmpty) {
      print('   Last entry: ${sweetsHistory.first.amount} sweets');
    }
    await Future.delayed(Duration(seconds: 2));

    print('\n5. Testing getGoldHistory...');
    final goldHistory = await api.getGoldHistory();
    print('   ✅ Gold history entries: ${goldHistory.length}');
    if (goldHistory.isNotEmpty) {
      print('   Last entry: ${goldHistory.first.amount} gold');
    }
    await Future.delayed(Duration(seconds: 2));

    print('\n6. Testing getIrisAgents...');
    final agents = await api.getIrisAgents();
    print('   ✅ Agents found: ${agents.length}');
    await Future.delayed(Duration(seconds: 2));

    print('\n7. Testing deep link generation...');
    final link = api.generateDeepLink(Currency.gold, 10, 'test');
    print('   ✅ Generated link: $link');
  } on IrisApiError catch (e) {
    if (e.toString().contains('429')) {
      print('\n⚠️ Rate limit exceeded. Please wait and try again.');
      print('   You can increase delays between requests.');
    } else {
      print('\n❌ API Error: $e');
    }
  } catch (e) {
    print('\n❌ Unexpected error: $e');
  } finally {
    api.close();
    print('\n✅ Example completed!');
  }
}
