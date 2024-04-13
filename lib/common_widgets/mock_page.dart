import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/routes.dart';

class MockPage extends StatelessWidget {
  const MockPage({this.welcomeText = 'Mock page', super.key});
  final String welcomeText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(Routes.profile),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
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
