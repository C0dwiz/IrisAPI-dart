import 'dart:async';



import 'exceptions.dart';
import 'iris_api_base.dart';
import 'models.dart';

class IrisAPI extends IrisAPIBase {
  IrisAPI({
    required super.botId,
    required super.irisToken,
    super.apiVersion = '0.1',
    super.baseUrl = "https://iris-tg.ru/api",
    super.timeout = const Duration(seconds: 10),
    super.client,
  });

  Future<String> getLatestApiVersion() async {
    final data = await publicRequest('https://iris-tg.ru/api/last-version');
    return data.toString();
  }

  Future<Balance> balance() async {
    final data = await request('balance');
    return Balance.fromJson(data);
  }

  Future<bool> giveSweets(double amount, int userId, {String? comment}) async {
    final params = {
      'sweets': amount,
      'user_id': userId,
      if (comment != null) 'comment': comment,
    };
    final data = await request('giveSweets', params: params);

    if (data is Map && data.containsKey('error')) {
      final error = data['error'];
      if (error['code'] == 409 &&
          error['description'].toString().contains('Not enough sweets')) {
        throw NotEnoughSweetsError(required: amount);
      }
      throw IrisAPIError('${error['description']} (code: ${error['code']})');
    }

    return data['result'] == true;
  }

  Future<bool> giveGold(double amount, int userId, {String? comment}) async {
    final params = {
      'gold': amount,
      'user_id': userId,
      if (comment != null) 'comment': comment,
    };
    final data = await request('giveGold', params: params);

    if (data is Map && data.containsKey('error')) {
      final error = data['error'];
      if (error['code'] == 409 &&
          error['description'].toString().contains('Not enough gold')) {
        throw NotEnoughGoldError(required: amount);
      }
      throw IrisAPIError('${error['description']} (code: ${error['code']})');
    }

    return data['result'] == true;
  }

  Future<List<HistorySweetsEntry>> sweetsHistory({int? limit}) async {
    final params = {if (limit != null) 'limit': limit};
    final data = await request('pocket/sweets/history', params: params);

    if (data is List) {
      return data.map((item) => HistorySweetsEntry.fromJson(item)).toList();
    } else if (data is Map && data.containsKey('error')) {
      throw TransactionSweetsNotFoundError(data['error']['description']);
    }
    return [];
  }

  Future<List<HistoryGoldEntry>> goldHistory({int? limit}) async {
    final params = {if (limit != null) 'limit': limit};
    final data = await request('pocket/gold/history', params: params);

    if (data is List) {
      return data.map((item) => HistoryGoldEntry.fromJson(item)).toList();
    } else if (data is Map && data.containsKey('error')) {
      throw TransactionGoldNotFoundError(data['error']['description']);
    }
    return [];
  }

  Future<List<UpdateEvent>> getUpdates() async {
    final data = await request('getUpdates');
    if (data is List) {
      return data.map((item) => UpdateEvent.fromJson(item)).toList();
    }
    return [];
  }

  Stream<dynamic> trackTransactions({
    Duration pollInterval = const Duration(seconds: 5),
  }) async* {
    int? lastEventId;

    while (true) {
      try {
        final updates = await getUpdates();
        if (updates.isNotEmpty) {
          if (lastEventId == null) {
            lastEventId = updates.first.id;
          } else {
            final newEvents = updates.where((e) => e.id > lastEventId!).toList();
            if (newEvents.isNotEmpty) {
              newEvents.sort((a, b) => a.id.compareTo(b.id));
              for (final event in newEvents) {
                yield event.object;
              }
              lastEventId = newEvents.last.id;
            }
          }
        }
      } catch (e) {
        // Consider logging the error.
      }
      await Future.delayed(pollInterval);
    }
  }

  Future<OrderBook> getOrderBook() async {
    final data = await publicRequest('https://iris-tg.ru/k/trade/order_book');
    return OrderBook.fromJson(data);
  }

  Future<List<TradeDeal>> getTradeDeals({int? fromId}) async {
    final params = {if (fromId != null) 'id': fromId};
    final data =
        await publicRequest('https://iris-tg.ru/trade/deals', params: params);
    if (data is List) {
      return data.map((item) => TradeDeal.fromJson(item)).toList();
    }
    return [];
  }
}