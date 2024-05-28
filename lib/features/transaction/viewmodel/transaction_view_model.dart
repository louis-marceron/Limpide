import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/transaction_model.dart';
import '../service/transaction_service.dart';

class TransactionViewModel with ChangeNotifier {
  List<Transaction> _transactions = [];
  // For caching the transactions so that we don't have to fetch them again
  bool _hasFetchedTransactions = false;

  // FIXME use regular fields
  TransactionService _transactionService = TransactionService();
  TextEditingController labelController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<Transaction> get transactions => _transactions;

  Set<String> selectedTransactionType = {"Expense"};

  List<Transaction> get recentTransactions => _transactions
      .where((transaction) =>
          transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
      .toList();

  Future<List<Transaction>> fetchTransactions(String userId) async {
    if (!_hasFetchedTransactions) {
      // await Future.delayed(Duration(seconds: 3));
      _transactions = await _transactionService.fetchTransactions(userId);
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
    print('Adding transaction');
    print('Type : ${typeController.text}');
    // Create a new Transaction object using the data from controllers
    final transaction = Transaction(
      transactionId: Uuid().v4(),
      type: typeController.text,
      amount: double.parse(amountController.text),
      label: labelController.text,
      date: DateTime.parse(dateController.text),
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
      date: DateTime.parse(transactionController.dateController.text),
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

  void updateSelectedDate(DateTime selectedDate) {
    dateController.text = selectedDate.toIso8601String();
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
    dateController.clear();
  }

  Future<double> fetchTotalBalance(String userId) async {
    await fetchTransactions(userId);
    final double total = _transactions.fold(
        0.0,
        (total, transaction) => transaction.type == 'Expense'
            ? total - transaction.amount
            : total + transaction.amount);
    return total;
  }

  Future<double> fetchExpensesSinceBeginning(String userId) async {
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    return total;
  }

  Future<double> fetchIncomeSinceBeginning(String userId) async {
    await fetchTransactions(userId);
    final double total = _transactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
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

  void updateSelectedTransactionType(Set<String> selectedType) {
    selectedTransactionType = selectedType;
    typeController.text = selectedType.first;
  }

  void notify() {
    notifyListeners();
  }
}
