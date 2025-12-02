import 'package:iris_api/iris_api.dart';

class PocketMethods {
  final IrisApiBase api;

  PocketMethods(this.api);

  Future<Balance> getBalance() async {
    final response = await api.getRequest('pocket/balance');
    return Balance.fromJson(response);
  }

  Future<int> giveSweets(
    SweetsGiveRequest request, {
    required double amount,
  }) async {
    final response = await api.postRequest('pocket/sweets/give', parameters: {
      'sweets': amount.toString(),
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
      'gold': amount.toString(),
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
    try {
      final response =
          await api.getRequest('pocket/sweets/history', parameters: {
        'offset': request.offset.toString(),
      });

      if (response is List) {
        return response.map((e) => SweetsHistoryEntry.fromJson(e)).toList();
      }

      if (response is Map<String, dynamic>) {
        if (response.containsKey('result') && response['result'] is List) {
          return (response['result'] as List)
              .map((e) => SweetsHistoryEntry.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error in getSweetsHistory: $e');
      return [];
    }
  }

  Future<List<GoldHistoryEntry>> getGoldHistory(
    HistoryRequest request, {
    required int limit,
  }) async {
    try {
      final response = await api.getRequest('pocket/gold/history', parameters: {
        'offset': request.offset.toString(),
      });

      if (response is List) {
        return response.map((e) => GoldHistoryEntry.fromJson(e)).toList();
      }

      if (response is Map<String, dynamic>) {
        if (response.containsKey('result') && response['result'] is List) {
          return (response['result'] as List)
              .map((e) => GoldHistoryEntry.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error in getGoldHistory: $e');
      return [];
    }
  }

  Future<List<DonateScoreHistoryEntry>> getDonateScoreHistory(
      HistoryRequest request) async {
    try {
      final response =
          await api.getRequest('pocket/donate_score/history', parameters: {
        'offset': request.offset.toString(),
      });

      if (response == null) return [];
      if (response is Map<String, dynamic>) {
        if (response.containsKey('result')) {
          final result = response['result'];
          if (result is List) {
            return result
                .map((e) => DonateScoreHistoryEntry.fromJson(e))
                .toList();
          }
        }
        return [];
      } else if (response is List) {
        return response
            .map((e) => DonateScoreHistoryEntry.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error in getDonateScoreHistory: $e');
      return [];
    }
  }

  Future<bool> enablePocket() async {
    try {
      final response = await api.postRequest('pocket/enable');
      return response['result'] == 1;
    } catch (e) {
      print('Error in enablePocket: $e');
      return false;
    }
  }

  Future<bool> disablePocket() async {
    try {
      final response = await api.postRequest('pocket/disable');
      return response['result'] == 1;
    } catch (e) {
      print('Error in disablePocket: $e');
      return false;
    }
  }

  Future<bool> allowAllPocket() async {
    try {
      final response = await api.postRequest('pocket/allow_all');
      return response['result'] == 1;
    } catch (e) {
      print('Error in allowAllPocket: $e');
      return false;
    }
  }

  Future<bool> denyAllPocket() async {
    try {
      final response = await api.postRequest('pocket/deny_all');
      return response['result'] == 1;
    } catch (e) {
      print('Error in denyAllPocket: $e');
      return false;
    }
  }

  Future<void> allowUser(AllowDenyUserRequest request) async {
    try {
      await api.postRequest('pocket/allow_user', parameters: {
        'user_id': request.userId.toString(),
      });
    } catch (e) {
      print('Error in allowUser: $e');
      rethrow;
    }
  }

  Future<void> denyUser(AllowDenyUserRequest request) async {
    try {
      await api.postRequest('pocket/deny_user', parameters: {
        'user_id': request.userId.toString(),
      });
    } catch (e) {
      print('Error in denyUser: $e');
      rethrow;
    }
  }
}
