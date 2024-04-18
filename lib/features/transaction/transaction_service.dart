import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import './transaction_model.dart';

class TransactionService {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;

  Future<List<Transaction>> fetchTransactions(String userId) async {

    try {
      print('Fetching transactions for user with ID: $userId');
      var querySnapshot = await _firestore
          .collection('users') // Assuming 'users' is the collection containing user documents
          .doc(userId)
          .collection('transactions') // Sub-collection under each user
          .get();
      return querySnapshot.docs
          .map((doc) => Transaction.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      print(e); // TODO Handle the error appropriately
      return [];
    }
  }

  Future<Transaction?> getTransactionById(String userId, String transactionId) async {
    try {
      var doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .get();
      if (doc.exists) {
        return Transaction.fromJson(doc.data()!);
      } else {
        return null; // TODO Handle the error appropriately
      }
    } catch (e) {
      print(e); // Handle the error appropriately, e.g., log the error
      return null; // or rethrow e;
    }
  }

  Future<void> addTransaction(String userId, Transaction transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.transactionId)
          .set(transaction.toJson());
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }

  Future<void> updateTransaction(String userId, Transaction transaction) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.transactionId)
          .update(transaction.toJson());
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }

  Future<void> deleteTransaction(String userId, String transactionId) async {
    print('Deleting transaction with ID: $transactionId');
    print('From user with ID: $userId');
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      print(e); // TODO Handle the error appropriately
    }
  }
}
