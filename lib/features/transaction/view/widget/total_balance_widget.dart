import 'package:flutter/material.dart';

class TotalBalanceWidget extends StatelessWidget {
  TotalBalanceWidget({
    super.key,
    required this.amount,
    required this.title,
  });
  final double amount;
  final String title;

  @override
  Widget build(context) {
    // FIXME use extensions to reduce boilerplate
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final headLineMedium = Theme.of(context).textTheme.headlineMedium;
    final onPrimaryContainer = Theme.of(context).colorScheme.onPrimaryContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleMedium?.copyWith(
            fontSize: 13,
            color: onPrimaryContainer.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),
        Text(amount.toString() + ' €',
            style: headLineMedium?.copyWith(
              color: onPrimaryContainer,
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }
}
