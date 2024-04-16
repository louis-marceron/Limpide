import 'package:banking_app/routing/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import './transaction_view_model.dart';

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
      transactionController = Provider.of<TransactionViewModel>(context, listen: false);
      transactionController.fetchTransactionsForCurrentUser();
    }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    @override
    void initState() {
      super.initState();
      transactionController.fetchTransactionsForCurrentUser();
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactionController.transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactionController.transactions[index];
          //TODO use user service to get the user id
          final userId = FirebaseAuth.instance.currentUser!.uid;

          //TODO get all the transactions of the user
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
                      var transactionId = transaction.transactionId;
                      print('Transaction ID: $transactionId');
                      context.pushNamed("edit", pathParameters: {
                        'transactionId': transactionId,
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      print('Delete Transaction');
                      print('Transaction ID: ${transaction.transactionId}');
                      print('User ID: $userId');
                      transactionController
                          .deleteTransaction(userId, transaction.transactionId);
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
          context.go('/transactions/add');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }
}
