import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/category_icons.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    // Get the keys and sort them alphabetically
    final sortedCategoryKeys = categories.keys.toList();
    sortedCategoryKeys.sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        title: Text('Change category'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: sortedCategoryKeys.length,
          itemBuilder: (context, index) {
            final category = sortedCategoryKeys[index];
            final categoryDetails = categories[category]!;
            final iconData = categoryDetails.icon;
            final iconColor = categoryDetails.color;

            return ListTile(
              leading: Icon(
                iconData,
                color: iconColor.withOpacity(0.7),
              ),
              title: Text(category),
              onTap: () {
                // Handle onTap event if needed
                Provider.of<TransactionViewModel>(context, listen: false)
                    .categoryController
                    .text = category;

                transactionController.categoryController.text = category;

                context.pop(category);
              },
            );
          },
        ),
      ),
    );
  }
}
