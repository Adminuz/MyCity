import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/controllers.dart';

/// Пример экрана, демонстрирующего интеграцию всех контроллеров с API
class ApiIntegrationDemo extends StatefulWidget {
  const ApiIntegrationDemo({super.key});

  @override
  State<ApiIntegrationDemo> createState() => _ApiIntegrationDemoState();
}

class _ApiIntegrationDemoState extends State<ApiIntegrationDemo> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppStatus(),
            const SizedBox(height: 20),
            _buildCitySelector(),
            const SizedBox(height: 20),
            _buildSearchSection(),
            const SizedBox(height: 20),
            _buildCategoriesSection(),
            const SizedBox(height: 20),
            _buildServicesSection(),
            const SizedBox(height: 20),
            _buildFeaturedServices(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppStatus() {
    return Consumer<AppController>(
      builder: (context, appController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ilova holati',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      appController.isInitialized
                          ? Icons.check_circle
                          : Icons.pending,
                      color: appController.isInitialized
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appController.isInitialized ? 'Tayyor' : 'Yuklanmoqda...',
                    ),
                  ],
                ),
                if (appController.globalError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    appController.globalError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCitySelector() {
    return Consumer<CityController>(
      builder: (context, cityController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shahar tanlash',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (cityController.isLoading)
                  const CircularProgressIndicator()
                else
                  DropdownButton<String>(
                    value: cityController.selectedCity,
                    isExpanded: true,
                    items: cityController.cities.map((city) {
                      return DropdownMenuItem(
                        value: city.code,
                        child: Text(city.name),
                      );
                    }).toList(),
                    onChanged: (cityCode) {
                      if (cityCode != null) {
                        cityController.setCity(cityCode);
                      }
                    },
                  ),
                if (cityController.error != null)
                  Text(
                    cityController.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Consumer<ServicesController>(
      builder: (context, servicesController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Qidiruv', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Xizmat nomi yozing...',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        servicesController.searchServices(
                          _searchController.text,
                        );
                      },
                    ),
                  ),
                  onSubmitted: (query) {
                    servicesController.searchServices(query);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection() {
    return Consumer<ServicesController>(
      builder: (context, servicesController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Kategoriyalar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (servicesController.isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (servicesController.categories.isEmpty &&
                    !servicesController.isLoading)
                  const Text('Kategoriyalar yuklanmadi')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: servicesController.categories.map((category) {
                      final isSelected =
                          servicesController.selectedCategory == category.name;
                      return FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            servicesController.loadServicesByCategory(
                              category.name,
                            );
                          } else {
                            servicesController.clearSelectedCategory();
                          }
                        },
                      );
                    }).toList(),
                  ),
                if (servicesController.error != null)
                  Text(
                    servicesController.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesSection() {
    return Consumer<ServicesController>(
      builder: (context, servicesController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xizmatlar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (servicesController.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (servicesController.services.isEmpty)
                  const Text('Hech qanday xizmat topilmadi')
                else
                  Column(
                    children: servicesController.services.take(3).map((
                      service,
                    ) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withValues(alpha: 0.1),
                          backgroundImage:
                              service.image.isNotEmpty &&
                                  service.image.startsWith('http')
                              ? NetworkImage(service.image)
                              : null,
                          onBackgroundImageError: (_, __) {},
                          child:
                              service.image.isEmpty ||
                                  !service.image.startsWith('http')
                              ? const Icon(Icons.business, color: Colors.teal)
                              : null,
                        ),
                        title: Text(service.name),
                        subtitle: Text(service.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            Text(service.rating.toString()),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedServices() {
    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tavsiya etiladigan xizmatlar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (homeController.isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (homeController.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (homeController.featuredServices.isEmpty)
                  const Text('Tavsiya etiladigan xizmatlar topilmadi')
                else
                  Column(
                    children: homeController.featuredServices.take(3).map((
                      service,
                    ) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withValues(alpha: 0.1),
                          backgroundImage:
                              service.image.isNotEmpty &&
                                  service.image.startsWith('http')
                              ? NetworkImage(service.image)
                              : null,
                          onBackgroundImageError: (_, __) {},
                          child:
                              service.image.isEmpty ||
                                  !service.image.startsWith('http')
                              ? const Icon(Icons.star, color: Colors.teal)
                              : null,
                        ),
                        title: Text(service.name),
                        subtitle: Text(service.description),
                        trailing: Text(service.price),
                      );
                    }).toList(),
                  ),
                if (homeController.error != null)
                  Text(
                    homeController.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
