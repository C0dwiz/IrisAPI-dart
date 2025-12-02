import 'package:iris_api/iris_api.dart';

class BuySellResponse {
  final int doneVolume;
  final double sweetsSpent; // для buy
  final double sweetsReceived; // для sell
  final Order? newOrder;

  BuySellResponse({
    required this.doneVolume,
    this.sweetsSpent = 0,
    this.sweetsReceived = 0,
    this.newOrder,
  });

  factory BuySellResponse.fromJson(Map<String, dynamic> json) {
    return BuySellResponse(
      doneVolume: json['done_volume'],
      sweetsSpent: json['sweets_spent']?.toDouble() ?? 0,
      sweetsReceived: json['sweets_received']?.toDouble() ?? 0,
      newOrder:
          json['new_order'] != null ? Order.fromJson(json['new_order']) : null,
    );
  }
}
