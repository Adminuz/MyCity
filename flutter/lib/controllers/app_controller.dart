import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _globalError;

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get globalError => _globalError;

  Future<void> initializeApp() async {
    if (_isInitialized) return;

    _setLoading(true);
    try {
      _isInitialized = true;
      _globalError = null;
    } catch (e) {
      _globalError = 'Ilovani ishga tushirishda xatolik: $e';
      print('AppController initialization error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshApp() async {
    _globalError = null;
    await initializeApp();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearGlobalError() {
    _globalError = null;
    notifyListeners();
  }
}
