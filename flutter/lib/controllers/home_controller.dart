import 'package:flutter/material.dart';
import '../services/services_api_service.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';
import 'city_controller.dart';

class HomeController extends ChangeNotifier {
  final ServicesApiService _apiService = ServicesApiService();
  final CityController _cityController;

  List<ServiceModel> _featuredServices = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  HomeController({required CityController cityController})
    : _cityController = cityController {
    _cityController.addListener(_onCityChanged);
    _initializeData();
  }

  @override
  void dispose() {
    _cityController.removeListener(_onCityChanged);
    super.dispose();
  }

  void _onCityChanged() {
    // Перезагружаем данные при смене города
    _initializeData();
  }

  List<ServiceModel> get featuredServices => _featuredServices;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// UI состояния
  bool get hasCategories => _categories.isNotEmpty;
  bool get hasFeaturedServices => _featuredServices.isNotEmpty;
  bool get isEmpty =>
      !_isLoading &&
      _categories.isEmpty &&
      _featuredServices.isEmpty &&
      _error == null;
  bool get hasError => _error != null;

  /// Загрузка начальных данных
  Future<void> _initializeData() async {
    await loadCategories();
    await loadFeaturedServices();
  }

  /// Загрузка категорий из API
  Future<void> loadCategories() async {
    _setLoading(true);
    try {
      _categories = await _apiService.getCategories(
        cityName: _cityController.selectedCity,
      );
      _error = null;
    } catch (e) {
      _error = 'Kategoriyalarni yuklashda xatolik: $e';
      print('HomeController kategoriya yuklash xatoligi: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Загрузка рекомендуемых услуг из всех услуг города
  Future<void> loadFeaturedServices() async {
    _setLoading(true);
    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      // Берем первые 6 услуг как рекомендуемые
      _featuredServices = allServices.take(6).toList();
      _error = null;
    } catch (e) {
      _error = 'Tavsiya etiladigan xizmatlarni yuklashda xatolik: $e';
      print('HomeController featured services yuklash xatoligi: $e');
      _featuredServices = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Обновление всех данных
  Future<void> refreshData() async {
    _error = null;
    await loadCategories();
    await loadFeaturedServices();
  }

  /// Поиск услуг через API (заменен на загрузку всех услуг)
  Future<List<ServiceModel>> searchServices(String query) async {
    if (query.isEmpty) return [];

    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      // Фильтруем услуги по запросу локально
      return allServices.where((service) {
        final serviceName = service.name.toLowerCase();
        final serviceDescription = service.description.toLowerCase();
        final queryLower = query.toLowerCase();

        return serviceName.contains(queryLower) ||
            serviceDescription.contains(queryLower);
      }).toList();
    } catch (e) {
      _error = 'Qidirishda xatolik: $e';
      print('HomeController qidiruv xatoligi: $e');
      notifyListeners();
      return [];
    }
  }

  /// Получение услуги по ID (убран, так как метод удален из API)
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      // Ищем услугу по ID среди всех услуг
      return allServices.firstWhere(
        (service) =>
            service.name.contains(serviceId), // Поиск по имени, если нет ID
        orElse: () =>
            allServices.first, // Возвращаем первую услугу, если не найдено
      );
    } catch (e) {
      _error = 'Xizmatni yuklashda xatolik: $e';
      print('HomeController service by ID yuklash xatoligi: $e');
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
