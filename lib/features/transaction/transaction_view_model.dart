import 'package:flutter/material.dart';
import './transaction_model.dart';
import './transaction_service.dart';

class TransactionViewModel with ChangeNotifier {
  List<Transaction> _transactions = [];
  TransactionService _transactionService = TransactionService();

  List<Transaction> get transactions => _transactions;

  List<Transaction> get recentTransactions => _transactions
      .where((transaction) =>
          transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
      .toList();

  Future<void> fetchTransactions() async {
    _transactions = await _transactionService.fetchTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionService.addTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionService.updateTransaction(transaction);
    int index = _transactions
        .indexWhere((t) => t.transactionId == transaction.transactionId);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionService.deleteTransaction(transactionId);
    _transactions.removeWhere(
        (transaction) => transaction.transactionId == transactionId);
    notifyListeners();
  }
}
