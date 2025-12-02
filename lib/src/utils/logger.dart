class IrisLogger {
  final bool enableLogging;

  IrisLogger({this.enableLogging = true});

  void info(String message) {
    if (enableLogging) {
      print('[${_currentTime()}] ℹ️  IRIS_INFO: $message');
    }
  }

  void debug(String message) {
    if (enableLogging) {
      print('[${_currentTime()}] 🔍 IRIS_DEBUG: $message');
    }
  }

  void warning(String message) {
    if (enableLogging) {
      print('[${_currentTime()}] ⚠️  IRIS_WARNING: $message');
    }
  }

  void error(String message) {
    if (enableLogging) {
      print('[${_currentTime()}] ❌ IRIS_ERROR: $message');
    }
  }

  void success(String message) {
    if (enableLogging) {
      print('[${_currentTime()}] ✅ IRIS_SUCCESS: $message');
    }
  }

  String _currentTime() {
    return DateTime.now().toIso8601String();
  }
}
