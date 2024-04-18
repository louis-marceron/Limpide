import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../common_widgets/snackbar/info_floating_snackbar.dart';
import 'category_icons.dart';
import 'package:banking_app/features/transaction/transaction_view_model.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    final nowDate = DateTime.now();

    //TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    transactionController.updateSelectedDate(nowDate);

    Set<String> selectedTransactionType = {"Income"}; // Initialize with default value

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: transactionController.labelController,
              decoration: InputDecoration(
                labelText: 'Label',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: transactionController.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            TextField(
              controller: transactionController.bankNameController,
              decoration: InputDecoration(
                labelText: 'Bank Name',
              ),
            ),
            SegmentedButton(
              style: SegmentedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                selectedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              segments: [
                ButtonSegment(
                  value: "Income",
                  label: Text('Income'),
                  icon: Icon(Icons.add),
                ),
                ButtonSegment(
                  value: "Expense",
                  label: Text('Expense'),
                  icon: Icon(Icons.remove),
                ),
              ],
              selected: selectedTransactionType, // Directly use currentTransactionType
              onSelectionChanged: (selected) {
                selectedTransactionType = selected;
                transactionController.typeController.text = selected.first;
                print('Selected: $selected');
                print('Type: ${transactionController.typeController.text}');
              },
              emptySelectionAllowed: false,
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('categories');
              },
              child: Icon(
                categoryIcons[transactionController.categoryController.text] ?? Icons.error,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Show DatePicker
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 2),
                );
                // Update selected date in ViewModel
                if (selectedDate != null) {
                  transactionController.updateSelectedDate(selectedDate);
                }
              },
              child: Icon(Icons.calendar_today),
            ),
            ElevatedButton(
              onPressed: () {
                transactionController.addTransaction(userId);

                transactionController.fetchTransactionsForCurrentUser();

                InfoFloatingSnackbar.show(context, 'Transaction added');

                context.pop();
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
