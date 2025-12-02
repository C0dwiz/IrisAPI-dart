class HistoryRequest {
  final int offset;
  final int limit;

  HistoryRequest({
    required this.offset,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'limit': limit,
    };
  }
}
