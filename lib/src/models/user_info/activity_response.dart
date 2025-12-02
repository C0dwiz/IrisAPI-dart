class ActivityResult {
  final Map<String, dynamic> data;

  ActivityResult({required this.data});

  factory ActivityResult.fromJson(Map<String, dynamic> json) {
    return ActivityResult(data: json);
  }
}
