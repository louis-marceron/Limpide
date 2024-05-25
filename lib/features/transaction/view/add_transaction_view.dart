import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widgets/snackbar/info_floating_snackbar.dart';
import '../../../common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  @override
  void initState() {
    super.initState();

    // Access the transaction controller after the widget is created
    final transactionController = Provider.of<TransactionViewModel>(context, listen: false);

    // Set default transaction type to "Expense" when the widget initializes
    transactionController.updateSelectedTransactionType({"Expense"});

    // Set default date to today
    transactionController.updateSelectedDate(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    //TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

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
            Consumer<TransactionViewModel>(
              builder: (context, transactionController, _) {
                return SegmentedButton(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    selectedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  segments: [
                    ButtonSegment(
                      value: "Expense",
                      label: Text('Expense'),
                      icon: Icon(Icons.remove),
                    ),
                    ButtonSegment(
                      value: "Income",
                      label: Text('Income'),
                      icon: Icon(Icons.add),
                    ),
                  ],
                  selected: transactionController.selectedTransactionType,
                  onSelectionChanged: (selected) {
                    transactionController.updateSelectedTransactionType(selected);
                    transactionController.notify();
                  },
                  emptySelectionAllowed: false,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed('categories');
              },
              child: Icon(
                categoryIcons[transactionController.categoryController.text] ?? Icons.question_mark,
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

                //TODO show only if no error
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
