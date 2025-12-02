class BuyRequest {
  final double price;
  final int volume;

  BuyRequest({
    required this.price,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'volume': volume,
    };
  }
}

class SellRequest {
  final double price;
  final int volume;

  SellRequest({
    required this.price,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'volume': volume,
    };
  }
}
