import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/confirmation_delete_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  void _deleteAccount(BuildContext context) async {
    print('Deleting account');
    final user = FirebaseAuth.instance.currentUser;

    final confirmed = await showConfirmationDialog(
      context,
      'Are you sure you want to delete your account ?',
    );

    if (confirmed == true && user != null) {
      try {
        print(user);
        await user.delete();
        Navigator.of(context).pop();
      } catch (e) {
        print('Failed to delete account: $e');
        // Handle errors accordingly
      }
    }
  }

  void _signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              // Perform sign-out action
              _signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('FDP'),
            OutlinedButton(
              onPressed: () {
                _deleteAccount(context);
              },
              child: const Text('Delete Account'),
            ),
            // Add more widgets specific to the user screen
          ],
        ),
      ),
    );
  }
}
