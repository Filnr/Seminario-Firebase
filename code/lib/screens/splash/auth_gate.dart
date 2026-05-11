import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../widgets/loading_widget.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class AuthGate extends StatelessWidget {
  final String environmentName;

  const AuthGate({
    super.key,
    required this.environmentName,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        if (snapshot.hasData) {
          return HomeScreen(
            environmentName: environmentName,
          );
        }

        return LoginScreen(
          environmentName: environmentName,
        );
      },
    );
  }
}