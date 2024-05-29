import 'package:flutter/material.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final String title;
  final double income;
  final double expenses;

  const BalanceSummaryWidget({
    super.key,
    required this.title,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final onPrimaryContainer = Theme.of(context).colorScheme.onPrimaryContainer;
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final titleLarge = Theme.of(context).textTheme.titleLarge;

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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▼',
                      style: bodySmall?.copyWith(
                        // TODO remove hardcoded color
                        color: Colors.green,
                      ),
                      children: [
                        TextSpan(
                          text: 'Income',
                          style: bodySmall?.copyWith(
                            color: onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '+${income}',
                    style: titleLarge?.copyWith(
                      color: onPrimaryContainer,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '▲',
                      style: bodySmall?.copyWith(
                        // TODO remove hardcoded color
                        color: Colors.red,
                      ),
                      children: [
                        TextSpan(
                          text: 'Expenses',
                          style: bodySmall?.copyWith(
                            color: onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '-${expenses}',
                    style: titleLarge?.copyWith(
                      color: onPrimaryContainer,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
