import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../services/cities_api_service.dart';

class CityController extends ChangeNotifier {
  final CitiesApiService _apiService = CitiesApiService();

  List<CityModel> _cities = [];
  String _selectedCity = 'xiva';
  bool _isLoading = false;
  String? _error;

  List<CityModel> get cities => List.unmodifiable(_cities);
  String get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get cityNames => _cities.map((city) => city.name).toList();
  List<String> get cityCodes => _cities.map((city) => city.code).toList();

  CityModel? get selectedCityModel {
    try {
      return _cities.firstWhere((city) => city.code == _selectedCity);
    } catch (e) {
      return null;
    }
  }

  CityController() {
    _loadCities();
  }

  Future<void> _loadCities() async {
    _setLoading(true);
    try {
      _cities = await _apiService.getCities();
      _error = null;

      if (_cities.isNotEmpty && !cityCodes.contains(_selectedCity)) {
        _selectedCity = _cities.first.code;
      }
    } catch (e) {
      _error = 'Shaharlar ro\'yxatini yuklashda xatolik: $e';
      _cities = [];
    } finally {
      _setLoading(false);
    }
  }

  void setCity(String cityCode) {
    if (_selectedCity != cityCode && cityCodes.contains(cityCode)) {
      _selectedCity = cityCode;
      notifyListeners();
    }
  }

  void setCityByName(String cityName) {
    final city = _cities.where((city) => city.name == cityName).firstOrNull;
    if (city != null) {
      setCity(city.code);
    }
  }

  Future<void> refreshCities() async {
    await _loadCities();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
