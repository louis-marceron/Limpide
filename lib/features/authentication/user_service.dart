import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class UserService {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;

  Future<String?> getUserIdByEmail(String email) async {
    try {
      var querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // Assuming user document ID is the user ID
      } else {
        return null; // User with given email not found
      }
    } catch (e) {
      print(e); // Handle the error appropriately
      return null;
    }
  }

  Future<void> createUser(String email, String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({'email': email});
    } catch (e) {
      print(e); // Handle the error appropriately
    }
  }

// Add more methods as needed, such as fetching user details, updating user information, etc.
}
