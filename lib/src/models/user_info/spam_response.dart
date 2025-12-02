// models/spam_result.dart
class SpamResult {
  final bool spam;
  final bool ignore;
  final bool scam;

  SpamResult({
    required this.spam,
    required this.ignore,
    required this.scam,
  });

  factory SpamResult.fromJson(Map<String, dynamic> json) {
    return SpamResult(
      spam: json['is_spam'] ?? json['spam'] ?? false,
      ignore: json['is_ignore'] ?? json['ignore'] ?? false,
      scam: json['is_scam'] ?? json['scam'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Spam: $spam, Ignore: $ignore, Scam: $scam';
  }
}
