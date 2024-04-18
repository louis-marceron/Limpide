import 'package:banking_app/features/transaction/total_balance_widget.dart';
import 'package:banking_app/features/transaction/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        // FIXME add padding to the appshell instead
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: Provider.of<TransactionViewModel>(context)
              .fetchTotalBalance(userId),
          builder: (context, AsyncSnapshot<double> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return TotalBalanceWidget(
                title: 'Total Balance',
                amount: snapshot.data!,
              );
            } else {
              return Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}
