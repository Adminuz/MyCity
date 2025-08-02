import 'package:flutter/material.dart';
import '../services/services_api_service.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';
import 'city_controller.dart';

class ServicesController extends ChangeNotifier {
  final ServicesApiService _apiService = ServicesApiService();
  final CityController _cityController;

  List<ServiceModel> _services = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';

  ServicesController({required CityController cityController})
    : _cityController = cityController {
    _cityController.addListener(_onCityChanged);
    loadCategories();
  }

  @override
  void dispose() {
    _cityController.removeListener(_onCityChanged);
    super.dispose();
  }

  void _onCityChanged() {
    loadCategories();
  }

  List<ServiceModel> get services => _services;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  bool get hasCategories => _categories.isNotEmpty;
  bool get hasServices => _services.isNotEmpty;
  bool get isEmpty => !_isLoading && _categories.isEmpty && _error == null;
  bool get hasError => _error != null;

  Future<void> loadCategories() async {
    _setLoading(true);
    try {
      _categories = await _apiService.getCategories(
        cityName: _cityController.selectedCity,
      );
      _error = null;
    } catch (e) {
      _error = 'Kategoriyalarni yuklashda xatolik: $e';
      _categories = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadServicesByCategory(String category) async {
    _selectedCategory = category;
    _setLoading(true);
    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      _services = allServices.where((service) {
        if (service.category != null) {
          return service.category!.toLowerCase() == category.toLowerCase();
        }
        final serviceName = service.name.toLowerCase();
        final serviceDescription = service.description.toLowerCase();
        final categoryLower = category.toLowerCase();

        return serviceName.contains(categoryLower) ||
            serviceDescription.contains(categoryLower);
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Xizmatlarni yuklashda xatolik: $e';
      _services = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      _services = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      _services = allServices.where((service) {
        final serviceName = service.name.toLowerCase();
        final serviceDescription = service.description.toLowerCase();
        final queryLower = query.toLowerCase();

        return serviceName.contains(queryLower) ||
            serviceDescription.contains(queryLower);
      }).toList();

      _error = null;
    } catch (e) {
      _error = 'Qidirishda xatolik: $e';
      _services = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addReview(String serviceId, ServiceReview review) async {
    try {
      _error = 'Sharh qo\'shish funksiyasi hozircha mavjud emas';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Sharh qo\'shishda xatolik: $e';
      notifyListeners();
      return false;
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final allServices = await _apiService.getAllServices(
        cityName: _cityController.selectedCity,
      );

      return allServices.firstWhere(
        (service) => service.name.contains(serviceId),
        orElse: () => allServices.isNotEmpty
            ? allServices.first
            : throw Exception('Услуга не найдена'),
      );
    } catch (e) {
      _error = 'Xizmatni yuklashda xatolik: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> refreshAllData() async {
    _error = null;
    await loadCategories();
    if (_selectedCategory.isNotEmpty) {
      await loadServicesByCategory(_selectedCategory);
    }
  }

  void clearSelectedCategory() {
    _selectedCategory = '';
    _services = [];
    notifyListeners();
  }

  CategoryModel? getCategoryInfo(String categoryName) {
    try {
      return _categories.firstWhere((cat) => cat.name == categoryName);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> updateServiceRating(String serviceId) async {
    try {
      final updatedService = await _apiService.getServiceById(
        serviceId,
        cityName: _cityController.selectedCity,
      );

      if (updatedService != null) {
        final index = _services.indexWhere(
          (service) => service.id == serviceId,
        );
        if (index != -1) {
          _services[index] = updatedService;
          notifyListeners();
        }
      }
    } catch (e) {}
  }
}
