import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../transaction/model/transaction_model.dart';
import '../../transaction/viewmodel/transaction_view_model.dart';
import '../widget/balance_summary_widget.dart';
import '../charts/expense_by_category_donut_chart.dart';
import '../widget/expenses_by_category_card.dart';

class MonthStatisticsView extends StatefulWidget {
  final String userId;
  final int month;
  final int year;
  final bool showGraph;
  final VoidCallback toggleShowGraph;

  MonthStatisticsView({
    required this.userId,
    required this.month,
    required this.year,
    required this.showGraph,
    required this.toggleShowGraph,
  });

  @override
  _MonthStatisticsViewState createState() => _MonthStatisticsViewState();
}

class _MonthStatisticsViewState extends State<MonthStatisticsView> {
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

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        BalanceSummaryWidget(
                          title: null,
                          income: totalIncome,
                          expenses: totalExpenses,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                iconColor: Theme.of(context).colorScheme.primary,
                                textStyle: TextStyle(fontSize: 16),
                              ),
                              icon: Icon(widget.showGraph ? Icons.arrow_drop_down_sharp : Icons.arrow_right_sharp),
                              label: Text('Show/Hide Graph'),
                              onPressed: widget.toggleShowGraph,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if (widget.showGraph)
                          ExpenseDonutChart(
                            transactions: transactions,
                          ),
                        CategoryExpenseList(
                          userId: widget.userId,
                          month: widget.month,
                          year: widget.year,
                        ),
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
