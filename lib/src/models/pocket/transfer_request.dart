class SweetsGiveRequest {
  final int userId;
  final double sweets;
  final String comment;
  final bool withoutDonateScore;
  final int donateScore;

  SweetsGiveRequest({
    required this.userId,
    required this.sweets,
    required this.comment,
    required this.withoutDonateScore,
    required this.donateScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'sweets': sweets,
      'comment': comment,
      'without_donate_score': withoutDonateScore,
      'donate_score': donateScore,
    };
  }
}

class GoldGiveRequest {
  final int userId;
  final int gold;
  final String comment;
  final bool withoutDonateScore;
  final int donateScore;

  GoldGiveRequest({
    required this.userId,
    required this.gold,
    required this.comment,
    required this.withoutDonateScore,
    required this.donateScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'gold': gold,
      'comment': comment,
      'without_donate_score': withoutDonateScore,
      'donate_score': donateScore,
    };
  }
}

class DonateScoreGiveRequest {
  final int userId;
  final int amount;
  final String comment;

  DonateScoreGiveRequest({
    required this.userId,
    required this.amount,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'comment': comment,
    };
  }
}
