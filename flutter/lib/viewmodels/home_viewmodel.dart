import 'package:flutter/material.dart';
import '../controllers/city_controller.dart';
import '../models/prayer_time_model.dart';
import '../models/event_model.dart';
import '../models/weather_model.dart';
import '../services/main_api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MainApiService _apiService = MainApiService();
  late CityController _cityController;
  bool _disposed = false;

  List<EventModel> _events = [];
  WeatherModel? _weather;
  List<PrayerTime> _prayerTimes = [];

  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  WeatherModel? get weather => _weather;
  List<PrayerTime> get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCity => _cityController.selectedCity;

  HomeViewModel({required CityController cityController}) {
    _cityController = cityController;
    _cityController.addListener(_onCityChanged);
    _fetchAll();
  }

  void _onCityChanged() {
    if (_disposed) return;
    _fetchAll();
  }

  Future<void> refreshAll() async {
    if (_disposed) return;
    await _fetchAll();
  }

  Future<void> _fetchAll() async {
    if (_disposed) return;

    _isLoading = true;
    _error = null;
    _safeNotifyListeners();

    try {
      final result = await _apiService.fetchAll(
        city: _cityController.selectedCity,
      );

      if (_disposed) return;

      _events = result.events;
      _weather = result.weather;
      _prayerTimes = result.prayerTimes;
    } catch (e) {
      if (_disposed) return;

      _error = e.toString();
      _events = [];
      _weather = null;
      _prayerTimes = [];
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _safeNotifyListeners();
      }
    }
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _cityController.removeListener(_onCityChanged);
    super.dispose();
  }
}
