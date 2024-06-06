import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../transaction/viewmodel/transaction_view_model.dart';
import 'month_statistics_view.dart';
import '../utils/stats_utils.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView>
    with SingleTickerProviderStateMixin {
  late int _selectedMonth;
  late int _selectedYear;
  late int _oldestMonth;
  late int _oldestYear;
  late int _totalMonths;
  late TabController _tabController;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _oldestMonth = now.month;
    _oldestYear = now.year;
    _totalMonths = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOldestTransactionDate();
    });
  }

  @override
  void dispose() {
    if (_isTabControllerInitialized) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchOldestTransactionDate() async {
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final transactions = transactionController.transactions;
      if (transactions.isNotEmpty) {
        final oldestTransaction =
            transactions.reduce((a, b) => a.date.isBefore(b.date) ? a : b);
        final now = DateTime.now();
        setState(() {
          _oldestMonth = oldestTransaction.date.month;
          _oldestYear = oldestTransaction.date.year;
          _totalMonths =
              (now.year - _oldestYear) * 12 + now.month - _oldestMonth + 1;
          _tabController = TabController(
              length: _totalMonths,
              vsync: this,
              initialIndex: _totalMonths - 1);
          _tabController.addListener(_handleTabSelection);
          _isTabControllerInitialized = true;
        });
      }
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final index = _tabController.index;
      final monthIndex = (_oldestMonth + index - 1) % 12 + 1;
      final yearOffset = (_oldestMonth + index - 1) ~/ 12;
      final selectedMonthYear = DateTime(_oldestYear + yearOffset, monthIndex);
      setState(() {
        _selectedMonth = selectedMonthYear.month;
        _selectedYear = selectedMonthYear.year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    if (!_isTabControllerInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: TabBar(
                  controller: _tabController,
                  tabs: List<Widget>.generate(_totalMonths, (index) {
                    final monthIndex = (_oldestMonth + index - 1) % 12 + 1;
                    final yearOffset = (_oldestMonth + index - 1) ~/ 12;
                    final monthYear =
                        DateTime(_oldestYear + yearOffset, monthIndex);
                    final monthName = getMonthName(monthIndex);
                    return Tab(text: '$monthName ${monthYear.year}');
                  }),
                  isScrollable: true,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: List<Widget>.generate(_totalMonths, (index) {
            final monthIndex = (_oldestMonth + index - 1) % 12 + 1;
            final yearOffset = (_oldestMonth + index - 1) ~/ 12;
            final monthYear = DateTime(_oldestYear + yearOffset, monthIndex);
            return MonthStatisticsView(
              userId: userId,
              month: monthYear.month,
              year: monthYear.year,
            );
          }),
        ),
      ),
    );
  }
}
