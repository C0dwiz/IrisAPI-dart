import 'dart:convert';

import 'package:iris_api/iris_api.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:http/testing.dart';

void main() {
  const botId = '123456';
  const irisToken = 'test_token';
  late IrisAPI api;
  late MockClient mockClient;

  group('IrisAPI Success Scenarios', () {
    test('balance returns a valid Balance object', () async {
      // Arrange
      final mockResponse = jsonEncode({
        "gold": 10.5,
        "sweets": 100.0,
        "donate_score": 50,
        "available": 95.0
      });
      mockClient =
          MockClient((request) async => http.Response(mockResponse, 200));
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act
      final balance = await api.balance();

      // Assert
      expect(balance, isA<Balance>());
      expect(balance.sweets, 100.0);
      expect(balance.gold, 10.5);
      expect(balance.donateScore, 50);
      expect(balance.available, 95.0);
    });

    test('giveSweets returns true on success', () async {
      // Arrange
      final mockResponse = jsonEncode({"result": "ok"});
      mockClient = MockClient((request) async {
        // Check if params are correct
        expect(request.url.queryParameters['sweets'], '10');
        expect(request.url.queryParameters['user_id'], '123456');
        expect(request.url.queryParameters['comment'], 'Test');
        return http.Response(mockResponse, 200);
      });
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act
      final result = await api.giveSweets(10, 123456, comment: 'Test');

      // Assert
      expect(result, isTrue);
    });

    test('sweetsHistory returns a list of entries with correct dates',
        () async {
      // Arrange
      final mockResponse = jsonEncode([
        {
          "id": 1,
          "date": 1672531200, // Unix timestamp in seconds
          "amount": "10.0",
          "balance": "100.0",
          "to_user_id": 123,
          "type": "transfer",
          "info": {"sweets": 10.0}
        }
      ]);
      mockClient =
          MockClient((request) async => http.Response(mockResponse, 200));
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act
      final history = await api.sweetsHistory();

      // Assert
      expect(history, isA<List<HistorySweetsEntry>>());
      expect(history, hasLength(1));
      expect(history.first.id, 1);
      expect(history.first.amount, 10.0);
      expect(history.first.datetime,
          DateTime.fromMillisecondsSinceEpoch(1672531200 * 1000));
    });
  });

  group('IrisAPI Error Scenarios', () {
    test('throws AuthorizationError on 401', () {
      // Arrange
      mockClient =
          MockClient((request) async => http.Response('Unauthorized', 401));
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act & Assert
      expect(() => api.balance(), throwsA(isA<AuthorizationError>()));
    });

    test('throws IrisAPIError on 500 server error', () {
      // Arrange
      mockClient =
          MockClient((request) async => http.Response('Server Error', 500));
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act & Assert
      expect(() => api.balance(), throwsA(isA<IrisAPIError>()));
    });

    test('giveSweets throws NotEnoughSweetsError', () {
      // Arrange
      final mockResponse = jsonEncode({
        "error": {"code": 409, "description": "Not enough sweets."}
      });
      mockClient =
          MockClient((request) async => http.Response(mockResponse, 200));
      api = IrisAPI(botId: botId, irisToken: irisToken, client: mockClient);

      // Act & Assert
      expect(
        () => api.giveSweets(1000, 123456),
        throwsA(isA<NotEnoughSweetsError>()),
      );
    });
  });
}
