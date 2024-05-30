import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:form_validator/form_validator.dart';
import '../../../common_widgets/snackbar/info_floating_snackbar.dart';
import '../../../common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({Key? key}) : super(key: key);

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Access the transaction controller after the widget is created
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);

    // Set default transaction type to "Expense" when the widget initializes
    transactionController
        .updateSelectedTransactionType({TransactionType.expense});

    // Set default date to today
    transactionController.updateSelectedDate(DateTime.now());
  }

  final _amountInputFormatters = [
    FilteringTextInputFormatter.deny(' '),
    FilteringTextInputFormatter.deny('-'),
    FilteringTextInputFormatter(',', allow: false, replacementString: '.'),
  ];

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);
    final isExpense = transactionController.typeController.text == 'Expense';

    // TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Debit'),
                          icon: Icon(Icons.remove),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Credit'),
                          icon: Icon(Icons.add),
                        ),
                      ],
                      selected: transactionController.selectedTransactionType,
                      onSelectionChanged: (selected) {
                        transactionController
                            .updateSelectedTransactionType(selected);
                        transactionController.notify();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: transactionController.labelController,
                maxLength: 64,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator:
                    ValidationBuilder().required('Title is required').build(),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: transactionController.amountController,
                inputFormatters: _amountInputFormatters,
                maxLength: amountMaxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  prefixText: isExpense ? '-' : '',
                  suffixText: 'PLN',
                  labelText: 'Amount',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: ValidationBuilder()
                    .regExp(RegExp(r'^(?=.*[1-9]).+$'), 'Amount cannot be null')
                    .required('Amount is required')
                    .build(),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed('categories');
                },
                child: Icon(
                  categories[transactionController.categoryController.text]
                          ?.icon ??
                      Icons.question_mark,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed('categories');
                },
                child: Icon(
                  categories[transactionController.categoryController.text]
                          ?.icon ??
                      Icons.question_mark,
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
                  if (_formKey.currentState!.validate()) {
                    // Check if form is valid
                    transactionController.addTransaction(userId);
                    InfoFloatingSnackbar.show(context, 'Transaction added');
                    context.pop();
                  }
                },
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
