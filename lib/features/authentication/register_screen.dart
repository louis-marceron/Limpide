import 'package:banking_app/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:banking_app/common_widgets/snackbar/info_floating_snackbar.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        title: Text('Register'),
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
                  // Use email and password for registration logic
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    final user = FirebaseAuth.instance.currentUser;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .set({
                      'uid': user.uid,
                    });

                    // After successful registration, navigate to home screen
                    context.go(Routes.home);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      InfoFloatingSnackbar.show(
                          context, 'The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      InfoFloatingSnackbar.show(context,
                          'The account already exists for that email.');
                    }
                  } catch (e) {
                    InfoFloatingSnackbar.show(
                        context, 'An error occurred. Please try again.');
                  }
                },
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
