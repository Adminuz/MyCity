import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';

class WeatherPrayerCard extends StatelessWidget {
  final HomeViewModel vm;
  const WeatherPrayerCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final weather = vm.weather;
    if (vm.error != null) {
      return Center(
        child: Text(
          'Xatolik: ${vm.error}',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    if (weather == null) {
      return const Center(child: Text('Ob-havo maʼlumotlari yoʻq.'));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.teal),
                onPressed: () {},
                tooltip: 'Yangilash',
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (vm.prayerTimes.isEmpty)
            const Center(child: Text('Namoz vaqtlari yoʻq.'))
          else
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: vm.prayerTimes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final prayer = vm.prayerTimes[index];
                  final icon = _prayerIcon(prayer.name);
                  final color = _prayerColor(prayer.name);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 20),
                        const SizedBox(width: 6),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              prayer.name,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              prayer.time,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  IconData _prayerIcon(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.wb_cloudy;
      case 'maghrib':
        return Icons.nightlight;
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  Color _prayerColor(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return Colors.indigo;
      case 'dhuhr':
        return Colors.orange;
      case 'asr':
        return Colors.green;
      case 'maghrib':
        return Colors.purple;
      case 'isha':
        return Colors.blueGrey;
      default:
        return Colors.teal;
    }
  }
}
