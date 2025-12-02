class StarsResponse {
  final int result;

  StarsResponse({required this.result});

  factory StarsResponse.fromJson(Map<String, dynamic> json) {
    return StarsResponse(result: json['result']);
  }
}
