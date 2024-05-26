import 'package:banking_app/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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
        title: Text('Register'),
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: false,
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      ValidationBuilder().email('Enter a valid email').build(),
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
                      icon: Icon(_showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showPassword,
                  validator: ValidationBuilder()
                      .minLength(
                          6, 'Password must be at least 6 characters long')
                      .build(),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
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

                        context.go(Routes.home);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email') {
                          setState(() {
                            _emailController.text +=
                                ' '; // To trigger a rebuild
                          });
                          _formKey.currentState!.validate();
                        } else if (e.code == 'weak-password') {
                          setState(() {
                            _passwordController.text +=
                                ' '; // To trigger a rebuild
                          });
                          _formKey.currentState!.validate();
                        } else if (e.code == 'email-already-in-use') {
                          setState(() {
                            _emailController.text +=
                                ' '; // To trigger a rebuild
                          });
                          _formKey.currentState!.validate();
                        } else {
                          print(e.code);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
