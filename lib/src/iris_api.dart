import 'dart:convert';

import 'package:http/http.dart' as http;

import 'iris_api_base.dart';
import 'methods/methods.dart';
import 'models/models.dart';
import 'exceptions.dart';

class IrisApi extends IrisApiBase {
  late final PocketMethods pocket;
  late final UserInfoMethods userInfo;
  late final TradeMethods trade;
  late final UpdatesMethods updates;
  late final OtherMethods other;

  IrisApi._({
    required int botId,
    required String irisToken,
    required String apiVersion,
    String baseUrl = "https://iris-tg.ru/api",
    Duration timeout = const Duration(seconds: 30),
    http.Client? client,
  }) : super(
          botId: botId,
          irisToken: irisToken,
          apiVersion: apiVersion,
          baseUrl: baseUrl,
          timeout: timeout,
          client: client,
        ) {
    pocket = PocketMethods(this);
    userInfo = UserInfoMethods(this);
    trade = TradeMethods(this);
    updates = UpdatesMethods(this);
    other = OtherMethods(this);
  }

  static Future<IrisApi> create({
    required int botId,
    required String irisToken,
    String baseUrl = "https://iris-tg.ru/api",
    Duration timeout = const Duration(seconds: 30),
    http.Client? client,
  }) async {
    try {
      final versionClient = client ?? http.Client();

      try {
        final version = await _getLastVersionInternal(
          botId: botId,
          irisToken: irisToken,
          baseUrl: baseUrl,
          timeout: timeout,
          client: versionClient,
        );

        if (client == null) {
          versionClient.close();
        }

        return IrisApi._(
          botId: botId,
          irisToken: irisToken,
          apiVersion: version,
          baseUrl: baseUrl,
          timeout: timeout,
          client: client,
        );
      } catch (e) {
        if (client == null) {
          versionClient.close();
        }
        rethrow;
      }
    } catch (e) {
      return IrisApi._(
        botId: botId,
        irisToken: irisToken,
        apiVersion: '0.3',
        baseUrl: baseUrl,
        timeout: timeout,
        client: client,
      );
    }
  }

