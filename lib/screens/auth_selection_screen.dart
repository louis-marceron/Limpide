import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker', style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 32
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust padding as needed
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(200.0, 48.0), // Adjust size as needed
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondaryContainer,
                ),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0), // Add spacing between buttons
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust padding as needed
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(200.0, 48.0), // Adjust size as needed
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
