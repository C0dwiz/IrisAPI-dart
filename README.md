# Iris API Dart Client

[![Pub Version](https://img.shields.io/pub/v/iris_api?logo=dart)](https://pub.dev/packages/iris_api)
[![Lints](https://img.shields.io/badge/lints-recommended-brightgreen.svg)](https://dart.dev/lints)

**Неофициальный клиент на Dart для работы с Iris API** — надежный, современный и простой в использовании. Полностью переработанная версия с поддержкой всех возможностей Iris API.

## 🚀 Новая архитектура v2.0.0

### **Автоматическое определение версии API**
Клиент теперь автоматически определяет актуальную версию API при инициализации:

```dart
// Старый способ (устарел)
final api = IrisApi(
  botId: 123,
  irisToken: 'abc',
  apiVersion: '0.3', // ← Нужно было помнить версию
);

// Новый способ (рекомендуется)
final api = await IrisApi.create(
  botId: 123,
  irisToken: 'abc', // ← Версия определяется автоматически!
);

print(api.currentApiVersion); // "0.3" - всегда актуальная версия
```

### **Полный набор методов API**
Поддерживаются все возможности Iris API через специализированные классы:

- **PocketMethods** - операции с кошельком
- **UserInfoMethods** - информация о пользователях
- **TradeMethods** - торговая биржа
- **UpdatesMethods** - получение обновлений
- **OtherMethods** - вспомогательные методы

## 📦 Установка

Добавьте зависимость в `pubspec.yaml`:

```yaml
dependencies:
  iris_api: ^2.0.0
```

Затем выполните:
```bash
dart pub get
# или
flutter pub get
```

## 🎯 Быстрый старт

### 1. Инициализация клиента

```dart
import 'package:iris_api/iris_api.dart';

void main() async {
  // Автоматическое определение версии API
  final api = await IrisApi.create(
    botId: YOUR_BOT_ID,
    irisToken: 'YOUR_IRIS_TOKEN',
  );
  
  print('API версия: ${api.currentApiVersion}');
}
```

### 2. Проверка баланса

```dart
final balance = await api.getBalance();
print('💰 Баланс:');
print('   Ириски: ${balance.sweets}');
print('   Голда: ${balance.gold}');
print('   Донат-очки: ${balance.donateScore}');
```

### 3. Перевод валюты

```dart
// Отправить ириски
await api.giveSweets(
  amount: 10.5,
  userId: 123456789,
  comment: 'Спасибо за помощь!',
);

// Отправить голду
await api.giveGold(
  amount: 5,
  userId: 123456789,
  comment: 'На развитие',
);

// Отправить донат-очки
await api.giveDonateScore(
  amount: 1,
  userId: 123456789,
  comment: 'За донат',
);
```

### 4. Информация о пользователях

```dart
const userId = 123456789;

// Проверить на спам
final spamInfo = await api.checkUserSpam(userId);
print('Спам: ${spamInfo.spam}, Игнор: ${spamInfo.ignore}, Скам: ${spamInfo.scam}');

// Дата регистрации
final regDate = await api.checkUserReg(userId);
print('Дата регистрации: $regDate');

// Активность
final activity = await api.checkUserActivity(userId);
print('Данные активности: $activity');

// Звездность
final stars = await api.checkUserStars(userId);
print('Звезд: $stars');

// Мешок пользователя
final pocket = await api.checkUserPocket(userId);
print('Информация о мешке: $pocket');
```

## 📊 Торговые операции

```dart
// Получить стакан заявок
final orderBook = await api.getOrderBook();
print('Заявки на покупку: ${orderBook.buy.length}');
print('Заявки на продажу: ${orderBook.sell.length}');

// Купить голду
await api.buyTrade(price: 0.5, volume: 10);

// Продать голду
await api.sellTrade(price: 0.5, volume: 10);

// Мои заявки
final orders = await api.getOrdersTrade();
print('Активных заявок: ${orders.orders.length}');

// Отменить заявки
await api.cancelPriceTrade(price: 0.5);  // По цене
await api.cancelAllTrade();               // Все заявки
await api.cancelPartTrade(id: 1, volume: 5); // Часть заявки
```

## 🔄 История операций

```dart
// История ирисок
final sweetsHistory = await api.getSweetsHistory();
print('Записей в истории ирисок: ${sweetsHistory.length}');

// История голды
final goldHistory = await api.getGoldHistory();
print('Записей в истории голды: ${goldHistory.length}');

// История донат-очков
final donateHistory = await api.getDonateScoreHistory();
print('Записей в истории донат-очков: ${donateHistory.length}');
```

## 📱 Дополнительные возможности

### Получение обновлений

```dart
final updates = await api.getUpdates(limit: 50);
print('Получено обновлений: ${updates.length}');
```

### Список агентов Iris

```dart
final agents = await api.getIrisAgents();
print('Агентов Iris: ${agents.length}');
```

### Генерация deep-ссылок

```dart
// Создать ссылку для перевода голды
final goldLink = api.generateDeepLink(Currency.gold, 10, 'на подарок');
print('Ссылка для перевода: $goldLink');

// Ссылка для ирисок
final sweetsLink = api.generateDeepLink(Currency.sweets, 5);
print('Ссылка для ирисок: $sweetsLink');
```

### Управление доступом к кошельку

```dart
// Включить/выключить кошелек
await api.enableOrDisablePocket(true);

// Разрешить/запретить всем
await api.enableOrDisableAllPocket(true);

// Разрешить/запретить конкретному пользователю
await api.allowOrDenyUserPocket(123456789, true);
```

## 🛡️ Обработка ошибок

Клиент включает расширенную систему обработки ошибок:

```dart
try {
  await api.giveSweets(amount: 10, userId: 123456789);
} on IrisApiError catch (e) {
  if (e.code == 429) {
    print('⚠️ Слишком много запросов. Добавьте задержку.');
    await Future.delayed(Duration(seconds: 3));
  } else {
    print('❌ Ошибка API: ${e.code} - ${e.message}');
  }
} catch (e) {
  print('❌ Неожиданная ошибка: $e');
}
```

## ⚡ Оптимизация запросов

Для избежания ограничений API используйте задержки:

```dart
// Создание клиента с увеличенным таймаутом
final api = await IrisApi.create(
  botId: YOUR_BOT_ID,
  irisToken: 'YOUR_IRIS_TOKEN',
  timeout: Duration(seconds: 10),
);

// Рекомендуемая задержка между запросами
await Future.delayed(Duration(seconds: 2));
```

## 📖 Полный список методов

### PocketMethods
- `getBalance()` - баланс кошелька
- `giveSweets()` - отправить ириски
- `giveGold()` - отправить голду
- `giveDonateScore()` - отправить донат-очки
- `getSweetsHistory()` - история ирисок
- `getGoldHistory()` - история голды
- `getDonateScoreHistory()` - история донат-очков
- `enablePocket()/disablePocket()` - включить/выключить кошелек
- `allowAllPocket()/denyAllPocket()` - разрешить/запретить всем
- `allowUser()/denyUser()` - разрешить/запретить пользователю

### UserInfoMethods
- `checkUserSpam()` - проверка на спам/скам
- `getRegistrationDate()` - дата регистрации
- `getUserActivity()` - статистика активности
- `getUserStars()` - звездность
- `getUserPocket()` - содержимое мешка

### TradeMethods
- `buyGold()` - купить голду
- `sellGold()` - продать голду
- `getOrderBook()` - стакан заявок
- `getMyOrders()` - мои заявки
- `cancelByPrice()` - отменить по цене
- `cancelAll()` - отменить все
- `cancelPart()` - отменить часть
- `getDeals()` - сделки

### UpdatesMethods
- `getUpdates()` - получить обновления
- `updateStream` - поток обновлений

### OtherMethods
- `getIrisAgents()` - список агентов
- `getLastVersion()` - версия API

## 🔧 Настройка клиента

```dart
final api = await IrisApi.create(
  botId: YOUR_BOT_ID,
  irisToken: 'YOUR_IRIS_TOKEN',
  baseUrl: 'https://iris-tg.ru/api', // опционально
  timeout: Duration(seconds: 30),     // опционально
);
```

## 🚨 Важные изменения v2.0.0

1. **Автоматическое определение версии** - больше не нужно указывать `apiVersion`
2. **Фабричный метод `create()`** - асинхронная инициализация
3. **Разделение на классы методов** - модульная архитектура
4. **GET/POST запросы** - соответствие спецификации API
5. **Обработка rate limiting** - рекомендации по задержкам
6. **Полный набор методов** - все возможности Iris API

## 🤝 Поддержка

При возникновении проблем или вопросов создавайте issue на [GitHub](https://github.com/ваш-репозиторий).

## 📄 Лицензия

MIT License