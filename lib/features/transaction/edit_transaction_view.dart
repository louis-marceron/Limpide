import 'package:banking_app/features/transaction/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/features/transaction/transaction_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditTransactionView extends StatelessWidget {

  final String? transactionId;

  EditTransactionView({super.key, this.transactionId});

  @override
  Widget build(BuildContext context) {

    final transactionController = Provider.of<TransactionViewModel>(context);

    final userId = FirebaseAuth.instance.currentUser?.uid;

    var transaction = null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Center(
        child: FutureBuilder<Transaction?>(
          //TODO get the userId with service
          future: transactionController.getTransactionById(userId??"", transactionId??""),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if(snapshot.data == null){
                print(transactionId);
                print(userId);
                return Text('No Transaction found');
              } else {
                transaction = snapshot.data!;
                // Populate the controllers with transaction data
                transactionController.labelController.text = transaction.label;
                transactionController.amountController.text = transaction.amount.toString();
                transactionController.categoryController.text = transaction.category ?? '';
                transactionController.typeController.text = transaction.type;
                transactionController.bankNameController.text = transaction.bankName;
                transactionController.dateController.text = transaction.date.toString();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: transactionController.labelController,
                      decoration: InputDecoration(
                        labelText: 'Label',
                      ),
                    ),
                    TextField(
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
                        // Show date picker to select a new date
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: transactionController.dateController.text.isNotEmpty
                              ? DateTime.tryParse(transactionController.dateController.text) ?? DateTime.now()
                              : DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 2),
                        );

                        // Update selected date in ViewModel
                        if (selectedDate != null) {
                          print('Selected date: $selectedDate');
                          transactionController.updateSelectedDate(selectedDate);
                        } else {
                          print('No date selected');
                          print(transactionController.dateController.text.isNotEmpty
                              ? DateTime.tryParse(transactionController.dateController.text) ?? DateTime.now()
                              : DateTime.now());
                        }
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Create the updated transaction object using ViewModel method
                        final updatedTransaction = transactionController.createUpdatedTransaction(transaction, transactionController);

                        // Call the updateTransaction method from the ViewModel
                        transactionController.updateTransaction(userId ?? "", updatedTransaction);

                        // Navigate back to the previous screen
                        context.pop();
                      },
                      child: Text('Update Transaction'),
                    ),


                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
