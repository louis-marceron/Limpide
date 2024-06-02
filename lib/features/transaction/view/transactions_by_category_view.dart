import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/transaction_view_model.dart';
import './widget/transaction_list_by_categories_widget.dart'; // Assuming you have a widget for displaying transactions

class TransactionsByCategoryView extends StatefulWidget {
  final String month;
  final String year;
  final String userId;
  final String category;

  const TransactionsByCategoryView({
    Key? key,
    required this.userId,
    required this.category,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  _TransactionsByCategoryViewState createState() => _TransactionsByCategoryViewState();
}

class _TransactionsByCategoryViewState extends State<TransactionsByCategoryView> {
  late TransactionViewModel transactionVM;
  late Future<void> transactionsFuture;

  @override
  void initState() {
    super.initState();
    transactionVM = Provider.of<TransactionViewModel>(context, listen: false);
    transactionsFuture = transactionVM.fetchExpenseTransactionsForCategoryAndDate(widget.userId, widget.category, widget.month, widget.year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Transactions'), // Display category in the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: FutureBuilder(
          future: transactionsFuture,
          builder: (context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return TransactionListByCategoriesWidget(
                userId: widget.userId,
                category: widget.category,
                month: widget.month,
                year: widget.year,
              ); // Use the widget for displaying transactions
            }
          },
        ),
      ),
    );
  }
}
