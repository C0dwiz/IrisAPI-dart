[![Pub Version](https://img.shields.io/pub/v/iris_api?logo=dart)](https://pub.dev/packages/iris_api)
[![Lints](https://img.shields.io/badge/lints-recommended-brightgreen.svg)](https://dart.dev/lints)

Неофициальный, надежный и простой в использовании клиент на Dart для **Iris API**. Этот пакет позволяет вам взаимодействовать с системой внутриигровой валюты Iris (ириски и золото) прямо из ваших Dart или Flutter приложений.

## Features

*   **Управление балансом:** Проверяйте текущий баланс ирисок и золота вашего бота.
*   **Переводы валюты:** Отправляйте ириски и золото пользователям.
*   **История транзакций:** Получайте историю транзакций как по золоту, так и по ирискам.
*   **Отслеживание в реальном времени:** Мониторьте новые транзакции по мере их поступления с помощью удобного `Stream`.
*   **Обработка ошибок:** Включает набор пользовательских исключений для распространенных ошибок API (например, `NotEnoughSweetsError`, `AuthorizationError`).
*   **Управление разрешениями:** Управляйте, какие пользователи могут получать переводы.

## Getting started

Добавьте эту зависимость в файл `pubspec.yaml` вашего проекта:

```yaml
dependencies:
  iris_api: ^1.0.0 # Замените на последнюю версию
```

Затем выполните `dart pub get` или `flutter pub get`.

## Usage

### 1. Инициализация клиента

```dart
import 'package:iris_api/iris_api.dart';

void main() {
  final api = IrisAPI(
    botId: 'YOUR_BOT_ID',
    irisToken: 'YOUR_IRIS_TOKEN',
  );
  // ... используйте api
}
```

### 2. Проверка баланса

```dart
try {
  final balance = await api.balance();
  print('Ириски: ${balance.sweets}, Золото: ${balance.gold}');
} on IrisAPIError catch (e) {
  print('Произошла ошибка API: $e');
}
```

### 3. Перевод ирисок

```dart
try {
  const userId = 123456789; // ID целевого пользователя
  const amount = 10.5;
  final success = await api.giveSweets(amount, userId, comment: 'Вот немного ирисок!');
  if (success) {
    print('Успешно отправлено $amount ирисок пользователю $userId.');
  }
} on NotEnoughSweetsError catch (e) {
  print(e); // "IrisAPIError: Not enough sweets. Required: 10.5"
} on IrisAPIError catch (e) {
  print('Произошла ошибка API: $e');
}
```

### 4. Отслеживание новых транзакций

Слушайте поток, чтобы получать обновления о новых транзакциях в реальном времени.

```dart
final transactionStream = api.trackTransactions(
  pollInterval: const Duration(seconds: 2),
);

await for (final transaction in transactionStream) {
  print('Найдена новая транзакция!');
  print('ID: ${transaction.id}');
  print('Сумма: ${transaction.amount}');
  print('Пользователю: ${transaction.toUserId}');
  print('Дата: ${transaction.datetime}');
}
```
