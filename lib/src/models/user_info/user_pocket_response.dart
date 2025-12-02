class UserPocketResult {
  final Map<String, dynamic> data;

  UserPocketResult({required this.data});

  factory UserPocketResult.fromJson(Map<String, dynamic> json) {
    return UserPocketResult(data: json);
  }
}
