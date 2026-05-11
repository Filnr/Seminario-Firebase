import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/auth_exceptions.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String environmentName;

  const LoginScreen({
    super.key,
    required this.environmentName,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();
  final firestoreService = FirestoreService();

  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getAuthErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro inesperado: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loginWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final credential = await authService.loginWithGoogle();
      final user = credential.user;

      if (user != null) {
        await firestoreService.createUserProfile(
          user: user,
          name: user.displayName ?? 'Usuário Google',
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = getAuthErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao entrar com Google: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login - ${widget.environmentName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Icon(
                Icons.lock,
                size: 80,
                color: Colors.deepOrange,
              ),

              const SizedBox(height: 8),

              Text(
                'Ambiente: ${widget.environmentName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              CustomTextField(
                controller: emailController,
                label: 'E-mail',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: passwordController,
                label: 'Senha',
                icon: Icons.lock,
                obscureText: true,
                validator: validatePassword,
              ),

              const SizedBox(height: 16),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Entrar',
                isLoading: isLoading,
                onPressed: login,
              ),

              const SizedBox(height: 12),

              CustomButton(
                text: 'Entrar com Google',
                isLoading: isLoading,
                onPressed: loginWithGoogle,
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Criar nova conta'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text('Esqueci minha senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}