import 'package:banking_app/common_widgets/dialog/confirmation_delete_dialog.dart';
import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:banking_app/common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionItemWidget extends StatelessWidget {
  final Transaction transaction;

  TransactionItemWidget({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final icon = categories[transaction.category]?.icon ?? Icons.question_mark;
    final colorFilter =
        categories[transaction.category]?.color ?? Colors.transparent;
    // Format amount to 2 decimal places
    final bool isIncome = transaction.type == 'Income';
    final String amount = isIncome
        ? transaction.amount.toStringAsFixed(2)
        : '- ' + transaction.amount.toStringAsFixed(2);
    final Color amountColor = isIncome ? context.green : context.onSurface;
    final double amountBackgroundOpacity = isIncome ? 0.06 : 0.0;

    // FIXMe - this should not happen
    if (userId == null) {
      throw 'User not logged in';
    }

    final title = Flexible(
      child: Text(
        transaction.label,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: context.titleMedium?.copyWith(
          color: context.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

    final paymentSourceAndType = Text(
      'Wallet • ${formatDetailedDateTime(transaction.date)}',
      style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
      overflow: TextOverflow.ellipsis,
    );

    final amountText = Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: context.green.withOpacity(amountBackgroundOpacity),
      ),
      child: Text(
        amount.toString() + ' PLN',
        overflow: TextOverflow.ellipsis,
        style: context.titleMedium?.copyWith(
          color: amountColor,
        ),
      ),
    );

    return InkWell(
      highlightColor: context.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CategoryIcon(
              icon: icon,
              colorFilter: colorFilter,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      title,
                      amountText,
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
        showModalBottomSheet(
          // Add 16px margin on the left and right
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),
          useRootNavigator: true,
          context: context,
          showDragHandle: true,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showConfirmationDeletionDialog(
                              context,
                              'Are you sure you want to delete this transaction?',
                              transaction.label)
                          .then((value) {
                        if (value == true) {
                          transactionController.deleteTransaction(
                              userId, transaction.transactionId);
                          context.pop();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outlined,
                            color: context.onSurface,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Delete',
                            style: context.bodyMedium!
                                .copyWith(color: context.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      transactionController.resetTransaction();
                      Navigator.pop(context);
                      context.pushNamed(
                        "add",
                        extra: transaction,
                      );
                    },
                    splashColor: null,
                    highlightColor: null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: context.onSurface,
                            size: 24,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Edit',
                            style: context.bodyMedium!
                                .copyWith(color: context.onSurfaceVariant),
                            selectionColor: context.onSurface,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        // context.goNamed("details", pathParameters: {
        //   'transactionId': transaction.transactionId,
        // });
      },
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color colorFilter;

  CategoryIcon({
    super.key,
    required this.icon,
    required this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: colorFilter.withOpacity(0.2),
      child: Icon(
        icon,
        color: colorFilter.withOpacity(0.9),
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
