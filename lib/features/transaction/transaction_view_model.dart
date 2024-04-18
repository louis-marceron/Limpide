import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import './transaction_model.dart';
import './transaction_service.dart';

class TransactionViewModel with ChangeNotifier {
  List<Transaction> _transactions = [];
  TransactionService _transactionService = TransactionService();
  TextEditingController labelController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<Transaction> get transactions => _transactions;

  List<Transaction> get recentTransactions => _transactions
      .where((transaction) =>
      transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
      .toList();

  Future<void> fetchTransactions(String userId) async {
    try {
      _transactions = await _transactionService.fetchTransactions(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
      // Handle the error appropriately, such as showing an error message
    }
  }

  void fetchTransactionsForCurrentUser() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // handle null case
      if (userId.isNotEmpty) {
        await fetchTransactions(userId);
      } else {
        print('User is not authenticated');
        // Handle case where user is not authenticated
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      // Handle the error appropriately
    }
  }

  Future<void> addTransaction(String userId) async {
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

  Transaction createUpdatedTransaction(Transaction oldTransaction, TransactionViewModel transactionController) {
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

  Future<void> updateTransaction(String userId, Transaction oldTransaction) async {
    final updatedTransaction = createUpdatedTransaction(oldTransaction, this);
    await _transactionService.updateTransaction(userId, updatedTransaction);
    int index = _transactions.indexWhere((t) => t.transactionId == updatedTransaction.transactionId);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String userId, String transactionId) async {
    await _transactionService.deleteTransaction(userId, transactionId);
    _transactions.removeWhere((transaction) => transaction.transactionId == transactionId);
    notifyListeners();
  }

  void updateSelectedDate(DateTime selectedDate) {
    dateController.text = selectedDate.toIso8601String();
  }

  Future<Transaction?> getTransactionById(String userId, String transactionId) async {
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

}
