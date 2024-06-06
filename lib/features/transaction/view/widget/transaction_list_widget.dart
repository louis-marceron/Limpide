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

        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20),
          // Prevent FAB from hiding the last item
          padding: EdgeInsets.only(bottom: 128, top: 8),
          itemCount: transactionsByDay.length,
          itemBuilder: (context, index) {
            final dayTransactions = transactionsByDay[index];
            final date = dayTransactions[0].date;
            final formattedDate = formatRelativeDate(date);

            return TransactionGroupWidget(
              title: formattedDate,
              transactions: dayTransactions,
              key: ValueKey(formattedDate),
            );
          },
        );
      },
    );
  }

  List<List<Transaction>> _groupTransactionsByTimePeriod(
      List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> groupedTransactions = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    for (final transaction in transactions) {
      final transactionExactDate = transaction.date;
      final transactionMonthAndYear = DateTime(
        transaction.date.year,
        transaction.date.month,
      );
      final isToday = transactionExactDate.isAfter(today);
      final isYesterday = transactionExactDate.isAfter(yesterday);

      if (isToday) {
        if (!groupedTransactions.containsKey(today)) {
          groupedTransactions[today] = [];
        }
        groupedTransactions[today]!.add(transaction);
        continue;
      }

      if (isYesterday) {
        if (!groupedTransactions.containsKey(yesterday)) {
          groupedTransactions[yesterday] = [];
        }
        groupedTransactions[yesterday]!.add(transaction);
        continue;
      }

      if (!groupedTransactions.containsKey(transactionMonthAndYear)) {
        groupedTransactions[transactionMonthAndYear] = [];
      }
      groupedTransactions[transactionMonthAndYear]!.add(transaction);
    }

    // Convert map entries to a list and sort by date (most recent first)
    final sortedEntries = groupedTransactions.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    // Sort transactions within each group (most recent first)
    for (var entry in sortedEntries) {
      entry.value.sort((a, b) => b.date.compareTo(a.date));
    }

    // Convert sorted entries back to a map
    final sortedGroupedTransactions = Map.fromEntries(sortedEntries);

    return sortedGroupedTransactions.values.toList();
  }
}
