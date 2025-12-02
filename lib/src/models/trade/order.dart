class Order {
  final int volume;
  final double price;
  final int id;

  Order({
    required this.volume,
    required this.price,
    required this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      volume: json['volume'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
      id: json['id'],
    );
  }
}
