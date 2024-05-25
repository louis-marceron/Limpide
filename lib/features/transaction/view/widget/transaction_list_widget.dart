import 'package:banking_app/features/transaction/view/widget/transaction_group_widget.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.isAfter(today)) {
    return 'Today';
  } else if (date.isAfter(yesterday)) {
    return 'Yesterday';
  } else if (date.year == now.year) {
    return DateFormat.MMMM().format(date);
  } else {
    return DateFormat.yMMMM().format(date);
  }
}

class TransactionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionController, _) {
        // Group transactions by day
        final transactionsByDay =
            _groupTransactionsByTimePeriod(transactionController.transactions);

        return ListView.builder(
          // Prevent FAB from hiding the last item
          padding: EdgeInsets.only(bottom: 125),
          itemCount: transactionsByDay.length,
          itemBuilder: (context, index) {
            final dayTransactions = transactionsByDay[index];
            final date = dayTransactions[0].date;
            final formattedDate = formatRelativeDate(date);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TransactionGroupWidget(
                title: formattedDate,
                transactions: dayTransactions,
              ),
            );
          },
        );
      },
    );
  }

  List<List<Transaction>> _groupTransactionsByTimePeriod(
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
}
