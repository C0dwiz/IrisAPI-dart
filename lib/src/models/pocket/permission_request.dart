class AllowDenyUserRequest {
  final int userId;

  AllowDenyUserRequest({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    };
  }
}
