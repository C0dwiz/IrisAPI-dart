# Iris API Dart Client

[![Pub Version](https://img.shields.io/pub/v/iris_api?logo=dart)](https://pub.dev/packages/iris_api)
[![Lints](https://img.shields.io/badge/lints-recommended-brightgreen.svg)](https://dart.dev/lints)

Неофициальный, надежный и простой в использовании клиент на Dart для **Iris API**. Этот пакет позволяет вам взаимодействовать с системой внутриигровой валюты Iris (ириски и золото) прямо из ваших Dart или Flutter приложений.

**ВАЖНО:** Версия 2.0.0 содержит критические изменения, связанные с переходом на версионирование Iris API.

## Новое в v2.0.0

- **Поддержка версионирования API:** В конструктор добавлен параметр `apiVersion` (по умолчанию `'0.1'`).
- **Новые методы:**
  - `getUpdates()`: Получает объединенный лог транзакций по ирискам и золоту.
  - `getLatestApiVersion()`: Возвращает последнюю стабильную версию API.
  - `getOrderBook()`: Получает стакан ордеров с биржи.
  - `getTradeDeals()`: Получает последние сделки с биржи.
- **Обновленные модели:** Модели истории транзакций полностью переработаны в соответствии с новым форматом API.
- **Улучшенное отслеживание:** Метод `trackTransactions()` теперь использует `getUpdates()` для большей эффективности и отслеживает и золото, и ириски.

## Features

*   **Управление балансом:** Проверяйте текущий баланс ирисок и золота вашего бота.
*   **Переводы валюты:** Отправляйте ириски и золото пользователям.
*   **История транзакций:** Получайте историю транзакций.
*   **Отслеживание в реальном времени:** Мониторьте новые транзакции с помощью `Stream`.
*   **Торговые данные:** Получайте информацию о сделках и ордерах.
*   **Обработка ошибок:** Включает набор пользовательских исключений для распространенных ошибок API.

## Getting started

Добавьте эту зависимость в файл `pubspec.yaml` вашего проекта:

```yaml
dependencies:
  iris_api: ^2.0.0 # Убедитесь, что используете последнюю версию
```

Затем выполните `dart pub get` или `flutter pub get`.

## Usage

### 1. Инициализация клиента

Вы можете указать версию API при инициализации. Рекомендуется использовать актуальную версию.

```dart
import 'package:iris_api/iris_api.dart';

void main() {
  final api = IrisAPI(
    botId: 'YOUR_BOT_ID',
    irisToken: 'YOUR_IRIS_TOKEN',
    apiVersion: '0.1', // Рекомендуется указывать актуальную версию
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
  print(e); // "IrisAPIError: Not enough sweets. Need 10.5"
} on IrisAPIError catch (e) {
  print('Произошла ошибка API: $e');
}
```

### 4. Отслеживание новых транзакций

Слушайте поток, чтобы получать обновления о новых транзакциях в реальном времени. Поток теперь возвращает `HistorySweetsEntry` или `HistoryGoldEntry`.

```dart
final transactionStream = api.trackTransactions();

await for (final transaction in transactionStream) {
  if (transaction is HistorySweetsEntry) {
    print('Новая транзакция (ириски)!');
  } else if (transaction is HistoryGoldEntry) {
    print('Новая транзакция (золото)!');
  }
  print('ID: ${transaction.id}');
  print('Сумма: ${transaction.amount}');
  print('Пользователю: ${transaction.peerId}');
  print('Дата: ${transaction.datetime}');
}
```
