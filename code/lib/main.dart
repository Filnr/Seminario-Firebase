import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/splash/auth_gate.dart';

const String environment = String.fromEnvironment(
  'ENV',
  defaultValue: 'dev',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String getEnvironmentName() {
    if (environment == 'prod') {
      return 'Produção';
    }

    return 'Desenvolvimento';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo - $environment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: AuthGate(
        environmentName: getEnvironmentName(),
      ),
    );
  }
}