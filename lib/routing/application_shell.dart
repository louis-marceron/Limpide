import 'package:banking_app/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final Widget transactionIcon = SvgPicture.asset('assets/transaction.svg',
        colorFilter: ColorFilter.mode(
          context.onSurfaceVariant,
          BlendMode.srcIn,
        ),
        semanticsLabel: 'Transaction logo');

    final Widget homeOutlinedIcon = SvgPicture.asset('assets/home_outlined.svg',
        colorFilter: ColorFilter.mode(
          context.onSurfaceVariant,
          BlendMode.srcIn,
        ),
        semanticsLabel: 'Home logo');

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: <NavigationDestination>[
          NavigationDestination(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: homeOutlinedIcon,
              ),
              selectedIcon: Icon(Icons.home_filled),
              label: 'Home'),
          NavigationDestination(
            icon: transactionIcon,
            label: 'Transactions',
          ),
          NavigationDestination(
              icon: Icon(Icons.bar_chart), label: 'Statistics'),
        ],
        onDestinationSelected: _goBranch,
        selectedIndex: navigationShell.currentIndex,
      ),
    );
  }
}
