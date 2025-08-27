import 'dart:convert';

import 'package:iris_api/iris_api.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:http/testing.dart';

void main() {
  const botId = '123456';
  const irisToken = 'test_token';
  const apiVersion = '0.1';
  late IrisAPI api;
  late MockClient mockClient;

  void setMockClient(http.Response response) {
    mockClient = MockClient((request) async => response);
    api = IrisAPI(
      botId: botId,
      irisToken: irisToken,
      apiVersion: apiVersion,
      client: mockClient,
    );
  }

  group('IrisAPI v2 Success Scenarios', () {
    test('balance returns a valid Balance object', () async {
      final mockResponse = jsonEncode({
        "gold": 10.5,
        "sweets": 100.0,
        "donate_score": 50,
        "available": 95.0
      });
      setMockClient(http.Response(mockResponse, 200));

      final balance = await api.balance();

      expect(balance, isA<Balance>());
      expect(balance.sweets, 100.0);
      expect(balance.gold, 10.5);
    });

    test('giveSweets returns true on success', () async {
      final mockResponse = jsonEncode({"result": true});
      mockClient = MockClient((request) async {
        expect(request.url.path,
            '/api/${botId}_$irisToken/v$apiVersion/giveSweets');
        expect(request.url.queryParameters['sweets'], '10.0');
        return http.Response(mockResponse, 200);
      });
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      final result = await api.giveSweets(10, 123456);

      expect(result, isTrue);
    });

    test('sweetsHistory returns a list of new model entries', () async {
      final mockResponse = jsonEncode([
        {
          "id": 42,
          "type": "send",
          "date": 1754237728000,
          "amount": -10,
          "balance": 1,
          "peer_id": 661079614,
          "details": {"total": 10, "amount": 10, "fee": 0.0},
          "comment": "Test comment"
        }
      ]);
      setMockClient(http.Response(mockResponse, 200));

      final history = await api.sweetsHistory();

      expect(history, isA<List<HistorySweetsEntry>>());
      expect(history, hasLength(1));
      final entry = history.first;
      expect(entry.id, 42);
      expect(entry.peerId, 661079614);
      expect(entry.comment, "Test comment");
      expect(entry.details.total, 10);
      expect(entry.datetime,
          DateTime.fromMillisecondsSinceEpoch(1754237728000));
    });

    test('getUpdates returns a list of events', () async {
      final mockResponse = jsonEncode([
        {
          "id": 11,
          "type": "sweets_log",
          "date": 1756286741,
          "object": {
            "id": 42,
            "type": "send",
            "date": 1754237728000,
            "amount": -10,
            "balance": 1,
            "peer_id": 661079614,
            "details": {"total": 10, "amount": 10}
          }
        }
      ]);
      setMockClient(http.Response(mockResponse, 200));

      final updates = await api.getUpdates();
      expect(updates, isA<List<UpdateEvent>>());
      expect(updates.first.id, 11);
      expect(updates.first.object, isA<HistorySweetsEntry>());
      expect((updates.first.object as HistorySweetsEntry).peerId, 661079614);
    });

    test('getLatestApiVersion returns a version string', () async {
      setMockClient(http.Response('0.1', 200));
      final version = await api.getLatestApiVersion();
      expect(version, '0.1');
    });
  });

  group('IrisAPI v2 Trade Scenarios', () {
    test('getOrderBook returns a valid OrderBook object', () async {
      final mockResponse = jsonEncode({
        "buy": [
          {"volume": 100, "price": 0.5}
        ],
        "sell": [
          {"volume": 200, "price": 0.6}
        ]
      });
      setMockClient(http.Response(mockResponse, 200));
      final orderBook = await api.getOrderBook();
      expect(orderBook, isA<OrderBook>());
      expect(orderBook.buy.first.price, 0.5);
      expect(orderBook.sell.first.volume, 200);
    });

    test('getTradeDeals returns a list of deals', () async {
      final mockResponse = jsonEncode([
        {
          "id": 1,
          "group_id": 123,
          "date": 1672531200.0,
          "volume": 50,
          "type": "buy"
        }
      ]);
      setMockClient(http.Response(mockResponse, 200));
      final deals = await api.getTradeDeals();
      expect(deals, isA<List<TradeDeal>>());
      expect(deals.first.id, 1);
      expect(deals.first.type, "buy");
    });
  });

  group('IrisAPI v2 Error Scenarios', () {
    test('throws AuthorizationError on 401', () {
      setMockClient(http.Response('Unauthorized', 401));
      expect(() => api.balance(), throwsA(isA<AuthorizationError>()));
    });

    test('giveSweets throws NotEnoughSweetsError on code 409', () {
      final mockResponse = jsonEncode({
        "error": {"code": 409, "description": "Not enough sweets. Need 1000"}
      });
      setMockClient(http.Response(mockResponse, 200));

      expect(
        () => api.giveSweets(1000, 123456),
        throwsA(isA<NotEnoughSweetsError>()),
      );
    });

    test('throws IrisAPIError on other error codes', () {
      final mockResponse = jsonEncode(
          {"error": {"code": 404, "description": "User not found"}});
      setMockClient(http.Response(mockResponse, 200));

      expect(
          () => api.giveSweets(10, 123),
          throwsA(isA<IrisAPIError>().having(
              (e) => e.message, 'message', 'User not found (code: 404)')));
    });
  });
}