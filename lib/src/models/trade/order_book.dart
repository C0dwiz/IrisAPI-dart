import 'trade_order.dart';

class OrderBook {
  final List<TradeOrder> buy;
  final List<TradeOrder> sell;

  OrderBook({
    required this.buy,
    required this.sell,
  });

  factory OrderBook.fromJson(Map<String, dynamic> json) {
    return OrderBook(
      buy: (json['buy'] as List).map((e) => TradeOrder.fromJson(e)).toList(),
      sell: (json['sell'] as List).map((e) => TradeOrder.fromJson(e)).toList(),
    );
  }
}
