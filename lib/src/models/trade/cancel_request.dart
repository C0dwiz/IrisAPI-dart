class CancelPriceRequest {
  final double price;

  CancelPriceRequest({required this.price});

  Map<String, dynamic> toJson() {
    return {
      'price': price,
    };
  }
}

class CancelPartRequest {
  final int id;
  final double volume;

  CancelPartRequest({
    required this.id,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volume': volume,
    };
  }
}
