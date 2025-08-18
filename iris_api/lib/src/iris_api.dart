import 'dart:async';

import 'iris_api_base.dart';
import 'exceptions.dart';
import 'models.dart';

class IrisAPI extends IrisAPIBase {
  int _lastId = 0;

  IrisAPI({
    required super.botId,
    required super.irisToken,
    super.baseUrl,
    super.timeout,
    super.client,
  });

  Future<Balance> balance() async {
    final data = await request("pocket/balance");
    return Balance.fromJson(data);
  }

  Future<bool> giveSweets(
    double sweets,
    int userId, {
    String comment = "",
  }) async {
    final params = {
      "sweets": sweets == sweets.truncate()
          ? sweets.truncate().toString()
          : sweets.toString(),
      "user_id": userId.toString(),
      "comment": comment,
    };

    final response = await request("pocket/sweets/give", params: params);

    if (response["result"] == "ok") {
      return true;
    }

    if (response["error"] != null) {
      final error = response["error"];
      if (error["description"] is String &&
          (error["description"] as String).contains("Not enough sweets")) {
        throw NotEnoughSweetsError(required: sweets);
      }
    }

    throw IrisAPIError("Sweets transfer failed: ${response.toString()}");
  }

  Future<bool> giveGold(
    double gold,
    int userId, {
    String comment = "",
  }) async {
    final params = {
      "gold": gold == gold.truncate()
          ? gold.truncate().toString()
          : gold.toString(),
      "user_id": userId.toString(),
      "comment": comment,
    };

    final response = await request("pocket/gold/give", params: params);

    if (response["result"] == "ok") {
      return true;
    }

    if (response["error"] != null) {
      final error = response["error"];
      if (error["description"] is String &&
          (error["description"] as String).contains("Not enough gold")) {
        throw NotEnoughGoldError(required: gold);
      }
    }

    throw IrisAPIError("Gold transfer failed: ${response.toString()}");
  }

  Future<List<HistorySweetsEntry>> sweetsHistory({
    int? offset,
    int? limit,
    int? userId,
    String? transactionType,
  }) async {
    final params = <String, String>{};
    if (offset != null) params["offset"] = offset.toString();
    if (limit != null) params["limit"] = limit.toString();
    if (userId != null) params["user_id"] = userId.toString();
    if (transactionType != null) params["type"] = transactionType;

    final response = await request("pocket/sweets/history", params: params);

    if (response is List) {
      return response.map<HistorySweetsEntry>((item) {
        return HistorySweetsEntry.fromJson(item);
      }).toList();
    }

    throw IrisAPIError("Unexpected response format for sweets history");
  }

  Future<List<HistoryGoldEntry>> goldHistory({
    int? offset,
    int? limit,
    int? userId,
    String? transactionType,
  }) async {
    final params = <String, String>{};
    if (offset != null) params["offset"] = offset.toString();
    if (limit != null) params["limit"] = limit.toString();
    if (userId != null) params["user_id"] = userId.toString();
    if (transactionType != null) params["type"] = transactionType;

    final response = await request("pocket/gold/history", params: params);

    if (response is List) {
      return response.map<HistoryGoldEntry>((item) {
        return HistoryGoldEntry.fromJson(item);
      }).toList();
    }

    throw IrisAPIError("Unexpected response format for gold history");
  }

  Future<bool> bagShow({required bool on}) async {
    final method = on ? "pocket/enable" : "pocket/disable";
    final response = await request(method);
    return response["response"] == "ok";
  }

  Future<HistorySweetsEntry> getSweetsTransaction(int transactionId) async {
    final history = await sweetsHistory();
    for (final entry in history) {
      if (entry.id == transactionId) {
        return entry;
      }
    }
    throw TransactionSweetsNotFoundError(
        "Sweets transaction $transactionId not found");
  }

  Future<HistoryGoldEntry> getGoldTransaction(int transactionId) async {
    final history = await goldHistory();
    for (final entry in history) {
      if (entry.id == transactionId) {
        return entry;
      }
    }
    throw TransactionGoldNotFoundError(
        "Gold transaction $transactionId not found");
  }

  Future<bool> userAll({required bool allow}) async {
    final method = allow ? "pocket/allow_all" : "pocket/deny_all";
    final response = await request(method);
    return response["response"] == "ok";
  }

  Future<bool> allowUser(int userId, {required bool allow}) async {
    final method = allow ? "pocket/allow_user" : "pocket/deny_user";
    final params = {"user_id": userId.toString()};
    final response = await request(method, params: params);
    return response["response"] == "ok";
  }

  Stream<HistorySweetsEntry> trackTransactions({
    int? initialOffset,
    Duration pollInterval = const Duration(seconds: 1),
    Duration reconnectDelay = const Duration(seconds: 5),
  }) async* {
    if (initialOffset != null) {
      _lastId = initialOffset;
    } else {
      final history = await sweetsHistory(limit: 1);
      _lastId = history.isNotEmpty ? history.first.id : 0;
    }

    while (true) {
      try {
        final newTransactions = await sweetsHistory(offset: _lastId + 1);
        if (newTransactions.isNotEmpty) {
          for (final tx in newTransactions) {
            yield tx;
            _lastId = tx.id;
          }
        } else {
          await Future.delayed(pollInterval);
        }
      } catch (e) {
        await Future.delayed(reconnectDelay);
      }
    }
  }
}
