import 'package:iris_api/iris_api.dart';

void main() async {
  final api = IrisAPI(
    botId: "123456",
    irisToken: "test_token",
  );

  try {
    // Получаем баланс
    final balance = await api.balance();
    print('Balance: ${balance.sweets} sweets, ${balance.gold} gold');

    // Передаем 1 конфет пользователю
    await api.giveSweets(1, 7518491974, comment: "На чай!");
    print('Sweets sent successfully!');

    // Получаем историю операций
    final history = await api.sweetsHistory(limit: 10);
    for (var entry in history) {
      print('${entry.datetime}: ${entry.amount} sweets to ${entry.toUserId}');
    }

    // Отслеживаем новые транзакции
    api.trackTransactions().listen((tx) {
      print('New transaction: ${tx.id} - ${tx.amount} sweets');
    });
  } on NotEnoughSweetsError catch (e) {
    print('Error: ${e.message}');
  } on IrisAPIError catch (e) {
    print('API error: $e');
  }
}
