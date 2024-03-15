import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/confirmation_delete_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  void _deleteAccount(BuildContext context) async {
    print('Deleting account');

    final user = FirebaseAuth.instance.currentUser;

    //await user?.reauthenticateWithCredential(credential);


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

  void resetPassword(BuildContext context, String? currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && currentPassword != null && user.email != null) {

      AuthCredential credential =
      EmailAuthProvider.credential(email: user.email!, password: currentPassword);

      try {
        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, send the password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to ${user.email}'),
          ),
        );
      } catch (e) {
        print('Failed to reauthenticate: $e');
        // Handle reauthentication errors accordingly
      }
    } else {
      // Handle the case where currentPassword is null
      print('Current password is null');
    }
  }



  void changeEmail(BuildContext context, String? currentPassword) async {
    // Implement the logic to change email
    // For example:
    // FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && currentPassword != null && user.email != null) {

      AuthCredential credential =
      EmailAuthProvider.credential(email: user.email!, password: currentPassword);

      try {
        // Reauthenticate the user with the credential
        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, update the email
        //TODO TextFIeld pour nouveau email
        await user.verifyBeforeUpdateEmail('TODO: new email address');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email updated to ${user.email}'),
          ),
        );
      } catch (e) {
        print('Failed to reauthenticate: $e');
        // Handle reauthentication errors accordingly
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[100],
            ),
            child: Column(
              children: [
                Icon(Icons.account_circle, size: 100),
                SizedBox(height: 10),
                if (user != null) ...[
                  Text(
                    'Email: ${user.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      changeEmail(context, "TODO: current password");
                    },
                    child: const Text("Change Email"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      resetPassword(context, "TODO: current password");
                    },
                    child: const Text('Reset Password'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _deleteAccount(context);
                    },
                    child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                  ),
                  // Add more widgets specific to the user screen
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
