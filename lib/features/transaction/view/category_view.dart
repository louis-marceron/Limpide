import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/category_icons.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    //TODO Create subcategories
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categoryIcons.length,
        itemBuilder: (context, index) {
          final category = categoryIcons.keys.elementAt(index);
          final iconData = categoryIcons.values.elementAt(index);

          return ListTile(
            leading: Icon(iconData), // Display the icon
            title: Text(category), // Display the text
            onTap: () {
              // Handle onTap event if needed

              Provider.of<TransactionViewModel>(context, listen: false)
                  .categoryController
                  .text = category;

              transactionController.categoryController.text = category;

              print("Dans le category view");
              print(transactionController.categoryController.text);

              print(category);

              context.pop(category);
            },
            iconColor: Theme.of(context).colorScheme.primary,
          );
        },
      ),
    );
  }
}
