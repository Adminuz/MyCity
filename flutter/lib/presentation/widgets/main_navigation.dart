import 'package:flutter/material.dart';
import '../../views/home_screen.dart';
import '../../views/settings_screen.dart';
import '../../views/services_screen.dart';
import 'common_bottom_navigation.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _index;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ServicesScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: CommonBottomNavigation(
        selectedIndex: _index,
        showInServiceDetail: false,
        onDestinationSelected: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
