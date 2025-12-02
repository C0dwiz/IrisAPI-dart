class TradeOrder {
  final int volume;
  final double price;

  TradeOrder({
    required this.volume,
    required this.price,
  });

  factory TradeOrder.fromJson(Map<String, dynamic> json) {
    return TradeOrder(
      volume: json['volume'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
    );
  }
}
