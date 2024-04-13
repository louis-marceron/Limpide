import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './transaction_model.dart';
import './transaction_view_model.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactionController.transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactionController.transactions[index];
          return Card(
            child: ListTile(
              title: Text(transaction.label),
              subtitle: Text(
                  '${transaction.amount} - ${transaction.date.toString()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Code to edit transaction
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      transactionController
                          .deleteTransaction(transaction.transactionId);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          transactionController.addTransaction(Transaction(
              transactionId: 'id_super_secret',
              type: 'crédit',
              amount: 188,
              label: 'test transaction',
              date: DateTime.now(),
              bankName: ''));
        },
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }
}
