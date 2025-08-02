import 'package:flutter/material.dart';
import '../services/main_api_service.dart';
import '../models/event_model.dart';
import '../models/weather_model.dart';
import '../models/prayer_time_model.dart';

class MainDataController extends ChangeNotifier {
  final MainApiService _apiService = MainApiService();

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

  /// Загрузка данных для выбранного города
  Future<void> loadData([String? city]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchAll(city: city);
      _events = response.events;
      _weather = response.weather;
      _prayerTimes = response.prayerTimes;
      _error = null;
    } catch (e) {
      _error = 'Ma\'lumotlarni yuklashda xatolik: $e';
      print('MainDataController yuklash xatoligi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновление данных
  Future<void> refreshData([String? city]) async {
    await loadData(city);
  }

  /// Очистка данных
  void clearData() {
    _events = [];
    _weather = null;
    _prayerTimes = [];
    _error = null;
    notifyListeners();
  }
}
