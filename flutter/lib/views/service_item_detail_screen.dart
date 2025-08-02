import 'package:flutter/material.dart';
import 'package:mycity/presentation/widgets/common_bottom_navigation.dart';
import 'package:provider/provider.dart';
import '../presentation/widgets/service_detail/index.dart';
import '../controllers/city_controller.dart';

class ServiceItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceItemDetailScreen({super.key, required this.service});

  @override
  State<ServiceItemDetailScreen> createState() =>
      _ServiceItemDetailScreenState();
}

class _ServiceItemDetailScreenState extends State<ServiceItemDetailScreen> {
  late Map<String, dynamic> _service;
  bool _wasReviewAdded = false; // Флаг для отслеживания добавления отзыва

  @override
  void initState() {
    super.initState();
    _service = Map.from(widget.service);
  }

  // Мгновенно обновляем рейтинг локально
  void _updateRatingInstantly(String name, int rating, String comment) {
    final currentReviews = List<Map<String, dynamic>>.from(
      _service['reviews'] ?? [],
    );

    // Добавляем новый отзыв в список
    final newReview = {
      'name': name,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now().toIso8601String(),
    };

    currentReviews.add(newReview);

    // Подсчитываем новый рейтинг
    double newRating = 0.0;
    if (currentReviews.isNotEmpty) {
      double totalRating = 0.0;
      for (var review in currentReviews) {
        totalRating += (review['rating'] as int).toDouble();
      }
      newRating = totalRating / currentReviews.length;
    }

    print('Мгновенное обновление - новый рейтинг: $newRating');

    // Обновляем состояние немедленно
    setState(() {
      _service = {..._service, 'rating': newRating, 'reviews': currentReviews};
      _wasReviewAdded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityController = Provider.of<CityController>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () =>
              Navigator.of(context).pop(_wasReviewAdded ? _service : false),
        ),
        title: Text(
          _service['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.teal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceImageWidget(service: _service),
            const SizedBox(height: 12),

            // Заголовок с названием, рейтингом и описанием
            ServiceHeaderWidget(service: _service),
            const SizedBox(height: 8),

            // Информация о сервисе
            ServiceInfoSection(service: _service),
            const SizedBox(height: 16),

            // Отзывы
            ServiceReviewsSection(
              reviews: _service['reviews'],
              serviceId: _service['id'] ?? _service['name'] ?? 'unknown',
              cityName: cityController.selectedCity,
              onReviewAdded:
                  _updateRatingInstantly, // Используем мгновенное обновление
            ),
            const SizedBox(height: 70), // Отступ для кнопок
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomNavigation(
        selectedIndex: 1,
        showInServiceDetail: true,
      ),
    );
  }
}
