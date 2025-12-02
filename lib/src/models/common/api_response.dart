class BaseResponse {
  final bool success;
  final String? error;

  BaseResponse({required this.success, this.error});
}

class ResultResponse {
  final int result;

  ResultResponse({required this.result});

  factory ResultResponse.fromJson(Map<String, dynamic> json) {
    return ResultResponse(result: json['result']);
  }
}

class BooleanResultResponse {
  final bool result;

  BooleanResultResponse({required this.result});

  factory BooleanResultResponse.fromJson(Map<String, dynamic> json) {
    return BooleanResultResponse(result: json['result']);
  }
}
