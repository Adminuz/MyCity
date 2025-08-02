import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';
import '../models/category_model.dart';

class ServicesApiService {
  final String baseUrl = 'http://94.159.108.34:5000/api';

  final Duration timeout = const Duration(seconds: 10);

  Future<List<CategoryModel>> getCategories({required String cityName}) async {
    try {
      final url =
          '$baseUrl/categories/${Uri.encodeComponent(cityName.toLowerCase())}';

      print('API dan kategoriya ma\'lumotlarini yuklash: $url');
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data['success'] == true && data['data'] != null) {
          final categoriesData = data['data'] as List;
          return categoriesData
              .map((item) => CategoryModel.fromJson(item))
              .toList();
        }
      }

      throw Exception(
        'Kategoriyalarni yuklashda xatolik: ${response.statusCode}',
      );
    } catch (e) {
      print('Internet aloqasi yo\'q: $e');
      rethrow;
    }
  }

  Future<List<String>> getServiceCategories({required String cityName}) async {
    try {
      final url =
          '$baseUrl/categories/${Uri.encodeComponent(cityName.toLowerCase())}';

      print('API dan kategoriyalarni yuklash: $url');
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data['success'] == true && data['data'] != null) {
          final categoriesData = data['data'] as List;
          return categoriesData.map((item) => item['name'] as String).toList();
        }
      }

      throw Exception(
        'Kategoriyalarni yuklashda xatolik: ${response.statusCode}',
      );
    } catch (e) {
      print('API xatolik: $e');
      rethrow;
    }
  }

  Future<List<ServiceModel>> getServicesByCategory(
    String category, {
    required String cityName,
  }) async {
    try {
      final url =
          '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}';

      print('$category kategoriyasi uchun xizmatlarni API dan yuklash: $url');
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data['success'] == true && data['data'] != null) {
          final servicesList = data['data'] as List<dynamic>;

          final filteredServices = servicesList.where((service) {
            if (service['category'] != null) {
              final serviceCategory = service['category']
                  .toString()
                  .toLowerCase();
              final targetCategory = category.toLowerCase();
              return serviceCategory == targetCategory;
            }

            final serviceName = service['name']?.toString().toLowerCase() ?? '';
            final serviceDescription =
                service['description']?.toString().toLowerCase() ?? '';
            final categoryLower = category.toLowerCase();

            return serviceName.contains(categoryLower) ||
                serviceDescription.contains(categoryLower) ||
                _matchesCategory(category, service);
          }).toList();

          return filteredServices
              .map((serviceJson) => ServiceModel.fromJson(serviceJson))
              .toList();
        }
      }

      throw Exception(
        '$category kategoriyasi uchun xizmatlarni yuklash muvaffaqiyatsiz: ${response.statusCode}',
      );
    } catch (e) {
      print('API xatolik: $e');
      rethrow;
    }
  }

  bool _matchesCategory(String category, Map<String, dynamic> service) {
    final categoryMappings = {
      'tovarlar': ['elektronika', 'kiyim', 'uy buyumlari'],
      'ta\'lim': ['ta\'lim', 'kurs', 'o\'qitish'],
      'tibbiyot': ['shifokor', 'klinika', 'dorixona'],
      'turizm': ['turizm', 'sayohat', 'mehmonxona'],
      'sport': ['sport', 'fitnes', 'mashq'],
    };

    final categoryLower = category.toLowerCase();
    final keywords = categoryMappings[categoryLower] ?? [categoryLower];

    final serviceName = service['name']?.toString().toLowerCase() ?? '';
    final serviceDescription =
        service['description']?.toString().toLowerCase() ?? '';

    return keywords.any(
      (keyword) =>
          serviceName.contains(keyword) || serviceDescription.contains(keyword),
    );
  }

  Future<List<ServiceModel>> getAllServices({required String cityName}) async {
    try {
      final url =
          '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}';

      print('Barcha xizmatlarni API dan yuklash: $url');
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data['success'] == true && data['data'] != null) {
          final servicesList = data['data'] as List<dynamic>;
          return servicesList
              .map((serviceJson) => ServiceModel.fromJson(serviceJson))
              .toList();
        }
      }

      throw Exception(
        'Barcha xizmatlarni yuklash muvaffaqiyatsiz: ${response.statusCode}',
      );
    } catch (e) {
      print('Internet aloqasi yo\'q: $e');
      rethrow;
    }
  }

  Future<ServiceModel?> getServiceById(
    String serviceId, {
    String? cityName,
  }) async {
    try {
      final url = cityName != null
          ? '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}/service/${Uri.encodeComponent(serviceId)}'
          : '$baseUrl/services/${Uri.encodeComponent(serviceId)}';

      print('$serviceId ID li xizmatni API dan yuklash: $url');
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['success'] == true && data['data'] != null) {
          return ServiceModel.fromJson(data['data']);
        }
      }

      throw Exception(
        '$serviceId ID li xizmatni yuklash muvaffaqiyatsiz: ${response.statusCode}',
      );
    } catch (e) {
      print('API xatolik: $e');
      rethrow;
    }
  }

  Future<List<ServiceModel>> searchServices(
    String query, {
    required String cityName,
  }) async {
    try {
      final url =
          '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}/search?q=${Uri.encodeComponent(query)}';

      print('$query so\'zi bo\'yicha qidiruv: $url');
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['success'] == true && data['data'] != null) {
          final servicesList = data['data'] as List<dynamic>;
          return servicesList
              .map((serviceJson) => ServiceModel.fromJson(serviceJson))
              .toList();
        }
      }

      throw Exception('Qidiruv muvaffaqiyatsiz: ${response.statusCode}');
    } catch (e) {
      print('Qidiruv xatolik: $e');
      rethrow;
    }
  }

  Future<bool> addReview(
    String serviceId,
    ServiceReview review, {
    String? cityName,
  }) async {
    try {
      final url = cityName != null
          ? '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}/service/${Uri.encodeComponent(serviceId)}/reviews'
          : '$baseUrl/services/${Uri.encodeComponent(serviceId)}/reviews';

      final requestBody = json.encode(review.toJson());
      print('$serviceId xizmatiga sharh qo\'shish: $url');
      print('Yuborilayotgan ma\'lumotlar: $requestBody');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(timeout);

      print('Server javobi: ${response.statusCode}');
      print('Server javob matni: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      String errorMessage =
          'Sharh qo\'shish muvaffaqiyatsiz: ${response.statusCode}';
      try {
        final errorData = json.decode(response.body);
        if (errorData['message'] != null) {
          errorMessage += ' - ${errorData['message']}';
        }
      } catch (e) {}

      throw Exception(errorMessage);
    } catch (e) {
      print('Sharh qo\'shish xatolik: $e');
      rethrow;
    }
  }

  Future<List<ServiceReview>> getReviews(
    String serviceId, {
    String? cityName,
  }) async {
    try {
      final url = cityName != null
          ? '$baseUrl/services/${Uri.encodeComponent(cityName.toLowerCase())}/service/${Uri.encodeComponent(serviceId)}/reviews'
          : '$baseUrl/services/${Uri.encodeComponent(serviceId)}/reviews';

      print('$serviceId xizmati uchun sharhlarni yuklash: $url');
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map && data['success'] == true && data['data'] != null) {
          final reviewsData = data['data'] as List;
          return reviewsData
              .map((item) => ServiceReview.fromJson(item))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Sharhlarni yuklash xatolik: $e');
      return [];
    }
  }
}
