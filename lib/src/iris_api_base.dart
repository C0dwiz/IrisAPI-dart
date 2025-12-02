import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

abstract class IrisApiBase {
  final int botId;
  final String irisToken;
  final String apiVersion;
  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  IrisApiBase({
    required this.botId,
    required this.irisToken,
    required this.apiVersion,
    this.baseUrl = "https://iris-tg.ru/api",
    this.timeout = const Duration(seconds: 30),
    http.Client? client,
  }) : _client = client ?? http.Client();

  String get _authPath => "${botId}_$irisToken/v$apiVersion";

  Future<dynamic> postRequest(
    String method, {
    Map<String, String>? parameters,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/$_authPath/$method");

      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: parameters != null
                ? Uri(queryParameters: parameters).query
                : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        throw IrisApiError('Request timeout');
      }
      rethrow;
    }
  }

  Future<dynamic> getRequest(
    String method, {
    Map<String, String>? parameters,
  }) async {
    try {
      var url = Uri.parse("$baseUrl/$_authPath/$method");

      if (parameters != null) {
        url = url.replace(
          queryParameters: parameters,
        );
      }

      final response = await _client.get(url).timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        throw IrisApiError('Request timeout');
      }
      rethrow;
    }
  }

  Future<dynamic> publicRequest(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      final response = await _client.get(url).timeout(timeout);
      return _handleResponse(response);
    } catch (e) {
      if (e is TimeoutException) {
        throw IrisApiError('Request timeout');
      }
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isEmpty) return null;
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        return responseBody;
      }
    } else {
      try {
        final errorData = jsonDecode(responseBody);
        if (errorData is Map && errorData.containsKey('error')) {
          final error = errorData['error'];
          throw IrisApiError(
            '${error['description']} (code: ${error['code']})',
            code: error['code'],
          );
        }
      } catch (e) {
        throw IrisApiError('HTTP $statusCode: ${response.reasonPhrase}');
      }

      throw IrisApiError('HTTP $statusCode: ${response.reasonPhrase}');
    }
  }

  void close() {
    _client.close();
  }
}
