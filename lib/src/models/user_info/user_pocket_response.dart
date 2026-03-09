class UserPocketResult {
  final int gold;
  final int coins;
  final double sweets;
  final int stars;
  final int tgstars;

  UserPocketResult({
    required this.gold,
    required this.coins,
    required this.sweets,
    required this.stars,
    required this.tgstars,
  });

  factory UserPocketResult.fromJson(Map<String, dynamic> json) {
    return UserPocketResult(
      gold: json['gold'] is int ? json['gold'] as int : 0,
      coins: json['coins'] is int ? json['coins'] as int : 0,
      sweets: json['sweets'] is num ? (json['sweets'] as num).toDouble() : 0,
      stars: json['stars'] is int ? json['stars'] as int : 0,
      tgstars: json['tgstars'] is int ? json['tgstars'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gold': gold,
      'coins': coins,
      'sweets': sweets,
      'stars': stars,
      'tgstars': tgstars,
    };
  }
}
