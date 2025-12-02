class RegResponse {
  final int result;

  RegResponse({required this.result});

  factory RegResponse.fromJson(Map<String, dynamic> json) {
    return RegResponse(result: json['result']);
  }
}
