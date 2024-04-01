import 'package:banking_app/home.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    super.key,
    required this.initialIndex,
  }) : assert(initialIndex >= 0 && initialIndex < routes.length,
            'initialIndex must be between 0 and ${routes.length - 1}.');

  final int initialIndex;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments),
          label: 'Transactions',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart),
          label: 'Statistics',
        ),
      ],
      onDestinationSelected: (int index) {
        // Use Navigator to change the screen without creating a new instance of CustomNavigationBar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                bottomNavigationBar: CustomNavigationBar(
                  initialIndex: index,
                ),
                body: routes[index]),
          ),
        );
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
    );
  }
}

const routes = <Widget>[
  const HomeScreen('Page 1'),
  const HomeScreen('Page 2'),
  const HomeScreen('Page 3'),
];
