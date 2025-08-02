import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkService extends ChangeNotifier {
  bool _hasConnection = true;
  bool _serverAvailable = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Timer? _serverCheckTimer;

  static const String serverUrl = 'http://94.159.108.34:5000/api';

  bool get hasConnection => _hasConnection && _serverAvailable;

  NetworkService() {
    _initializeConnectivity();
    _startServerMonitoring();
  }

  void _initializeConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });

    // Проверяем начальное состояние
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    try {
      final List<ConnectivityResult> results = await Connectivity()
          .checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      print('Ошибка проверки соединения: $e');
      _hasConnection = false;
      notifyListeners();
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool connected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    if (_hasConnection != connected) {
      _hasConnection = connected;
      notifyListeners();
    }
  }

  void _startServerMonitoring() {
    _checkServerAvailability();
    _serverCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkServerAvailability();
    });
  }

  Future<void> _checkServerAvailability() async {
    if (!_hasConnection) {
      _serverAvailable = false;
      return;
    }

    try {
      final response = await http
          .get(
            Uri.parse('$serverUrl/cities'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      final bool available = response.statusCode == 200;
      if (_serverAvailable != available) {
        _serverAvailable = available;
        notifyListeners();
      }
    } catch (e) {
      print('Сервер недоступен: $e');
      if (_serverAvailable) {
        _serverAvailable = false;
        notifyListeners();
      }
    }
  }

  Future<void> checkConnectivity() async {
    await _checkInitialConnection();
    await _checkServerAvailability();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _serverCheckTimer?.cancel();
    super.dispose();
  }
}
