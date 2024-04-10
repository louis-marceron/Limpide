import 'package:banking_app/mock_page.dart';
import 'package:banking_app/views/transactions_view.dart';
import 'package:flutter/material.dart';

const _routes = <Widget>[
  const MockPage('Page 1'),
  const TransactionsView(),
  const MockPage('Page 3'),
];

class NavigationScreen extends StatefulWidget {
  final int _initialIndex;

  NavigationScreen({
    super.key,
    required int initialIndex,
  })  : _initialIndex = initialIndex,
        assert(initialIndex >= 0 && initialIndex < _routes.length,
            'initialIndex must be between 0 and ${_routes.length - 1}.');

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int _currentPageIndex;
  final List<int> _navigationHistory = [];

  @override
  Widget build(BuildContext context) {
    // A PopScope is used to go to the previous children when the back
    // action is used
    return PopScope(
      onPopInvoked: _handlePop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentPageIndex,
          children: _routes,
        ),
        bottomNavigationBar: NavigationBar(
          destinations: <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.payments), label: 'Transactions'),
            NavigationDestination(
                icon: Icon(Icons.bar_chart), label: 'Statistics'),
          ],
          onDestinationSelected: _selectPage,
          selectedIndex: _currentPageIndex,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget._initialIndex;
    _navigationHistory.add(widget._initialIndex);
  }

  bool _handlePop(bool didPop) {
    // If the pop action failed, should never happen since canPop is
    // set to true
    if (!didPop) {
      return false;
    }

    if (_navigationHistory.length > 1) {
      setState(() {
        _navigationHistory.removeLast(); // Remove current page
        _currentPageIndex = _navigationHistory.last; // Set to previous page
      });
      return false; // Prevent default pop behavior
    }
    return true; // Allow pop if there's no history to revert to
  }

  void _selectPage(int index) {
    setState(() {
      _currentPageIndex = index;
      // Add to history only if it's not the same as the current page
      if (_navigationHistory.isEmpty || _navigationHistory.last != index) {
        _navigationHistory.add(index);
      }
    });
  }
}
