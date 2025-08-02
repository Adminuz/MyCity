import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/widgets/common_bottom_navigation.dart';
import '../controllers/services_controller.dart';
import '../models/service_model.dart';
import 'service_item_detail_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String title;
  final VoidCallback? onBack;
  const ServiceDetailScreen({super.key, required this.title, this.onBack});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final List<String> chipMenu = const [
    'Barchasi',
    'Ommabop',
    'Yangi',
    'Aksiyalar',
    'Sharhlar',
  ];

  int selectedChip = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesController>().loadServicesByCategory(widget.title);
    });
  }

  Map<String, dynamic> _convertServiceToMap(ServiceModel service) {
    return {
      'id': service.id,
      'name': service.name,
      'description': service.description,
      'image': service.image,
      'rating': service.rating,
      'price': service.price,
      'phone': service.phone,
      'address': service.address,
      'workingHours': service.workingHours,
      'latitude': service.latitude,
      'longitude': service.longitude,
      'reviews': service.reviews
          .map(
            (review) => {
              'name': review.name,
              'rating': review.rating,
              'comment': review.comment,
              'date': review.date,
            },
          )
          .toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 5,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.teal),
                onPressed: widget.onBack,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.teal),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chipMenu.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(chipMenu[index]),
                      selected: selectedChip == index,
                      selectedColor: Colors.teal,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selectedChip == index
                            ? Colors.white
                            : Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedChip = index;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.teal.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ServicesController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    );
                  }

                  if (controller.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Xizmatlarni yuklashda xatolik',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              controller.clearError();
                              controller.loadServicesByCategory(widget.title);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Qayta urinish'),
                          ),
                        ],
                      ),
                    );
                  }

                  var services = controller.services;

                  if (services.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Xizmatlar topilmadi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ushbu kategoriyada hozircha mavjud xizmatlar yo\'q',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: services.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return InkWell(
                        key: ValueKey('service_${service.id}'),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceItemDetailScreen(
                                service: _convertServiceToMap(service),
                              ),
                            ),
                          );

                          if (result is Map<String, dynamic> && mounted) {
                            print('Возвращенные данные: $result');

                            final updatedRating = result['rating'] as double;
                            final updatedReviews =
                                result['reviews'] as List<dynamic>;

                            setState(() {
                              final serviceIndex = services.indexWhere(
                                (s) => s.id == service.id,
                              );
                              if (serviceIndex != -1) {
                                // Создаем список ServiceReview из обновленных отзывов
                                final reviewsList = updatedReviews.map((
                                  review,
                                ) {
                                  return ServiceReview(
                                    name: review['name'] ?? '',
                                    rating:
                                        (review['rating'] is int
                                            ? (review['rating'] as int)
                                                  .toDouble()
                                            : review['rating']?.toDouble()) ??
                                        0.0,
                                    comment: review['comment'] ?? '',
                                    date: review['date'] ?? '',
                                  );
                                }).toList();

                                print(
                                  'Обновляем сервис ${service.name}: старый рейтинг ${service.rating}, новый $updatedRating',
                                );
                                print(
                                  'До обновления: id=${service.id}, name="${service.name}", rating=${service.rating}',
                                );

                                // Создаем новый список со всеми данными
                                final List<ServiceModel> newServices =
                                    List.from(services);
                                newServices[serviceIndex] =
                                    services[serviceIndex].copyWith(
                                      rating: updatedRating,
                                      reviews: reviewsList,
                                    );

                                // Заменяем весь список
                                services = newServices;

                                print(
                                  'После обновления: id=${services[serviceIndex].id}, name="${services[serviceIndex].name}", rating=${services[serviceIndex].rating}',
                                );
                                print(
                                  'Всего сервисов в списке: ${services.length}',
                                );

                                // Дополнительная проверка
                                for (int i = 0; i < services.length; i++) {
                                  print(
                                    'Сервис $i: id=${services[i].id}, name="${services[i].name}", rating=${services[i].rating}',
                                  );
                                }
                              }
                            });

                            print(
                              'Обновлен сервис ${service.id}: рейтинг $updatedRating, отзывов ${updatedReviews.length}',
                            );
                          } else {
                            print(
                              'Результат не является Map или mounted=false: $result',
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                    ),
                                    child:
                                        service.image.isNotEmpty &&
                                            service.image.startsWith('http')
                                        ? Image.network(
                                            service.image,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                    color: Colors.teal
                                                        .withValues(alpha: 0.1),
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: Colors.teal,
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.teal
                                                        .withValues(alpha: 0.1),
                                                    child: const Icon(
                                                      Icons.image,
                                                      color: Colors.teal,
                                                      size: 32,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            color: Colors.teal.withValues(
                                              alpha: 0.1,
                                            ),
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.teal,
                                              size: 32,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        service.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  service.rating.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              service.price,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.teal,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
