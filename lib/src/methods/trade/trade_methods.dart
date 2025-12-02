import 'package:iris_api/iris_api.dart';

class TradeMethods {
  final IrisApiBase api;

  TradeMethods(this.api);

  Future<BuySellResponse> buyGold(BuyRequest request) async {
    final response = await api.getRequest('trade/buy', parameters: {
      'price': request.price.toString(),
      'volume': request.volume.toString(),
    });
    return BuySellResponse.fromJson(response);
  }

  Future<BuySellResponse> sellGold(SellRequest request) async {
    final response = await api.getRequest('trade/sell', parameters: {
      'price': request.price.toString(),
      'volume': request.volume.toString(),
    });
    return BuySellResponse.fromJson(response);
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

  Future<List<Deal>> getDeals({int? fromId}) async {
    final params = fromId != null ? {'id': fromId.toString()} : null;
    final response = await api.getRequest('trade/deals', parameters: params);
    return (response as List).map((e) => Deal.fromJson(e)).toList();
  }

  Future<OrderBook> getOrderBook() async {
    try {
      final response = await api.getRequest('trade/book');

      if (response == null) {
        return OrderBook(buy: [], sell: []);
      }

      return OrderBook.fromJson(response);
    } catch (e) {
      print('Error in getOrderBook: $e');
      return OrderBook(buy: [], sell: []);
    }
  }

  Future<OrdersResponse> getMyOrders() async {
    try {
      final response = await api.getRequest('trade/my_orders');

      if (response == null) {
        return OrdersResponse(orders: []);
      }

      if (response is Map<String, dynamic>) {
        return OrdersResponse.fromJson(response);
      } else if (response is List) {
        return OrdersResponse(
            orders: response.map((e) => Order.fromJson(e)).toList());
      }

      return OrdersResponse(orders: []);
    } catch (e) {
      print('Error in getMyOrders: $e');
      return OrdersResponse(orders: []);
    }
  }
}
