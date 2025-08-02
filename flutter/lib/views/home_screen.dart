import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../presentation/widgets/weather_prayer_card.dart';
import '../presentation/widgets/event_card.dart';
import '../presentation/widgets/city_selector.dart';
import '../controllers/city_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cityController = Provider.of<CityController>(context, listen: false);
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(cityController: cityController),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: const Color(0xFFF9FAFB),
              elevation: 5,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 28, width: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'MyCity',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              actions: const [
                Icon(Icons.my_location, color: Colors.teal),
                SizedBox(width: 4),
                CitySelector(),
                SizedBox(width: 15),
              ],
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherPrayerCard(vm: vm),
                        const SizedBox(height: 28),
                        const Text(
                          '🎭 Shahar Afishasi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (vm.error != null) {
                                return Center(
                                  child: Text(
                                    'Xatolik: ${vm.error}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else if (vm.events.isEmpty) {
                                return const Center(
                                  child: Text('Hodisalar topilmadi.'),
                                );
                              } else {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: vm.events.length,
                                  itemBuilder: (context, index) {
                                    return EventCard(event: vm.events[index]);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
