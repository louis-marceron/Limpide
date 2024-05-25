import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:banking_app/common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// TODO category color
// TODO text max
class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  TransactionItemWidget({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final icon =
        categoryIcons[transaction.category] ?? Icons.local_taxi_outlined;

    final title = Flexible(
      child: Text(
        transaction.label,
        // What is this???
        overflow: TextOverflow.ellipsis,
        style: context.titleMedium?.copyWith(
          color: context.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

    final paymentSourceAndType = Text(
      'Wallet • ${formatDetailedDateTime(transaction.date)}',
      style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
    );

    final amount = Text(
      transaction.amount.toString(),
      style: context.titleMedium?.copyWith(
        color: context.onSurface,
      ),
    );

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CategoryIcon(icon: icon),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      title,
                      amount,
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(height: 4),
                  paymentSourceAndType,
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        context.goNamed("details", pathParameters: {
          'transactionId': transaction.transactionId,
        });
      },
      borderRadius: BorderRadius.circular(8),
    );
  }
}

// TODO max sizes for all texts and icons
class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;

  CategoryIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? context.surfaceContainerHigh,
      child: Icon(
        icon,
        color: context.onSurfaceVariant,
        size: 20,
      ),
      radius: 20,
    );
  }
}

String formatDetailedDateTime(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.isAfter(today)) {
    return DateFormat.jm().format(date);
  } else if (date.isAfter(yesterday)) {
    return DateFormat.jm().format(date);
  } else if (date.year == now.year) {
    return DateFormat.MMMd().format(date);
  } else {
    return DateFormat.yMMMEd().format(date);
  }
}
