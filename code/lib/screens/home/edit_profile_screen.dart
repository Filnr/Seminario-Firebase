import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String currentName;

  const EditProfileScreen({
    super.key,
    required this.uid,
    required this.currentName,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  final firestoreService = FirestoreService();

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.currentName,
    );
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await firestoreService.updateUserName(
        uid: widget.uid,
        newName: nameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso.'),
          ),
        );

        Navigator.pop(context);
      }
    } catch (_) {
      setState(() {
        errorMessage = 'Erro ao atualizar perfil.';
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
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Nome',
                icon: Icons.person,
                validator: validateName,
              ),

              const SizedBox(height: 16),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 24),

              CustomButton(
                text: 'Salvar alterações',
                isLoading: isLoading,
                onPressed: updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}