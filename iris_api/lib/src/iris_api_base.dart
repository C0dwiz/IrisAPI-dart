import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'exceptions.dart';

class IrisAPIBase {
  final String botId;
  final String irisToken;
  final String baseUrl;
  final Duration timeout;
  final http.Client client;

  IrisAPIBase({
    required this.botId,
    required this.irisToken,
    this.baseUrl = "https://iris-tg.ru/api",
    this.timeout = const Duration(seconds: 10),
    http.Client? client,
  }) : client = client ?? http.Client();

  @protected
  Future<dynamic> request(
    String method, {
    Map<String, dynamic>? params,
  }) async {
    final url = Uri.parse("$baseUrl/${botId}_$irisToken/$method");
    final filteredParams =
        params?.map((k, v) => MapEntry(k, v.toString())) ?? {};

    try {
      final response = await client
          .get(url.replace(queryParameters: filteredParams))
          .timeout(timeout);

      if (response.statusCode == 401) {
        throw AuthorizationError("Invalid credentials");
      } else if (response.statusCode == 429) {
        throw RateLimitError("Rate limit exceeded");
      } else if (response.statusCode == 400) {
        throw InvalidRequestError("Invalid request parameters");
      } else if (response.statusCode != 200) {
        throw IrisAPIError("Request failed with status ${response.statusCode}");
      }

      return _parseResponse(response.body);
    } on TimeoutException {
      throw IrisAPIError(
          "Request timed out after ${timeout.inSeconds} seconds");
    }
  }

  dynamic _parseResponse(String body) {
    try {
      return json.decode(body);
    } catch (e) {
      if (body.trim() == '[]') return [];
      throw FormatException('Invalid JSON response: $body');
    }
  }
}
