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
}

class TransactionDetails {
  final double total;
  final double amount;
  final int? donateScore;
  final double? fee;

  TransactionDetails({
    required this.total,
    required this.amount,
    this.donateScore,
    this.fee,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      total: _toDouble(json['total']),
      amount: _toDouble(json['amount']),
      donateScore: json['donate_score'] as int?,
      fee: _toDouble(json['fee']),
    );
  }
}

abstract class BaseHistoryEntry {
  final int id;
  final int date;
  final double amount;
  final double balance;
  final int peerId;
  final String type;
  final TransactionDetails details;
  final String? comment;
  final Map<String, dynamic>? metadata;

  BaseHistoryEntry({
    required this.id,
    required this.date,
    required this.amount,
    required this.balance,
    required this.peerId,
    required this.type,
    required this.details,
    this.comment,
    this.metadata,
  });

  DateTime get datetime => DateTime.fromMillisecondsSinceEpoch(date);
}

class HistorySweetsEntry extends BaseHistoryEntry {
  HistorySweetsEntry({
    required super.id,
    required super.date,
    required super.amount,
    required super.balance,
    required super.peerId,
    required super.type,
    required super.details,
    super.comment,
    super.metadata,
  });

  factory HistorySweetsEntry.fromJson(Map<String, dynamic> json) {
    return HistorySweetsEntry(
      id: json['id'] as int,
      date: json['date'] as int,
      amount: _toDouble(json['amount']),
      balance: _toDouble(json['balance']),
      peerId: json['peer_id'] as int,
      type: json['type'] as String,
      details: TransactionDetails.fromJson(json['details']),
      comment: json['comment'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

class HistoryGoldEntry extends BaseHistoryEntry {
  HistoryGoldEntry({
    required super.id,
    required super.date,
    required super.amount,
    required super.balance,
    required super.peerId,
    required super.type,
    required super.details,
    super.comment,
    super.metadata,
  });

  factory HistoryGoldEntry.fromJson(Map<String, dynamic> json) {
    return HistoryGoldEntry(
      id: json['id'] as int,
      date: json['date'] as int,
      amount: _toDouble(json['amount']),
      balance: _toDouble(json['balance']),
      peerId: json['peer_id'] as int,
      type: json['type'] as String,
      details: TransactionDetails.fromJson(json['details']),
      comment: json['comment'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

class UpdateEvent {
  final int id;
  final String type;
  final int date;
  final dynamic object;

  UpdateEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.object,
  });

  DateTime get datetime => DateTime.fromMillisecondsSinceEpoch(date * 1000);

  factory UpdateEvent.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    dynamic object;
    if (type == 'sweets_log') {
      object = HistorySweetsEntry.fromJson(json['object']);
    } else if (type == 'gold_log') {
      object = HistoryGoldEntry.fromJson(json['object']);
    } else {
      object = json['object'];
    }

    return UpdateEvent(
      id: json['id'] as int,
      type: type,
      date: json['date'] as int,
      object: object,
    );
  }
}

class TradeOrder {
  final int volume;
  final double price;

  TradeOrder({required this.volume, required this.price});

  factory TradeOrder.fromJson(Map<String, dynamic> json) {
    return TradeOrder(
      volume: json['volume'] as int,
      price: _toDouble(json['price']),
    );
  }
}

class OrderBook {
  final List<TradeOrder> buy;
  final List<TradeOrder> sell;

  OrderBook({required this.buy, required this.sell});

  factory OrderBook.fromJson(Map<String, dynamic> json) {
    return OrderBook(
      buy: (json['buy'] as List)
          .map((i) => TradeOrder.fromJson(i))
          .toList(),
      sell: (json['sell'] as List)
          .map((i) => TradeOrder.fromJson(i))
          .toList(),
    );
  }
}

class TradeDeal {
  final int id;
  final int groupId;
  final double date;
  final int volume;
  final String type;

  TradeDeal({
    required this.id,
    required this.groupId,
    required this.date,
    required this.volume,
    required this.type,
  });

  DateTime get datetime => DateTime.fromMillisecondsSinceEpoch((date * 1000).toInt());

  factory TradeDeal.fromJson(Map<String, dynamic> json) {
    return TradeDeal(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      date: _toDouble(json['date']),
      volume: json['volume'] as int,
      type: json['type'] as String,
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  return value is double ? value : double.tryParse(value.toString()) ?? 0.0;
}