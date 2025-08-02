import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/city_controller.dart';
import '../../controllers/main_data_controller.dart';

class CitySelector extends StatelessWidget {
  const CitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cityController = Provider.of<CityController>(context);

    if (cityController.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          final cities = cityController.cities;
          if (cities.isEmpty) return;

          String? selectedCode = await showDialog<String>(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Shaharni tanlang'),
                children: cities
                    .map(
                      (city) => SimpleDialogOption(
                        child: Text(city.name),
                        onPressed: () => Navigator.pop(context, city.code),
                      ),
                    )
                    .toList(),
              );
            },
          );

          if (selectedCode != null &&
              selectedCode != cityController.selectedCity) {
            cityController.setCity(selectedCode);
            // Обновляем данные для нового города
            if (context.mounted) {
              Provider.of<MainDataController>(
                context,
                listen: false,
              ).loadData(cityController.selectedCityModel?.name);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            cityController.selectedCityModel?.name ??
                cityController.selectedCity,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}
