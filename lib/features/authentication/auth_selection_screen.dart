import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 32)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0), // Adjust padding as needed
                ),
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200.0, 48.0), // Adjust size as needed
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondaryContainer,
                ),
                textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
              onPressed: () => context.go('/auth-selection-screen/login'),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0), // Add spacing between buttons
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0), // Adjust padding as needed
                ),
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(200.0, 48.0), // Adjust size as needed
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primaryContainer,
                ),
                textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              onPressed: () => context.go('/auth-selection-screen/register'),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
