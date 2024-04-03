import 'package:banking_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/transaction_controller.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionController>(context);

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
