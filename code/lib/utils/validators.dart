String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Digite seu nome.';
  }

  if (value.trim().length < 3) {
    return 'O nome deve ter pelo menos 3 caracteres.';
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Digite seu e-mail.';
  }

  if (!value.contains('@')) {
    return 'Digite um e-mail válido.';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Digite sua senha.';
  }

  if (value.trim().length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres.';
  }

  return null;
}