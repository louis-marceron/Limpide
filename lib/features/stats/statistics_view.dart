import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../transaction/model/transaction_model.dart';
import '../transaction/viewmodel/transaction_view_model.dart';
import './charts/expenseByCategoryDonutChart.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> with SingleTickerProviderStateMixin {
  late int _selectedMonth;
  late int _selectedYear;
  late int _oldestMonth;
  late int _oldestYear;
  late int _totalMonths;
  late TabController _tabController;

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

  Future<void> _fetchOldestTransactionDate() async {
    final transactionController = Provider.of<TransactionViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final transactions = transactionController.transactions;
      if (transactions.isNotEmpty) {
        final oldestTransaction = transactions.reduce((a, b) => a.date.isBefore(b.date) ? a : b);
        final now = DateTime.now();
        setState(() {
          _oldestMonth = oldestTransaction.date.month;
          _oldestYear = oldestTransaction.date.year;
          _totalMonths = (now.year - _oldestYear) * 12 + now.month - _oldestMonth + 1;
          _tabController = TabController(length: _totalMonths, vsync: this, initialIndex: _totalMonths - 1);
          _tabController.addListener(_handleTabSelection);
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
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return FutureBuilder<void>(
      future: _fetchOldestTransactionDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Statistics'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return DefaultTabController(
            length: _totalMonths,
            initialIndex: _totalMonths - 1,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Statistics'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: TabBar(
                    controller: _tabController,
                    tabs: List<Widget>.generate(_totalMonths, (index) {
                      final monthIndex = (_oldestMonth + index - 1) % 12 + 1;
                      final yearOffset = (_oldestMonth + index - 1) ~/ 12;
                      final monthYear = DateTime(_oldestYear + yearOffset, monthIndex);
                      final monthName = _getMonthName(monthIndex);
                      return Tab(text: '$monthName ${monthYear.year}');
                    }),
                    isScrollable: true,
                  ),
                ),
              ),
              body: FutureBuilder<List<Transaction>>(
                future: transactionController.fetchAllTransactionForMonth(
                  userId,
                  _selectedMonth,
                  _selectedYear,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching transactions'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No transactions found for this month'));
                  } else {
                    final transactions = snapshot.data!;
                    final monthName = _getMonthName(_selectedMonth);

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Transactions for $monthName $_selectedYear'),
                            ExpenseDonutChart(transactions: transactions),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
