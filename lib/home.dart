import 'package:flutter/material.dart';
import 'screens/profile_screen.dart'; // Import the profile screen Dart file

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.welcomeText, {super.key});
  final String welcomeText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(), // Navigate to ProfileScreen
                ),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/dash.png'),
            Text(
              welcomeText,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
