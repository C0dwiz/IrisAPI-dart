class Balance {
  final int gold;
  final double sweets;
  final int donateScore;

  Balance({
    required this.gold,
    required this.sweets,
    required this.donateScore,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      gold: json['gold'],
      sweets:
          json['sweets'] is int ? json['sweets'].toDouble() : json['sweets'],
      donateScore: json['donate_score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gold': gold,
      'sweets': sweets,
      'donate_score': donateScore,
    };
  }

  @override
  String toString() {
    return 'Balance(gold: $gold, sweets: $sweets, donateScore: $donateScore)';
  }
}
