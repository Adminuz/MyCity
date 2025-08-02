import 'package:flutter/foundation.dart';

/// Утилитарный класс для управления состоянием API и сетевых запросов
class ApiState {
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;

  static bool get isOnline {
    return true;
  }

  /// Логирует API запрос
  static void logApiRequest(String method, String url) {
    if (kDebugMode) {
      print('API Request: $method $url');
    }
  }

  /// Логирует ответ API
  static void logApiResponse(String url, int statusCode, {String? error}) {
    if (kDebugMode) {
      if (error != null) {
        print('API Error: $url - $error');
      } else {
        print('API Response: $url - Status: $statusCode');
      }
    }
  }

  /// Обрабатывает ошибки API
  static String handleApiError(dynamic error) {
    if (error.toString().contains('TimeoutException')) {
      return 'Vaqt tugadi. Iltimos, qaytadan urinib ko\'ring.';
    } else if (error.toString().contains('SocketException')) {
      return 'Internet aloqasi yo\'q. Iltimos, internetni tekshiring.';
    } else if (error.toString().contains('FormatException')) {
      return 'Ma\'lumot formatida xatolik.';
    }
    return 'Noma\'lum xatolik yuz berdi: ${error.toString()}';
  }

  static Future<T> retryRequest<T>(
    Future<T> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await request();
      } catch (e) {
        if (attempt == maxRetries) {
          rethrow;
        }
        if (kDebugMode) {
          print('API retry attempt $attempt failed: $e');
        }
        await Future.delayed(delay * attempt);
      }
    }
    throw Exception('Maximum retry attempts exceeded');
  }
}
