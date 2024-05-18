import 'package:banking_app/common_widgets/snackbar/info_floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validator/form_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;

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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: false,
                    border: OutlineInputBorder(),
                  ),
                  validator: ValidationBuilder().email('Enter a valid email').build(),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: false,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showPassword, // Hide or show password
                  validator: ValidationBuilder()
                      .minLength(6, 'Password must be at least 6 characters long')
                      .build(),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email') {
                          setState(() {
                            _emailController.text += ' '; // To trigger a rebuild
                          });
                          InfoFloatingSnackbar.show(context, 'Invalid email format.');
                        } else if (e.code == 'user-not-found') {
                          InfoFloatingSnackbar.show(context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            _passwordController.text += ' '; // To trigger a rebuild
                          });
                          InfoFloatingSnackbar.show(context, 'Incorrect password.');
                        } else {
                          InfoFloatingSnackbar.show(context, 'Failed to sign in: ${e.message}');
                        }
                      } catch (e) {
                        InfoFloatingSnackbar.show(context, 'An error occurred. Please try again.');
                      }
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
