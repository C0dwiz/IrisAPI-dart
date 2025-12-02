class GetUpdatesRequest {
  final int offset;
  final int limit;

  GetUpdatesRequest({
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
