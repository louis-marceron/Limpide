import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:banking_app/features/transaction/view/widget/transaction_item_widget.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overflow_view/overflow_view.dart';
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
      padding: const EdgeInsets.only(bottom: 16, top: 8),
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
                    .then((result) => recentTransactions = result),
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
                    Container(
                        constraints: BoxConstraints(maxHeight: 120),
                        child:
                            Center(child: _AmountWidget(amount: totalBalance))),
                    SizedBox(height: 8),
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
                        SizedBox(width: 16),
                        Expanded(
                          child: _MonthlyAmountsSummaryWidget(
                            amount: expenseOfThisMonth,
                            isIncome: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Recent transactions',
                          style: context.labelMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (recentTransactions.isNotEmpty)
                      Expanded(
                        child: Card(
                          // color: context.surface,
                          margin: EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            // Display the right amount of transactions based on the screen size
                            child: OverflowView.flexible(
                              spacing: 8,
                              direction: Axis.vertical,
                              builder: (context, _) {
                                return TextButton(
                                  onPressed: () => context.go('/transactions'),
                                  child: Text(
                                    'Show all transactions',
                                    style: context.labelLarge!.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                );
                              },
                              children: <Widget>[
                                for (final transaction in recentTransactions)
                                  TransactionItemWidget(
                                    transaction: transaction,
                                    key: ValueKey(transaction.transactionId),
                                  ),
                              ],
                            ),
                          ),
                        ),
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
      margin: EdgeInsets.all(0),
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
                      style: context.labelSmall!.copyWith(
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
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [context.onSurfaceVariant, context.onSurface],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: Row(
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
              color: Colors.white, // Set to white for the gradient effect
            ),
          ),
          Text(
            ' PLN',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set to white for the gradient effect
            ),
          ),
        ],
      ),
    );
  }
}
