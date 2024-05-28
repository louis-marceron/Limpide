import 'package:banking_app/features/transaction/view/widget/transaction_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodel/transaction_view_model.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late TransactionViewModel transactionVM;
  late Future<void> transactionsFuture;

  @override
  void initState() {
    super.initState();
    transactionVM = Provider.of<TransactionViewModel>(context, listen: false);
    transactionsFuture = transactionVM.fetchTransactionsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Rebuild the view when the transaction list changes
      body: FutureBuilder(
        future: transactionsFuture,
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return TransactionListWidget();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Reset transaction and navigate to add transaction screen
          transactionVM.resetTransaction();
          context.push('/transactions/add');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }
}
