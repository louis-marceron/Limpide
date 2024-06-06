import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:flutter/material.dart';

class MonthlyAmountsSummaryWidget extends StatelessWidget {
  final double amount;
  final bool isIncome;

  MonthlyAmountsSummaryWidget({
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isIncome
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              child: isIncome
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.north_east,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? 'Income' : 'Expenses',
                  style: context.labelLarge!
                      .copyWith(color: context.onSurfaceVariant),
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      "${amount.toInt()} ",
                      style: context.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "PLN",
                      style: context.labelSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
