import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/widgets/main_navigation.dart';
import 'controllers/controllers.dart';
import 'services/network_service.dart';
import 'presentation/screens/no_internet_screen.dart';

void main() => runApp(const CityApp());

class CityApp extends StatelessWidget {
  const CityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
        ChangeNotifierProvider(create: (_) => CityController()),
        ChangeNotifierProvider(create: (_) => NetworkService()),
        ChangeNotifierProxyProvider<CityController, HomeController>(
          create: (context) => HomeController(
            cityController: Provider.of<CityController>(context, listen: false),
          ),
          update: (context, cityController, previous) =>
              previous ?? HomeController(cityController: cityController),
        ),
        ChangeNotifierProxyProvider<CityController, ServicesController>(
          create: (context) => ServicesController(
            cityController: Provider.of<CityController>(context, listen: false),
          ),
          update: (context, cityController, previous) =>
              previous ?? ServicesController(cityController: cityController),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer<NetworkService>(
          builder: (context, networkService, child) {
            if (!networkService.hasConnection) {
              return NoInternetScreen(
                onRetry: () {
                  networkService.checkConnectivity();
                },
              );
            }
            return const MainNavigation();
          },
        ),
      ),
    );
  }
}
