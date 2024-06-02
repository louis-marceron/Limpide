import 'package:banking_app/features/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:form_validator/form_validator.dart';
import '../../../common_widgets/snackbar/info_floating_snackbar.dart';
import '../../../common_widgets/category_icons.dart';
import 'package:banking_app/features/transaction/viewmodel/transaction_view_model.dart';

class TransactionFormView extends StatefulWidget {
  const TransactionFormView({super.key, this.transaction});

  final Transaction? transaction;

  @override
  _TransactionFormViewState createState() => _TransactionFormViewState();
}

class _TransactionFormViewState extends State<TransactionFormView> {
  late bool isEditing;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;
    isEditing = transaction != null;

    // Access the transaction controller after the widget is created
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);

    // transactionController.categoryController.addListener

    // Set default values
    if (transaction != null) {
      _isFormValid.value = true;
      transactionController.updateSelectedTransactionType(transaction.type);
      transactionController.dateTimeController.text =
          transaction.date.toIso8601String();
      transactionController.amountController.text =
          transaction.amount.toString();
      transactionController.labelController.text = transaction.label;
      transactionController.categoryController.text =
          transaction.category ?? 'Other';
    } else {
      transactionController
          .updateSelectedTransactionType(TransactionType.expense);
      transactionController.updateSelectedDateTime(
          selectedDate: DateTime.now(), selectedTime: TimeOfDay.now());
      transactionController.categoryController.text = 'Other';
    }

    // Add listeners to text controllers for title and amount fields
    transactionController.labelController.addListener(_validateForm);
    transactionController.amountController.addListener(_validateForm);
  }

  final _amountInputFormatters = [
    FilteringTextInputFormatter.deny(' '),
    FilteringTextInputFormatter.deny('-'),
    FilteringTextInputFormatter(',', allow: false, replacementString: '.'),
  ];

  void _validateForm() {
    final transactionController =
        Provider.of<TransactionViewModel>(context, listen: false);
    final isTitleFilled = transactionController.labelController.text.isNotEmpty;
    final isAmountFilled =
        transactionController.amountController.text.isNotEmpty;

    if (isTitleFilled && isAmountFilled) {
      _isFormValid.value = _formKey.currentState?.validate() ?? false;
    } else {
      _isFormValid.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionController = Provider.of<TransactionViewModel>(context);
    final isExpense = transactionController.typeController.text == 'Expense';
    // TODO use user service to get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit transaction' : 'New transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton(
                      style: ButtonStyle(
                        visualDensity: VisualDensity(vertical: 2),
                      ),
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
                      selected: {transactionController.typeController.text},
                      onSelectionChanged: (selected) {
                        transactionController
                            .updateSelectedTransactionType(selected.first);
                        transactionController.notify();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: transactionController.labelController,
                maxLength: 64,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  // Hide length counter
                  counterText: '',
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator:
                    ValidationBuilder().required('Title is required').build(),
                onChanged: (value) => _validateForm(),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: transactionController.amountController,
                inputFormatters: _amountInputFormatters,
                maxLength: amountMaxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: InputDecoration(
                  counterText: '',
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
                onChanged: (value) => _validateForm(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        // Stops keyboard from appearing
                        FocusScope.of(context).requestFocus(new FocusNode());
                        // Show DatePicker
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 3),
                          lastDate: DateTime(DateTime.now().year + 2),
                        );
                        // Update selected date in ViewModel
                        if (selectedDate != null) {
                          transactionController.updateSelectedDateTime(
                              selectedDate: selectedDate);
                        }
                      },
                      controller: TextEditingController(
                        text: formatToDate(
                            transactionController.dateTimeController.text),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      onTap: () async {
                        // Stops keyboard from appearing
                        FocusScope.of(context).requestFocus(new FocusNode());
                        // Show TimePicker
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        // Update selected time in ViewModel
                        if (selectedTime != null) {
                          transactionController.updateSelectedDateTime(
                              selectedTime: selectedTime);
                        }
                      },
                      controller: TextEditingController(
                        text: formatToTime(
                            transactionController.dateTimeController.text),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.pushNamed('categories');
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: transactionController.categoryController.text,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        categories[transactionController
                                    .categoryController.text]
                                ?.icon ??
                            Icons.question_mark,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _isFormValid,
                builder: (context, isFormValid, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              child: Container(
                                key: ValueKey<bool>(isLoading),
                                width: double
                                    .infinity, // Ensure the button takes the full width
                                child: FilledButton(
                                  onPressed: isFormValid && !isLoading
                                      ? () async {
                                          _isLoading.value = true;
                                          // Check if form is valid
                                          if (_formKey.currentState!
                                              .validate()) {
                                            try {
                                              final transaction =
                                                  widget.transaction;
                                              if (transaction != null) {
                                                await transactionController
                                                    .updateTransaction(
                                                        userId, transaction);
                                                InfoFloatingSnackbar.show(
                                                    context,
                                                    'Transaction edited');
                                              } else {
                                                await transactionController
                                                    .addTransaction(userId);
                                                InfoFloatingSnackbar.show(
                                                    context,
                                                    'Transaction added');
                                              }
                                              context.pop();
                                            } catch (e) {
                                              InfoFloatingSnackbar.show(
                                                  context,
                                                  isEditing
                                                      ? 'Failed to edit transaction'
                                                      : 'Failed to add transaction');
                                            } finally {
                                              _isLoading.value = false;
                                            }
                                          }
                                        }
                                      : null,
                                  child: isLoading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(isEditing
                                          ? 'Edit transaction'
                                          : 'Add transaction'),
                                  style: ButtonStyle(
                                    visualDensity: VisualDensity(
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatToTime(String dateTimeString) {
  try {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat timeFormat = DateFormat('HH:mm');
    return timeFormat.format(dateTime);
  } catch (e) {
    return 'Invalid DateTime';
  }
}

String formatToDate(String dateTimeString) {
  try {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  } catch (e) {
    return 'Invalid DateTime';
  }
}
