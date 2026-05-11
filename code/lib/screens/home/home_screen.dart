import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/loading_widget.dart';
import 'edit_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String environmentName;

  const HomeScreen({
    super.key,
    required this.environmentName,
  });

  Future<void> logout() async {
    await AuthService().logout();
  }

  Future<void> reloadUser(BuildContext context) async {
    await AuthService().reloadUser();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status do e-mail atualizado.'),
      ),
    );
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    await AuthService().sendEmailVerification();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('E-mail de verificação reenviado.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestoreService = FirestoreService();

    if (user == null) {
      return const LoadingWidget();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Área autenticada - $environmentName'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestoreService.getUserProfileStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Perfil não encontrado.'),
            );
          }

          final data = snapshot.data!.data()!;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 90,
                  color: Colors.deepOrange,
                ),

                const SizedBox(height: 8),

                Text(
                  'Ambiente: $environmentName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Bem-vindo, ${data['name']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text('E-mail: ${data['email']}'),
                Text('Role: ${data['role']}'),

                const SizedBox(height: 12),

                Text(
                  user.emailVerified
                      ? 'E-mail verificado'
                      : 'E-mail ainda não verificado',
                  style: TextStyle(
                    color: user.emailVerified
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          uid: user.uid,
                          currentName: data['name'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar perfil'),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () => reloadUser(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Atualizar verificação de e-mail'),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: () => resendVerificationEmail(context),
                  icon: const Icon(Icons.email),
                  label: const Text('Reenviar verificação'),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}