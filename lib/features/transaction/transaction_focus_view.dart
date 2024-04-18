import 'package:banking_app/features/transaction/transaction_model.dart';
import 'package:banking_app/features/transaction/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'category_icons.dart';

class TransactionFocusView extends StatelessWidget {
  final String? transactionId;

  const TransactionFocusView({Key? key, this.transactionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Transaction?>(
      future: _fetchTransaction(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasError) {
          return _buildError(context, snapshot.error.toString());
        } else if (snapshot.data == null) {
          return _buildError(context, 'Transaction not found');
        } else {
          return _buildTransactionDetails(context, snapshot.data!);
        }
      },
    );
  }

  Future<Transaction?> _fetchTransaction(BuildContext context) async {
    final transactionController = Provider.of<TransactionViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw 'User not logged in';
    } else if (transactionId == null) {
      throw 'No transaction id provided';
    }

    return await transactionController.getTransactionById(userId, transactionId!);
  }

  Widget _buildLoading() {
    return _buildScaffoldWithAppBar(
      title: 'Transaction Details',
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return _buildScaffoldWithAppBar(
      title: 'Transaction Details',
      body: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildTransactionDetails(BuildContext context, Transaction transaction) {
    final transactionController = Provider.of<TransactionViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw 'User not logged in';
    }

    return _buildScaffoldWithAppBar(
      title: 'Transaction Details',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTransactionDetailRow('Transaction Label:', transaction.label),
            _buildTransactionDetailRow('Transaction Amount:', transaction.amount.toString()),
            _buildTransactionDetailRow('Transaction Date:', transaction.date.toString()),
            _buildTransactionDetailRow('Transaction Type:', transaction.type),
            Icon(categoryIcons[transaction.category] ?? Icons.attach_money),
            _buildButton(
              onPressed: () {
                var transactionId = transaction.transactionId;
                context.pushNamed("edit", pathParameters: {'transactionId': transactionId});
              },
              text: 'Edit',
            ),
            _buildButton(
              onPressed: () {
                transactionController.deleteTransaction(userId, transaction.transactionId);
                context.pop();
              },
              text: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildButton({required VoidCallback onPressed, required String text}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  Widget _buildScaffoldWithAppBar({required String title, required Widget body}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}
