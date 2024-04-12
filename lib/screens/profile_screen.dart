import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_gate.dart';
import '../components/dialog/confirmation_delete_dialog.dart';
import '../components/dialog/ask_password_dialog.dart';
import '../components/snackbar/info_floating_snackbar.dart';
import '../components/dialog/confirmation_dialog.dart';
import '../components/dialog/ask_email_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  /**
   * Delete the account of the current user after checking the password
   */
  void _deleteAccount(BuildContext context) async {
    final enteredPassword = await showAskPasswordDialog(context);

    if (enteredPassword != null) {
      // If the password is entered, proceed with deleting the account
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential =
        EmailAuthProvider.credential(
            email: user.email!, password: enteredPassword);

        try {
          // Reauthenticate the user with the credential
          await user.reauthenticateWithCredential(credential);

          final confirmed = await showConfirmationDeletionDialog(
            context,
            'Are you sure you want to delete your account ?',
            'account'
          );

          if (confirmed == true) {
            try {
              await user.delete();
              Navigator.of(context).pop();
            } catch (errorDelete) {
              print('Failed to delete account: $errorDelete');
              InfoFloatingSnackbar.show(context, 'Failed to delete account');
            }
          }
        } catch (errorReauth) {
          print('Failed to reauthenticate: $errorReauth');
          InfoFloatingSnackbar.show(
              context, 'Wrong password. Please try again.');
        }
      }
    }
  }

  /**
   * Sign out the current user
   */
  void _signOut(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context,
      'Are you sure you want to log out ?',
    );

    if (confirm == true) {
      try {
        await FirebaseAuth.instance.signOut();
        InfoFloatingSnackbar.show(context, 'Logged out successfully');

        // Navigate to the AuthGate widget after signing out
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthGate()),
              (route) => false, // Prevents user from going back to the previous screen
        );
      } catch (e) {
        print('Failed to sign out: $e');
        // Handle sign out failure
        InfoFloatingSnackbar.show(context, 'Failed to log out');
      }
    } else {
      // User canceled the logout action
      InfoFloatingSnackbar.show(context, 'Logout canceled');
    }
  }


  /**
   * Reset the password of the current user after checking the password
   */
  void resetPassword(BuildContext context) async {
    final String? currentPassword = await showAskPasswordDialog(context);

    if (currentPassword != null) {
      final user = FirebaseAuth.instance.currentUser;

      print(user);
      if (user != null && user.email != null) {
        AuthCredential credential =
        EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);

        try {
          // Reauthenticate the user with the credential
          await user.reauthenticateWithCredential(credential);

          // If reauthentication is successful, send the password reset email
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: user.email!);
          InfoFloatingSnackbar.show(context,
              'Password reset email sent to ${user.email}'
          );
        } catch (e) {
          print('Failed to reauthenticate: $e');
          InfoFloatingSnackbar.show(
              context, 'Wrong password. Please try again.');
        }
      }
    } else {
      // Handle the case where the current password is null or not entered
      print('Current password is null or not entered');
    }
  }

  /**
   * Show a dialog to ask the user to enter the password
   */
  Future<String?> showAskPasswordDialog(BuildContext context) async {
    String? enteredPassword;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PasswordDialog(
          onPasswordEntered: (String password) {
            enteredPassword = password;
          },
        );
      },
    );
    return enteredPassword;
  }

  /**
   * Show a dialog to ask the user to enter the new email
   */
  Future<String?> showAskEmailDialog(BuildContext context) async {
    String? enteredEmail;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EmailDialog(
          onEmailEntered: (String email) {
            enteredEmail = email;
          },
        );
      },
    );
    return enteredEmail;
  }

  /**
   * Change the email of the current user after checking the password and the new email
   */
  void changeEmail(BuildContext context) async {
    final enteredPassword = await showAskPasswordDialog(context);

    if (enteredPassword != null) {
      // If the password is entered, proceed with changing the email
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential =
        EmailAuthProvider.credential(
            email: user.email!, password: enteredPassword);

        try {
          // Reauthenticate the user with the credential
          await user.reauthenticateWithCredential(credential);

          final enteredEmail = await showAskEmailDialog(context);

          if (enteredEmail != null) {
            try {
              await user.verifyBeforeUpdateEmail(enteredEmail);
              InfoFloatingSnackbar.show(context,
                  'An email was sent to ${enteredEmail} to verify the new email. Please check your inbox.');
            } catch (e) {
              InfoFloatingSnackbar.show(context, 'Failed to verify new email');
            }
          }
        } catch (e) {
          print('Failed to reauthenticate: $e');
          InfoFloatingSnackbar.show(
              context, 'Wrong password. Please try again.');
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final primaryColor = Theme.of(context).colorScheme.primary;

    final secondaryColor = Theme.of(context).colorScheme.secondary;

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
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Column(
              children: [
                Icon(Icons.account_circle_rounded, size: 100, color: Theme
                    .of(context)
                    .colorScheme
                    .onSecondaryContainer),
                SizedBox(height: 10),
                if (user != null) ...[
                  Text(
                    '${user.email}',
                    style: TextStyle(fontSize: 22, color: Theme
                        .of(context)
                        .colorScheme
                        .onSecondaryContainer),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Show the password dialog to change email
                    changeEmail(context);
                  },
                  child: ListTile(
                    tileColor: Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    title: Text("Change Email"),
                    leading: Icon(Icons.email, color: primaryColor),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    // Show the password dialog to reset password
                    resetPassword(context);
                  },
                  child: ListTile(
                    tileColor: Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    title: Text('Change Password'),
                    leading: Icon(Icons.lock_reset, color: primaryColor),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    _deleteAccount(context);
                  },
                  child: ListTile(
                    tileColor: Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    title: Text(
                        'Delete Account'),
                    leading: Icon(Icons.delete, color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}