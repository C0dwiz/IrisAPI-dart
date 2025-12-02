class IrisApiError implements Exception {
  final String message;
  final int? code;

  IrisApiError(this.message, {this.code});

  @override
  String toString() {
    if (code != null) {
      return 'IrisApiError: $message (code: $code)';
    }
    return 'IrisApiError: $message';
  }
}

class NotEnoughSweetsError extends IrisApiError {
  final double required;

  NotEnoughSweetsError({required this.required})
      : super('Not enough sweets. Need $required');
}

class NotEnoughGoldError extends IrisApiError {
  final int required;

  NotEnoughGoldError({required this.required})
      : super('Not enough gold. Need $required');
}

class UserNotFoundError extends IrisApiError {
  UserNotFoundError() : super('User not found');
}

class FloodControlError extends IrisApiError {
  FloodControlError() : super('Flood control');
}

class TransactionSweetsNotFoundError extends IrisApiError {
  TransactionSweetsNotFoundError(String message) : super(message);
}

class TransactionGoldNotFoundError extends IrisApiError {
  TransactionGoldNotFoundError(String message) : super(message);
}
