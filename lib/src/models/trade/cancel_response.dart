class CancelResponse {
  final CancelResult result;

  CancelResponse({required this.result});

  factory CancelResponse.fromJson(Map<String, dynamic> json) {
    return CancelResponse(
      result: CancelResult.fromJson(json['result']),
    );
  }
}

class CancelResult {
  final int gold;
  final double sweets;

  CancelResult({
    required this.gold,
    required this.sweets,
  });

  factory CancelResult.fromJson(Map<String, dynamic> json) {
    return CancelResult(
      gold: json['gold'],
      sweets:
          json['sweets'] is int ? json['sweets'].toDouble() : json['sweets'],
    );
  }
}
