import 'package:banking_app/features/transaction/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/routes.dart';
import './transaction_view_model.dart';
import './category_icons.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({Key? key}) : super(key: key);

  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late TransactionViewModel transactionController;

  @override
  void initState() {
    super.initState();
    // Initialize the transaction controller and fetch transactions
    transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);
    transactionController.fetchTransactionsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(Routes.profile),
          )
        ],
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionController, _) {
          // Group transactions by day
          final transactionsByDay =
              _groupTransactionsByDay(transactionController.transactions);

          return ListView.builder(
            itemCount: transactionsByDay.length,
            itemBuilder: (context, index) {
              final dayTransactions = transactionsByDay[index];
              final date = dayTransactions[0].date;
              final formattedDate = _getFormattedDate(date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dayTransactions.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 0), // Add Divider between transactions
                    itemBuilder: (context, index) {
                      final transaction = dayTransactions[index];
                      return _buildTransactionTile(context, transaction);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Reset transaction and navigate to add transaction screen
          transactionController.resetTransaction();
          context.push('/transactions/add');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction transaction) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .secondaryContainer, // Background color for transaction
      child: ListTile(
        style: ListTileStyle.list,
        leading:
            Icon(categoryIcons[transaction.category] ?? Icons.attach_money),
        iconColor: Theme.of(context).colorScheme.primary,
        title: Text(transaction.label),
        subtitle: Text(
          transaction.type,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        onTap: () {
          context.goNamed("details", pathParameters: {
            'transactionId': transaction.transactionId,
          });
        },
        //TODO add currency
        trailing: Text(transaction.amount.toString(),
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSecondaryContainer)),
      ),
    );
  }

  List<List<Transaction>> _groupTransactionsByDay(
      List<Transaction> transactions) {
    // Group transactions by day
    final Map<DateTime, List<Transaction>> groupedTransactions = {};
    for (final transaction in transactions) {
      final date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    // Convert map values to list
    return groupedTransactions.values.toList();
  }

  String _getFormattedDate(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;

    return '$weekday $day of $month of $year';
  }
}
