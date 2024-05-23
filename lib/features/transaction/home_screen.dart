import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/features/transaction/total_balance_widget.dart';
import 'package:banking_app/features/transaction/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:banking_app/common_widgets/root_app_bar.dart';

import 'balance_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: RootAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          // Fetching multiple values
          future: Future.wait([
            transactionViewModel.fetchTotalBalance(userId),
            transactionViewModel.fetchIncomeSinceBeginning(userId),
            transactionViewModel.fetchExpensesSinceBeginning(userId),
          ]),
          builder: (context, AsyncSnapshot<List<double>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TotalBalanceWidget(
                          title: 'Total Balance',
                          amount: snapshot.data![0], // Total balance
                        ),
                        const SizedBox(height: 32),
                        BalanceSummaryWidget(
                          title: 'Summary since beginning of time',
                          income: snapshot.data![1], // Income
                          expenses: snapshot.data![2], // Expenses
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin; // Add margin

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.elevation,
    this.shape,
    this.margin, // Initialize margin
  });

  @override
  Widget build(BuildContext context) {
    final shadow = Theme.of(context).colorScheme.shadow;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceVariant;

    return Card(
      shape: shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: color ?? surfaceVariant,
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 2.0,
      shadowColor: color ?? shadow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
