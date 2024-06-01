import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/routing/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import './config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register error handlers. For more info, see:
  // https://docs.flutter.dev/testing/errors
  registerErrorHandlers();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Load environment variables from .env file
  await dotenv.load();

  // Listen for Auth changes and refresh the router
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    goRouter.refresh();
  });

  runApp(MyApp(router: goRouter));
}

void registerErrorHandlers() {
  // Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
