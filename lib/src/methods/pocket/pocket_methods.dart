import 'package:iris_api/iris_api.dart';

class PocketMethods {
  final IrisApiBase api;

  PocketMethods(this.api);

  List<dynamic> _extractResultList(dynamic response) {
    if (response is Map<String, dynamic> && response['result'] is List) {
      return response['result'] as List<dynamic>;
    }
    if (response is List) {
      return response;
    }
    return <dynamic>[];
  }

  Future<Balance> getBalance() async {
    final response = await api.getRequest('pocket/balance');
    final result = response is Map<String, dynamic>
        ? (response['result'] as Map<String, dynamic>? ?? <String, dynamic>{})
        : <String, dynamic>{};
    return Balance.fromJson(result);
  }

  Future<int> giveSweets(
    SweetsGiveRequest request, {
    required double amount,
  }) async {
    final response = await api.postRequest('pocket/sweets/give', parameters: {
      'amount': amount.toString(),
      'user_id': request.userId.toString(),
      'comment': request.comment,
      'without_donate_score': request.withoutDonateScore.toString(),
      'donate_score': request.donateScore.toString(),
    });
    return response['result'];
  }

  Future<int> giveGold(
    GoldGiveRequest request, {
    required int amount,
  }) async {
    final response = await api.postRequest('pocket/gold/give', parameters: {
      'amount': amount.toString(),
      'user_id': request.userId.toString(),
      'comment': request.comment,
      'without_donate_score': request.withoutDonateScore.toString(),
      'donate_score': request.donateScore.toString(),
    });
    return response['result'];
  }

  Future<int> giveDonateScore(DonateScoreGiveRequest request) async {
    final response =
        await api.postRequest('pocket/donate_score/give', parameters: {
      'amount': request.amount.toString(),
      'user_id': request.userId.toString(),
      'comment': request.comment,
    });
    return response['result'];
  }

  Future<List<SweetsHistoryEntry>> getSweetsHistory(
    HistoryRequest request, {
    required int limit,
  }) async {
    final response = await api.getRequest('pocket/sweets/history', parameters: {
      'offset': request.offset.toString(),
      'limit': limit.toString(),
    });

    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(SweetsHistoryEntry.fromJson)
        .toList();
  }

  Future<List<GoldHistoryEntry>> getGoldHistory(
    HistoryRequest request, {
    required int limit,
  }) async {
    final response = await api.getRequest('pocket/gold/history', parameters: {
      'offset': request.offset.toString(),
      'limit': limit.toString(),
    });

    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(GoldHistoryEntry.fromJson)
        .toList();
  }

  Future<List<DonateScoreHistoryEntry>> getDonateScoreHistory(
      HistoryRequest request) async {
    final response =
        await api.getRequest('pocket/donate_score/history', parameters: {
      'offset': request.offset.toString(),
      'limit': request.limit.toString(),
    });

    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(DonateScoreHistoryEntry.fromJson)
        .toList();
  }

  Future<bool> enablePocket() async {
    final response = await api.postRequest('pocket/enable');
    return response['result'] == true;
  }

  Future<bool> disablePocket() async {
    final response = await api.postRequest('pocket/disable');
    return response['result'] == true;
  }

  Future<bool> allowAllPocket() async {
    final response = await api.postRequest('pocket/allow_all');
    return response['result'] == true;
  }

  Future<bool> denyAllPocket() async {
    final response = await api.postRequest('pocket/deny_all');
    return response['result'] == true;
  }

  Future<void> allowUser(AllowDenyUserRequest request) async {
    await api.postRequest('pocket/allow_user', parameters: {
      'user_id': request.userId.toString(),
    });
  }

  Future<void> denyUser(AllowDenyUserRequest request) async {
    await api.postRequest('pocket/deny_user', parameters: {
      'user_id': request.userId.toString(),
    });
  }

  Future<int> giveTgStars({
    required int userId,
    required int amount,
    String comment = '',
  }) async {
    final response = await api.postRequest('pocket/tgstars/give', parameters: {
      'amount': amount.toString(),
      'user_id': userId.toString(),
      'comment': comment,
    });
    return response['result'];
  }

  Future<List<TgStarsHistoryEntry>> getTgStarsHistory(
    HistoryRequest request,
  ) async {
    final response = await api.getRequest('pocket/tgstars/history', parameters: {
      'offset': request.offset.toString(),
      'limit': request.limit.toString(),
    });

    return _extractResultList(response)
        .whereType<Map<String, dynamic>>()
        .map(TgStarsHistoryEntry.fromJson)
        .toList();
  }

  Future<int> buyTgStars(int amount) async {
    final response = await api.postRequest('pocket/tgstars/buy', parameters: {
      'amount': amount.toString(),
    });
    return response['result'];
  }

  Future<TgStarsPrice> getTgStarsPrice(int amount) async {
    final response = await api.getRequest('pocket/tgstars/price', parameters: {
      'amount': amount.toString(),
    });
    final result = response is Map<String, dynamic>
        ? (response['result'] as Map<String, dynamic>? ?? <String, dynamic>{})
        : <String, dynamic>{};
    return TgStarsPrice.fromJson(result);
  }
}
