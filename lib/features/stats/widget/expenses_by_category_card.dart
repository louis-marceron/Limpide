import 'package:banking_app/common_widgets/category_icons.dart';
import 'package:banking_app/extensions/color_extension.dart';
import 'package:banking_app/extensions/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routing/router.dart';
import '../../transaction/viewmodel/transaction_view_model.dart';

class CategoryExpenseList extends StatelessWidget {
  final int month;
  final int year;
  final String userId;

  CategoryExpenseList(
      {required this.month, required this.year, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: Provider.of<TransactionViewModel>(context, listen: false)
          .fetchCategoryExpenses(userId, month, year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching category expenses'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No category expenses found'));
        } else {
          final categoryExpenses = snapshot.data!;
          final totalExpenses =
              categoryExpenses.values.fold(0.0, (sum, item) => sum + item);

          return Column(
            children: categoryExpenses.keys.map((category) {
              final amount = categoryExpenses[category]!;
              final percentage = (amount / totalExpenses);

              // Assuming `categories` is a map with category information
              final categoryData = categories[category];
              if (categoryData == null) {
                return Container();
              }

              return Card(
                color: Theme.of(context).colorScheme.surface,
                margin: EdgeInsets.all(0),
                child: ListTile(
                  onTap: () {
                    goRouter.pushNamed("expensesByCategory", pathParameters: {
                      'userId': userId,
                      'category': category,
                      'month': month.toString(),
                      'year': year.toString()
                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: categoryData.color.withOpacity(0.2),
                    child: Icon(
                      categoryData.icon,
                      color: categoryData.color,
                      size: 20,
                    ),
                    radius: 20,
                  ),
                  title: Text(category),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${(percentage * 100).toStringAsFixed(2)}%',
                          style: TextStyle()),
                      SizedBox(height: 4.0),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: categoryData.color.withOpacity(0.2),
                        color: categoryData.color,
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                    ),
                    child: Text(
                      '- ' + amount.toString() + ' PLN',
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium?.copyWith(
                        color: context.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
