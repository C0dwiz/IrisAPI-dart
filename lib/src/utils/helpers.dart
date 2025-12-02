class IrisHelpers {
  static DateTime timestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static String formatCurrency(double amount, {int decimalPlaces = 2}) {
    return amount.toStringAsFixed(decimalPlaces);
  }

  static bool isValidUserId(int userId) {
    return userId > 0;
  }

  static void validateAmount(double amount, {String currency = 'sweets'}) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than 0 for $currency');
    }
  }
}