  static Future<String> _getLastVersionInternal({
    required int botId,
    required String irisToken,
    required String baseUrl,
    required Duration timeout,
    required http.Client client,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/last_version');
      final response = await client.get(url).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = _decodeResponse(response);
        return data['result'];
      } else {
        throw IrisApiError(
            'Failed to get API version: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw IrisApiError('Failed to get API version: $e');
    }
  }

  static dynamic _decodeResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw IrisApiError('Failed to decode response: $e');
    }
  }

  Future<int> giveSweets({
    required double amount,
    required int userId,
    String? comment,
    bool withoutDonateScore = true,
    int? donateScore,
  }) async {
    return await pocket.giveSweets(
      SweetsGiveRequest(
        userId: userId,
        sweets: amount,
        comment: comment ?? '',
        withoutDonateScore: withoutDonateScore,
        donateScore: donateScore ?? 0,
      ),
      amount: amount,
    );
  }

  Future<int> giveGold({
    required int amount,
    required int userId,
    String? comment,
    bool withoutDonateScore = true,
    int? donateScore,
  }) async {
    return await pocket.giveGold(
      GoldGiveRequest(
        userId: userId,
        gold: amount,
        comment: comment ?? '',
        withoutDonateScore: withoutDonateScore,
        donateScore: donateScore ?? 0,
      ),
      amount: amount,
    );
  }

  Future<int> giveDonateScore({
    required int amount,
    required int userId,
    String? comment,
  }) async {
    return await pocket.giveDonateScore(
      DonateScoreGiveRequest(
        amount: amount,
        userId: userId,
        comment: comment ?? '',
      ),
    );
  }

  Future<Balance> getBalance() async {
    return await pocket.getBalance();
  }

  Future<List<SweetsHistoryEntry>> getSweetsHistory({
    int offset = 0,
  }) async {
    return await pocket.getSweetsHistory(
      HistoryRequest(
        offset: offset,
        limit: 50,
      ),
      limit: 50,
    );
  }

  Future<List<GoldHistoryEntry>> getGoldHistory({
    int offset = 0,
  }) async {
    return await pocket.getGoldHistory(
      HistoryRequest(
        offset: offset,
        limit: 50,
      ),
      limit: 50,
    );
  }

  Future<List<DonateScoreHistoryEntry>> getDonateScoreHistory({
    int offset = 0,
  }) async {
    return await pocket.getDonateScoreHistory(
      HistoryRequest(
        offset: offset,
        limit: 50,
      ),
    );
  }

  Future<bool> enableOrDisablePocket(bool enable) async {
    return enable ? await pocket.enablePocket() : await pocket.disablePocket();
  }

  Future<bool> enableOrDisableAllPocket(bool enable) async {
    return enable
        ? await pocket.allowAllPocket()
        : await pocket.denyAllPocket();
  }

  Future<void> allowOrDenyUserPocket(int userId, bool enable) async {
    if (enable) {
      await pocket.allowUser(AllowDenyUserRequest(userId: userId));
    } else {
      await pocket.denyUser(AllowDenyUserRequest(userId: userId));
    }
  }

  Future<List<UpdateEvent>> getUpdates({
    int offset = 0,
    int limit = 100,
  }) async {
    return await updates.getUpdates(GetUpdatesRequest(
      offset: offset,
      limit: limit,
    ));
  }

  Future<List<int>> getIrisAgents() async {
    return await other.getIrisAgents();
  }

  Future<String> getLastVersion() async {
    return await other.getLastVersion();
  }

  Future<SpamResult> checkUserSpam(int userId) async {
    return await userInfo.checkUserSpam(userId);
  }

  Future<int> checkUserReg(int userId) async {
    return await userInfo.getRegistrationDate(userId);
  }

  Future<ActivityResult> checkUserActivity(int userId) async {
    return await userInfo.getUserActivity(userId);
  }

  Future<int> checkUserStars(int userId) async {
    return await userInfo.getUserStars(userId);
  }

  Future<UserPocketResult> checkUserPocket(int userId) async {
    return await userInfo.getUserPocket(userId);
  }

  Future<BuySellResponse> buyTrade(double price, int volume) async {
    return await trade.buyGold(BuyRequest(
      price: price,
      volume: volume,
    ));
  }

  Future<BuySellResponse> sellTrade(double price, int volume) async {
    return await trade.sellGold(SellRequest(
      price: price,
      volume: volume,
    ));
  }

  Future<OrdersResponse> getOrdersTrade() async {
    return await trade.getMyOrders();
  }

  Future<CancelResult> cancelPriceTrade(double price) async {
    return await trade.cancelByPrice(CancelPriceRequest(
      price: price,
    ));
  }

  Future<CancelResult> cancelAllTrade() async {
    return await trade.cancelAll();
  }

  Future<CancelResult> cancelPartTrade(int id, double volume) async {
    return await trade.cancelPart(CancelPartRequest(
      id: id,
      volume: volume,
    ));
  }

  Future<OrderBook> getOrderBook() async {
    return await trade.getOrderBook();
  }

  String get currentApiVersion => apiVersion;

  String generateDeepLink(Currency currency, int count, [String? comment]) {
    if (count <= 0) {
      throw Exception('Число не может быть нулевым или отрицательным');
    }

    if (comment != null && comment.length > 128) {
      throw Exception(
          'Максимальная длинна комментария не должна превышать 128 символов');
    }

    String url;
    switch (currency) {
      case Currency.gold:
        url = 'https://t.me/iris_black_bot?start=givegold_bot${botId}_$count';
        break;
      case Currency.sweets:
        url = 'https://t.me/iris_black_bot?start=give_bot${botId}_$count';
        break;
      case Currency.donateScore:
        url =
            'https://t.me/iris_black_bot?start=givedonate_score_bot${botId}_$count';
        break;
    }

    if (comment != null) {
      url = '${url}_$comment';
    }
    return url;
  }
}

enum Currency {
  gold,
  sweets,
  donateScore,
}
