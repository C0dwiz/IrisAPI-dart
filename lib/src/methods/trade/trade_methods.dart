import 'package:iris_api/iris_api.dart';

class TradeMethods {
  final IrisApiBase api;

  TradeMethods(this.api);

  Future<BuySellResponse> buyGold(BuyRequest request) async {
    final response = await api.getRequest('trade/buy', parameters: {
      'price': request.price.toString(),
      'volume': request.volume.toString(),
    });
    return BuySellResponse.fromJson(response['result']);
  }

  Future<BuySellResponse> sellGold(SellRequest request) async {
    final response = await api.getRequest('trade/sell', parameters: {
      'price': request.price.toString(),
      'volume': request.volume.toString(),
    });
    return BuySellResponse.fromJson(response['result']);
  }

  Future<CancelResult> cancelByPrice(CancelPriceRequest request) async {
    final response = await api.getRequest('trade/cancel_price', parameters: {
      'price': request.price.toString(),
    });
    return CancelResult.fromJson(response['result']);
  }

  Future<CancelResult> cancelAll() async {
    final response = await api.getRequest('trade/cancel_all');
    return CancelResult.fromJson(response['result']);
  }

  Future<CancelResult> cancelPart(CancelPartRequest request) async {
    final response = await api.getRequest('trade/cancel_part', parameters: {
      'id': request.id.toString(),
      'volume': request.volume.toString(),
    });
    return CancelResult.fromJson(response['result']);
  }

  Future<List<Deal>> getDeals({int? fromId, int? limit}) async {
    final params = <String, String>{
      if (fromId != null) 'id': fromId.toString(),
      if (limit != null) 'limit': limit.toString(),
    };
    final response = await api.getRequest('trade/deals', parameters: params);
    final result = response is Map<String, dynamic>
        ? (response['result'] as List<dynamic>? ?? <dynamic>[])
        : <dynamic>[];
    return result
        .whereType<Map<String, dynamic>>()
        .map(Deal.fromJson)
        .toList();
  }

  Future<OrderBook> getOrderBook() async {
    final response = await api.getRequest('trade/orderbook');
    final result = response is Map<String, dynamic>
        ? (response['result'] as Map<String, dynamic>? ?? <String, dynamic>{})
        : <String, dynamic>{};
    return OrderBook.fromJson(result);
  }

  @Deprecated('trade/my_orders is not present in API v0.5')
  Future<OrdersResponse> getMyOrders() async {
    return OrdersResponse(orders: []);
  }
}
