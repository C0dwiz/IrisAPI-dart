class OrdersResponse {
  final List<Order> orders;

  OrdersResponse({required this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    var ordersList = json['orders'] as List;
    List<Order> orders = ordersList.map((i) => Order.fromJson(i)).toList();
    return OrdersResponse(orders: orders);
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((e) => e.toJson()).toList(),
    };
  }
}

class Order {
  final int id;
  final double price;
  final int volume;

  Order({required this.id, required this.price, required this.volume});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      price: json['price'].toDouble(),
      volume: json['volume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'volume': volume,
    };
  }
}
