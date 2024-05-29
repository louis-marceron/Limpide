import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../transaction/model/transaction_model.dart';
import '../../transaction/viewmodel/transaction_view_model.dart';
import '../widget/balance_summary_widget.dart';
import '../charts/expense_by_category_donut_chart.dart';

class MonthStatisticsView extends StatefulWidget {
  final String userId;
  final int month;
  final int year;

  MonthStatisticsView({
    required this.userId,
    required this.month,
    required this.year,
  });

  @override
  _MonthStatisticsViewState createState() => _MonthStatisticsViewState();
}

class _MonthStatisticsViewState extends State<MonthStatisticsView> {
  bool _showGraph = true;

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    return FutureBuilder<double>(
      future: transactionController.fetchTotalBalance(widget.userId),
      builder: (context, balanceSnapshot) {
        if (balanceSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (balanceSnapshot.hasError) {
          return Center(child: Text('Error fetching balance'));
        } else if (!balanceSnapshot.hasData) {
          return Center(child: Text('No balance data found'));
        } else {
          return FutureBuilder<List<Transaction>>(
            future: transactionController.fetchAllTransactionForMonth(widget.userId, widget.month, widget.year),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching transactions'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No transactions found for this month'));
              } else {
                final transactions = snapshot.data!;

                double totalIncome = 0.0;
                double totalExpenses = 0.0;
                for (var transaction in transactions) {
                  if (transaction.type == 'Income') {
                    totalIncome += transaction.amount;
                  } else {
                    totalExpenses += transaction.amount;
                  }
                }

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        BalanceSummaryWidget(
                          title: '',
                          income: totalIncome,
                          expenses: totalExpenses,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: Icon(_showGraph ? Icons.arrow_drop_down_sharp : Icons.arrow_right_sharp),
                              label: Text('Show/Hide Graph'),
                              onPressed: () {
                                setState(() {
                                  _showGraph = !_showGraph;
                                });
                              },
                            ),
                          ],
                        ),
                        if (_showGraph) ExpenseDonutChart(transactions: transactions),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
