import 'package:flutter/foundation.dart';

class AppLog {
  AppLog._();

  static void d(String message) => debugPrint('[App] $message');

  static void e(String message, [Object? error]) =>
      debugPrint('[App][ERROR] $message${error != null ? ' -> $error' : ''}');
}
