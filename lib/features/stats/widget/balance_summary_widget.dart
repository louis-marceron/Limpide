import 'package:flutter/material.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final String? title;
  final double income;
  final double expenses;

  const BalanceSummaryWidget({
    Key? key,
    this.title,
    required this.income,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleMedium = theme.textTheme.titleMedium;
    final onPrimaryContainer = theme.colorScheme.onPrimaryContainer;
    final bodySmall = theme.textTheme.bodySmall;
    final titleLarge = theme.textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: titleMedium?.copyWith(
                fontSize: 16,
                color: onPrimaryContainer.withOpacity(0.85),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '▼ ',
                        style: bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Income',
                            style: bodySmall?.copyWith(
                              color: onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+\$${income.toStringAsFixed(2)}',
                      style: titleLarge?.copyWith(
                        color: onPrimaryContainer,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '▲ ',
                        style: bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Expenses',
                            style: bodySmall?.copyWith(
                              color: onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '-\$${expenses.toStringAsFixed(2)}',
                      style: titleLarge?.copyWith(
                        color: onPrimaryContainer,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
