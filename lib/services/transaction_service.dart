import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import '../models/transaction.dart';

class TransactionService {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;

  Future<List<Transaction>> fetchTransactions() async {
    try {
      var querySnapshot = await _firestore.collection('transactions').get();
      return querySnapshot.docs
          .map((doc) => Transaction.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print(e); // TODO Handle the error appropriately
      return [];
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction.toJson());
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.transactionId)
          .update(transaction.toJson());
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }
}
