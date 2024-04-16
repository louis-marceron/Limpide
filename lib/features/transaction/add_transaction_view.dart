

import 'package:banking_app/features/transaction/transaction_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);

    final nowDate = DateTime.now();

    //TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    transactionController.updateSelectedDate(nowDate);

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
              controller: transactionController.categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            TextField(
              controller: transactionController.typeController,
              decoration: InputDecoration(
                labelText: 'Type',
              ),
            ),
            TextField(
              controller: transactionController.bankNameController,
              decoration: InputDecoration(
                labelText: 'Bank Name',
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
                context.go('/transactions');
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}