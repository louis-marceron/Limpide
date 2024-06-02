import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';
import '../service/transaction_service.dart';

class TransactionViewModel with ChangeNotifier {
  List<Transaction> _transactions = [];
  // For caching the transactions so that we don't have to fetch them again
  bool _hasFetchedTransactions = false;
  bool _isFetchingTransactions = false;

  TransactionService _transactionService = TransactionService();
  TextEditingController labelController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  TransactionViewModel() {
    formatAmount();
    trimLeftLabel();
  }

  // FIXME memory leak
  void formatAmount() {
    amountController.addListener(() {
      String text = amountController.text;
      int dotCount = '.'.allMatches(text).length;

      if (dotCount > 1) {
        int lastIndex = text.lastIndexOf('.');
        String formattedText =
            text.substring(0, lastIndex) + text.substring(lastIndex + 1);
        amountController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

  void trimLeftLabel() {
    labelController.addListener(() {
      String text = labelController.text;
      String trimmedText = text.trimLeft();

      if (text != trimmedText) {
        labelController.value = TextEditingValue(
          text: trimmedText,
          selection: TextSelection.collapsed(offset: trimmedText.length),
        );
      }
    });
  }

  List<Transaction> get transactions => _transactions;

  List<Transaction> get recentTransactions => _transactions
      .where((transaction) =>
          transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
      .toList();

  Future<List<Transaction>> fetchTransactions(String userId) async {
    if (!_isFetchingTransactions && !_hasFetchedTransactions) {
      // Prevent from doing multiple fetch when this function is called multiple
      // time at once
      _isFetchingTransactions = true;
      _transactions = await _transactionService.fetchTransactions(userId);
      _isFetchingTransactions = false;
      _hasFetchedTransactions = true;
      notifyListeners();
    }

    return _transactions;
  }

  Future<List<Transaction>> fetchTransactionsForCurrentUser() async {
    String userId =
        FirebaseAuth.instance.currentUser?.uid ?? ''; // handle null case
    if (userId.isNotEmpty) {
      return fetchTransactions(userId);
    } else {
      print('User is not authenticated');
      throw Error();
      // Handle case where user is not authenticated
    }
  }

  Future<void> addTransaction(String userId) async {
    // await Future.delayed(Duration(seconds: 3));
    print('Adding transaction');
    print('Type : ${typeController.text}');
    // Create a new Transaction object using the data from controllers
    final transaction = Transaction(
      transactionId: Uuid().v4(),
      type: typeController.text,
      amount: double.parse(amountController.text),
      label: labelController.text,
      date: DateTime.parse(dateTimeController.text),
      bankName: bankNameController.text,
      category: categoryController.text,
    );

    await _transactionService.addTransaction(userId, transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  Transaction createUpdatedTransaction(
      Transaction oldTransaction, TransactionViewModel transactionController) {
    return Transaction(
      transactionId: oldTransaction.transactionId,
      type: transactionController.typeController.text,
      amount: double.parse(transactionController.amountController.text),
      label: transactionController.labelController.text,
      date: DateTime.parse(transactionController.dateTimeController.text),
      bankName: transactionController.bankNameController.text,
      category: transactionController.categoryController.text,
    );
  }

  Future<void> updateTransaction(
      String userId, Transaction oldTransaction) async {
    final updatedTransaction = createUpdatedTransaction(oldTransaction, this);
    await _transactionService.updateTransaction(userId, updatedTransaction);
    int index = _transactions
        .indexWhere((t) => t.transactionId == updatedTransaction.transactionId);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String userId, String transactionId) async {
    await _transactionService.deleteTransaction(userId, transactionId);
    _transactions.removeWhere(
        (transaction) => transaction.transactionId == transactionId);
    notifyListeners();
  }

  void updateSelectedDateTime(
      {DateTime? selectedDate, TimeOfDay? selectedTime}) {
    final previousDateTimeString = dateTimeController.text;
    DateTime previousDateTime;

    try {
      previousDateTime = DateTime.parse(previousDateTimeString);
    } catch (e) {
      previousDateTime = DateTime.now();
    }

    // Create a new DateTime object with updated values
    DateTime newDateTime = DateTime(
      selectedDate?.year ?? previousDateTime.year,
      selectedDate?.month ?? previousDateTime.month,
      selectedDate?.day ?? previousDateTime.day,
      selectedTime?.hour ?? previousDateTime.hour,
      selectedTime?.minute ?? previousDateTime.minute,
    );

    // Update the controller with the new DateTime value in ISO 8601 format
    dateTimeController.text = newDateTime.toIso8601String();
  }

  Future<Transaction?> getTransactionById(
      String userId, String transactionId) async {
    return await _transactionService.getTransactionById(userId, transactionId);
  }

  void resetTransaction() {
    labelController.clear();
    amountController.clear();
    typeController.clear();
    bankNameController.clear();
    categoryController.clear();
    dateTimeController.clear();
  }

  Future<double> fetchTotalBalance(String userId) async {
    print('begin to fetchtotalbalance');
    await fetchTransactions(userId);
    final double total = _transactions.fold(
        0.0,
        (total, transaction) => transaction.type == 'Expense'
            ? total - transaction.amount
            : total + transaction.amount);
    print('end to fetchtotalbalance');
    return total;
  }

  Future<double> fetchExpensesSinceBeginning(String userId) async {
    print('begin to fetchexpensesincebeginning');
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    print('end to fetchexpensesincebeginning');
    return total;
  }

  Future<double> fetchIncomeSinceBeginning(String userId) async {
    print('begin to fetchincomsincebeginning');
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    print('end to fetchincomsincebeginning');
    return total;
  }

  Future<double> fetchExpensesForMonth(
      String userId, int month, int year) async {
    await fetchTransactions(userId); // Ensure transactions are loaded
    final double total = _transactions
        .where((transaction) =>
            transaction.type == 'Expense' &&
            transaction.date.month == month &&
            transaction.date.year == year)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return total;
  }

  Future<double> fetchIncomeForMonth(String userId, int month, int year) async {
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) =>
            transaction.type == 'Income' &&
            transaction.date.month == month &&
            transaction.date.year == year)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return total;
  }

  Future<double> fetchExpensesForYear(String userId, int year) async {
    await fetchTransactions(userId); // Ensure transactions are loaded
    final double total = _transactions
        .where((transaction) =>
            transaction.type == 'Expense' && transaction.date.year == year)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return total;
  }

  Future<double> fetchIncomeForYear(String userId, int year) async {
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) =>
            transaction.type == 'Income' && transaction.date.year == year)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return total;
  }

  void updateSelectedTransactionType(String selectedType) {
    typeController.text = selectedType;
  }

  void notify() {
    notifyListeners();
  }
}
