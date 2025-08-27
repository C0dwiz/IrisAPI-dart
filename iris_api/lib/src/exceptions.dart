class IrisAPIError implements Exception {
  final String message;
  IrisAPIError(this.message);

  @override
  String toString() => 'IrisAPIError: $message';
}

class AuthorizationError extends IrisAPIError {
  AuthorizationError(super.message);
}

class RateLimitError extends IrisAPIError {
  RateLimitError(super.message);
}

class InvalidRequestError extends IrisAPIError {
  InvalidRequestError(super.message);
}

class NotEnoughSweetsError extends IrisAPIError {
  final double required;
  NotEnoughSweetsError({required this.required})
      : super(
            'Not enough sweets. Need ${required == required.truncate() ? required.truncate() : required}');
}

class NotEnoughGoldError extends IrisAPIError {
  final double required;
  NotEnoughGoldError({required this.required})
      : super(
            'Not enough gold. Need ${required == required.truncate() ? required.truncate() : required}');
}

class TransactionSweetsNotFoundError extends IrisAPIError {
  TransactionSweetsNotFoundError(super.message);
}

class TransactionGoldNotFoundError extends IrisAPIError {
  TransactionGoldNotFoundError(super.message);
}