class UpdateEvent {
  final int id;
  final String type;
  final int date;
  final Map<String, dynamic> object;

  UpdateEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.object,
  });

  factory UpdateEvent.fromJson(Map<String, dynamic> json) {
    return UpdateEvent(
      id: json['id'],
      type: json['type'],
      date: json['date'],
      object: json['object'],
    );
  }
}
