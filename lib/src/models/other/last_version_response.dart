class LastVersionResponse {
  final String result;

  LastVersionResponse({required this.result});

  factory LastVersionResponse.fromJson(Map<String, dynamic> json) {
    return LastVersionResponse(result: json['result']);
  }
}
