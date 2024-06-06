import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:banking_app/features/transaction/view/widget/transaction_item_widget.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final currentMonth = DateTime.now().month;
  final currentYear = DateTime.now().year;
  late Future<double> totalBalanceFuture;

  @override
  void initState() {
    final transactionViewModel =
        Provider.of<TransactionViewModel>(context, listen: false);
    // Even if the result is not used, we call this function to fetch the data and display a pretty loading screen to the user
    totalBalanceFuture = transactionViewModel.fetchTotalBalance(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Consumer<TransactionViewModel>(
        builder: (context, transactionController, _) {
          late double totalBalance;
          late double expenseOfThisMonth;
          late double incomeOfThisMonth;
          late List<Transaction> recentTransactions;

          return FutureBuilder(
            future: Future.wait<void>(
              [
                transactionController
                    .fetchTotalBalance(userId)
                    .then((result) => totalBalance = result),
                transactionController
                    .fetchExpensesForMonth(userId, currentMonth, currentYear)
                    .then((result) => expenseOfThisMonth = result),
                transactionController
                    .fetchIncomeForMonth(userId, currentMonth, currentYear)
                    .then((result) => incomeOfThisMonth = result),
                transactionController
                    .fetchTransactions(userId)
                    .then((result) => recentTransactions = result.sublist(
                          0,
                          result.length >= 3 ? 3 : result.length,
                        )),
              ],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading the data'),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    _AmountWidget(amount: totalBalance),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'This month',
                          style: context.labelMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _MonthlyAmountsSummaryWidget(
                            amount: incomeOfThisMonth,
                            isIncome: true,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _MonthlyAmountsSummaryWidget(
                            amount: expenseOfThisMonth,
                            isIncome: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (recentTransactions.isNotEmpty)
                      _TransactionGroupWidget(
                        title: 'Recent transactions',
                        transactions: recentTransactions,
                      )
                  ],
                );
              } else {
                return const Center(child: Text("No data available"));
              }
            },
          );
        },
      ),
    );
  }
}

class _MonthlyAmountsSummaryWidget extends StatelessWidget {
  final double amount;
  final bool isIncome;

  _MonthlyAmountsSummaryWidget({
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isIncome
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              child: isIncome
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.north_east,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? 'Income' : 'Expenses',
                  style: context.labelLarge!
                      .copyWith(color: context.onSurfaceVariant),
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      "${amount.toInt()} ",
                      style: context.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "PLN",
                      style: context.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AmountWidget extends StatelessWidget {
  final double amount;

  _AmountWidget({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(height: 4),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        Text(
          ' PLN',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// UGLY - duplicate of a widget, but who cares?
class _TransactionGroupWidget extends StatelessWidget {
  _TransactionGroupWidget({
    super.key,
    required this.title,
    required this.transactions,
  });

  final String title;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: context.labelMedium,
        ),
        SizedBox(height: 8),
        Card(
          margin: EdgeInsets.all(0),
          color: context.surfaceContainerLow,
          // shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 4),
                  shrinkWrap: true,
                  // Prevent from scrolling inside a scrollable widget
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: this.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = this.transactions[index];
                    return TransactionItemWidget(
                      transaction: transaction,
                      key: ValueKey(transaction.transactionId),
                    );
                  },
                ),
                TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(
                    'Show all transactions',
                    style: context.labelLarge!.copyWith(color: context.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
