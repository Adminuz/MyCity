import 'package:flutter/material.dart';
import 'main_navigation.dart';

class CommonBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final bool showInServiceDetail;
  final Function(int)? onDestinationSelected;

  const CommonBottomNavigation({
    super.key,
    this.selectedIndex = 0,
    this.showInServiceDetail = false,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        if (showInServiceDetail) {
          // Если мы на странице деталей сервиса, возвращаемся к главной навигации
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainNavigation(initialIndex: index),
              ),
              (route) => false,
            );
          }
        } else if (onDestinationSelected != null) {
          // Если передан callback, используем его (для основной навигации)
          onDestinationSelected!(index);
        } else {
          // Fallback - переход к главной навигации
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => MainNavigation(initialIndex: index),
              ),
              (route) => false,
            );
          }
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Bosh sahifa',
        ),
        NavigationDestination(icon: Icon(Icons.apps), label: 'Xizmatlar'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Sozlamalar'),
      ],
    );
  }
}
