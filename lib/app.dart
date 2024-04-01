import 'package:flutter/material.dart';

import 'auth_gate.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return MaterialApp(
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
