import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApplicationShell extends StatelessWidget {
  /// Shell for the application that contains the navigation bar.
  const ApplicationShell({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ??
                const ValueKey<String>(
                    'ApplicationShell')); // What is it supposed to do?
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Navigate to the initial location when tapping the item
      // that is already active
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.payments), label: 'Transactions'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart), label: 'Statistics'),
        ],
        onDestinationSelected: _goBranch,
        selectedIndex: navigationShell.currentIndex,
      ),
    );
  }
}
