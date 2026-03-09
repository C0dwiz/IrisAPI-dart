class Balance {
  final int gold;
  final double sweets;
  final int donateScore;
  final int tgstars;

  Balance({
    required this.gold,
    required this.sweets,
    required this.donateScore,
    required this.tgstars,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      gold: json['gold'] is int ? json['gold'] as int : 0,
      sweets: json['sweets'] is num ? (json['sweets'] as num).toDouble() : 0,
      donateScore: json['donate_score'] is int ? json['donate_score'] as int : 0,
      tgstars: json['tgstars'] is int ? json['tgstars'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gold': gold,
      'sweets': sweets,
      'donate_score': donateScore,
      'tgstars': tgstars,
    };
  }

  @override
  String toString() {
    return 'Balance(gold: $gold, sweets: $sweets, donateScore: $donateScore, tgstars: $tgstars)';
  }
}
