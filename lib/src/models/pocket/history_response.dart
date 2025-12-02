class SweetsHistoryEntry {
  final int id;
  final double amount;
  final double balance;
  final int date;
  final String type;
  final int peerId;
  final int toUserId;
  final Map<String, dynamic>? details;

  SweetsHistoryEntry({
    required this.id,
    required this.amount,
    required this.balance,
    required this.date,
    required this.type,
    required this.peerId,
    required this.toUserId,
    this.details,
  });

  factory SweetsHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SweetsHistoryEntry(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      amount: (json['amount'] is num
          ? json['amount'].toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0),
      balance: (json['balance'] is num
          ? json['balance'].toDouble()
          : double.tryParse(json['balance'].toString()) ?? 0.0),
      date: json['date'] is int
          ? json['date']
          : int.tryParse(json['date'].toString()) ?? 0,
      type: json['type']?.toString() ?? '',
      peerId: json['peer_id'] is int
          ? json['peer_id']
          : int.tryParse(json['peer_id'].toString()) ?? 0,
      toUserId: json['to_user_id'] is int
          ? json['to_user_id']
          : int.tryParse(json['to_user_id'].toString()) ?? 0,
      details: json['details'] is Map
          ? Map<String, dynamic>.from(json['details'])
          : null,
    );
  }
}

class SweetsHistoryDetails {
  final double total;
  final double amount;
  final double fee;
  final int donateScore;

  SweetsHistoryDetails({
    required this.total,
    required this.amount,
    required this.fee,
    required this.donateScore,
  });

  factory SweetsHistoryDetails.fromJson(Map<String, dynamic> json) {
    return SweetsHistoryDetails(
      total: json['total'] is int ? json['total'].toDouble() : json['total'],
      amount:
          json['amount'] is int ? json['amount'].toDouble() : json['amount'],
      fee: json['fee'] is int ? json['fee'].toDouble() : json['fee'],
      donateScore: json['donate_score'],
    );
  }
}

class GoldHistoryEntry {
  final int id;
  final int amount;

  GoldHistoryEntry({required this.id, required this.amount});

  factory GoldHistoryEntry.fromJson(Map<String, dynamic> json) {
    dynamic amountValue = json['amount'];
    int amountInt;

    if (amountValue is double) {
      amountInt = amountValue.toInt();
    } else if (amountValue is int) {
      amountInt = amountValue;
    } else if (amountValue is String) {
      amountInt = int.tryParse(amountValue) ?? 0;
    } else {
      amountInt = 0;
    }

    return GoldHistoryEntry(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      amount: amountInt,
    );
  }
}

class GoldHistoryDetails {
  final int total;
  final int amount;
  final int fee;
  final int donateScore;

  GoldHistoryDetails({
    required this.total,
    required this.amount,
    required this.fee,
    required this.donateScore,
  });

  factory GoldHistoryDetails.fromJson(Map<String, dynamic> json) {
    return GoldHistoryDetails(
      total: json['total'],
      amount: json['amount'],
      fee: json['fee'],
      donateScore: json['donate_score'],
    );
  }
}

class DonateScoreHistoryEntry {
  final int date;
  final int amount;
  final int balance;
  final int id;
  final String type;
  final int peerId;
  final String comment;

  DonateScoreHistoryEntry({
    required this.date,
    required this.amount,
    required this.balance,
    required this.id,
    required this.type,
    required this.peerId,
    required this.comment,
  });

  factory DonateScoreHistoryEntry.fromJson(Map<String, dynamic> json) {
    return DonateScoreHistoryEntry(
      date: json['date'],
      amount: json['amount'],
      balance: json['balance'],
      id: json['id'],
      type: json['type'],
      peerId: json['peer_id'],
      comment: json['comment'],
    );
  }
}
