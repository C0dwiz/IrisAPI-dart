import 'dart:async';
import 'dart:io';

import 'package:iris_api/iris_api.dart';

Future<void> main() async {
  final botIdRaw = Platform.environment['IRIS_BOT_ID'];
  final irisToken = Platform.environment['IRIS_TOKEN'];

  if (botIdRaw == null || irisToken == null) {
    print('Set IRIS_BOT_ID and IRIS_TOKEN environment variables.');
    print('Example: IRIS_BOT_ID=123 IRIS_TOKEN=token dart run example/iris_example.dart');
    return;
  }

  final botId = int.tryParse(botIdRaw);
  if (botId == null) {
    print('IRIS_BOT_ID must be an integer.');
    return;
  }

  final api = await IrisApi.create(
    botId: botId,
    irisToken: irisToken,
  );

  print('Iris API Example (v0.5-compatible)');
  print('=' * 60);

  try {
    print('\n1. getBalance');
    final balance = await api.getBalance();
    print('   Gold: ${balance.gold}, Sweets: ${balance.sweets}, TgStars: ${balance.tgstars}');
    await Future.delayed(Duration(seconds: 2));

    print('\n2. getLastVersion');
    final version = await api.getLastVersion();
    print('   API Version: $version');
    await Future.delayed(Duration(seconds: 2));

    final testUserIdRaw = Platform.environment['IRIS_TEST_USER_ID'];
    final testUserId = int.tryParse(testUserIdRaw ?? '0') ?? 0;

    print('\n3. checkUserSpam');
    final spamInfo = await api.checkUserSpam(testUserId);
    print('   Spam info: $spamInfo');
    await Future.delayed(Duration(seconds: 2));

    print('\n4. getSweetsHistory + getTgStarsHistory');
    final sweetsHistory = await api.getSweetsHistory(limit: 5);
    final tgStarsHistory = await api.getTgStarsHistory(limit: 5);
    print('   Sweets history entries: ${sweetsHistory.length}');
    print('   TgStars history entries: ${tgStarsHistory.length}');
    if (sweetsHistory.isNotEmpty) {
      print('   Last entry: ${sweetsHistory.first.amount} sweets');
    }
    await Future.delayed(Duration(seconds: 2));

    print('\n5. getOrderBook + getDealsTrade');
    final orderBook = await api.getOrderBook();
    final deals = await api.getDealsTrade(limit: 5);
    print('   Order book buy/sell: ${orderBook.buy.length}/${orderBook.sell.length}');
    print('   Deals entries: ${deals.length}');
    await Future.delayed(Duration(seconds: 2));

    print('\n6. getIrisAgents');
    final agents = await api.getIrisAgents();
    print('   Agents found: ${agents.length}');
    await Future.delayed(Duration(seconds: 2));

    print('\n7. Deep link generation for tgstars');
    final link = api.generateDeepLink(Currency.tgstars, 10, 'test');
    print('   Generated link: $link');

    print('\n8. NFT read-only methods');
    final nftList = await api.getNftList(limit: 3);
    final nftHistory = await api.getNftHistory(limit: 3);
    print('   NFT list entries: ${nftList.length}');
    print('   NFT history entries: ${nftHistory.length}');
  } on IrisApiError catch (e) {
    if (e.toString().contains('429')) {
      print('\nRate limit exceeded. Please wait and try again.');
    } else {
      print('\nAPI Error: $e');
    }
  } catch (e) {
    print('\nUnexpected error: $e');
  } finally {
    api.close();
    print('\nExample completed.');
  }
}
