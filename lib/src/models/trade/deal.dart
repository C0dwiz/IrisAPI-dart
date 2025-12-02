class Deal {
  final int id;
  final int groupId;
  final int date;
  final double price;
  final int volume;
  final String type;

  Deal({
    required this.id,
    required this.groupId,
    required this.date,
    required this.price,
    required this.volume,
    required this.type,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'],
      groupId: json['group_id'],
      date: json['date'],
      price: json['price'] is int ? json['price'].toDouble() : json['price'],
      volume: json['volume'],
      type: json['type'],
    );
  }
}
