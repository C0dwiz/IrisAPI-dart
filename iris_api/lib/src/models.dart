class Balance {
  final double gold;
  final double sweets;
  final double donateScore;
  final double available;

  Balance({
    required this.gold,
    required this.sweets,
    required this.donateScore,
    double? available,
  }) : available = available ?? sweets;

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      gold: _toDouble(json['gold']),
      sweets: _toDouble(json['sweets']),
      donateScore: _toDouble(json['donate_score']),
      available: _toDouble(json['available']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return value is double ? value : double.tryParse(value.toString()) ?? 0.0;
  }
}

class TransactionInfo {
  final int? donateScore;
  final double? commission;

  TransactionInfo({this.donateScore, this.commission});

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
      donateScore: json['donateScore'] as int?,
      commission: json['commission']?.toDouble(),
    );
  }
}

class TransactionSweetsInfo extends TransactionInfo {
  final double? sweets;

  TransactionSweetsInfo({this.sweets, super.donateScore, super.commission});

  factory TransactionSweetsInfo.fromJson(Map<String, dynamic> json) {
    return TransactionSweetsInfo(
      sweets: json['sweets']?.toDouble(),
      donateScore: json['donateScore'] as int?,
      commission: json['commission']?.toDouble(),
    );
  }
}

class TransactionGoldInfo extends TransactionInfo {
  final double? gold;

  TransactionGoldInfo({this.gold, super.donateScore, super.commission});

  factory TransactionGoldInfo.fromJson(Map<String, dynamic> json) {
    return TransactionGoldInfo(
      gold: json['gold']?.toDouble(),
      donateScore: json['donateScore'] as int?,
      commission: json['commission']?.toDouble(),
    );
  }
}

abstract class BaseHistoryEntry {
  final int id;
  final int date;
  final double amount;
  final double balance;
  final int toUserId;
  final String type;

  BaseHistoryEntry({
    required this.id,
    required this.date,
    required this.amount,
    required this.balance,
    required this.toUserId,
    required this.type,
  });

  DateTime get datetime => DateTime.fromMillisecondsSinceEpoch(date * 1000);
}

class HistorySweetsEntry extends BaseHistoryEntry {
  final TransactionSweetsInfo info;

  HistorySweetsEntry({
    required super.id,
    required super.date,
    required super.amount,
    required super.balance,
    required super.toUserId,
    required super.type,
    required this.info,
  });

  factory HistorySweetsEntry.fromJson(Map<String, dynamic> json) {
    return HistorySweetsEntry(
      id: json['id'] as int,
      date: json['date'] as int,
      amount: json['amount'] is double
          ? json['amount']
          : double.parse(json['amount'].toString()),
      balance: json['balance'] is double
          ? json['balance']
          : double.parse(json['balance'].toString()),
      toUserId: json['to_user_id'] as int,
      type: json['type'] as String,
      info: TransactionSweetsInfo.fromJson(json['info']),
    );
  }
}

class HistoryGoldEntry extends BaseHistoryEntry {
  final TransactionGoldInfo info;

  HistoryGoldEntry({
    required super.id,
    required super.date,
    required super.amount,
    required super.balance,
    required super.toUserId,
    required super.type,
    required this.info,
  });

  factory HistoryGoldEntry.fromJson(Map<String, dynamic> json) {
    return HistoryGoldEntry(
      id: json['id'] as int,
      date: json['date'] as int,
      amount: json['amount'] is double
          ? json['amount']
          : double.parse(json['amount'].toString()),
      balance: json['balance'] is double
          ? json['balance']
          : double.parse(json['balance'].toString()),
      toUserId: json['to_user_id'] as int,
      type: json['type'] as String,
      info: TransactionGoldInfo.fromJson(json['info']),
    );
  }
}
