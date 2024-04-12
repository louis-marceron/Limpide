import 'package:banking_app/common_widgets/snackbar/info_floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true, // Hide password
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  // Use email and password for login logic
                  print('Email: $email, Password: $password');
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      InfoFloatingSnackbar.show(
                          context, 'No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      InfoFloatingSnackbar.show(
                          context, 'Wrong password. Please try again.');
                    } else {
                      InfoFloatingSnackbar.show(
                          context, 'Failed to login. Please try again.');
                    }
                  }
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
