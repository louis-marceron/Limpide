import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:banking_app/features/transaction/view/widget/transaction_item_widget.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionGroupWidget extends StatelessWidget {
  TransactionGroupWidget({
    super.key,
    required this.title,
    required this.transactions,
  });

  final String title;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: context.labelMedium,
        ),
        SizedBox(height: 8),
        Card(
          margin: EdgeInsets.all(0),
          color: context.surfaceContainerLow,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 4),
              shrinkWrap: true,
              // Prevent from scrolling inside a scrollable widget
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.transactions.length,
              itemBuilder: (context, index) {
                final transaction = this.transactions[index];
                return TransactionItemWidget(
                  transaction: transaction,
                  key: ValueKey(transaction.transactionId),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
